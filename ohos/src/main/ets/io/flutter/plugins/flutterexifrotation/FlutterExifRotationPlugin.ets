/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  AbilityAware,
  AbilityPluginBinding,
} from '@ohos/flutter_ohos';
import { image } from '@kit.ImageKit';
import { fileIo as fs, fileUri } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const CHANNEL_NAME: string = "flutter_exif_rotation";

// EXIF Orientation values (基于华为 Image Kit 文档，仅处理 1/3/6/8)
const ORIENTATION_NORMAL: number = 1; // 正常方向 "Top-left"
const ORIENTATION_ROTATE_180: number = 3; // 旋转180° "Bottom-right"
const ORIENTATION_ROTATE_90: number = 6; // 顺时针旋转90° "Right-top"
const ORIENTATION_ROTATE_270: number = 8; // 顺时针旋转270° "Left-bottom"

// EXIF Orientation 字符串映射表
const ORIENTATION_STRING_MAP: Map<string, number> = new Map([
  ["Top-left", 1],
  ["Bottom-right", 3],
  ["Right-top", 6],
  ["Left-bottom", 8]
]);

/** FlutterExifRotationPlugin **/
export default class FlutterExifRotationPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private channel: MethodChannel | null = null;
  private context: common.UIAbilityContext | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "FlutterExifRotationPlugin";
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
    this.channel.setMethodCallHandler(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
    }
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.context = binding.getAbility().context;
  }

  onDetachedFromAbility(): void {
    this.context = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "rotateImage") {
      this.handleRotateImage(call, result);
    } else {
      result.notImplemented();
    }
  }

  private handleRotateImage(call: MethodCall, result: MethodResult): void {
    let args: Map<string, Object> = call.args as Map<string, Object>;
    let photoPath: string | null = null;
    let save: boolean = false;

    let pathValue: Object | undefined = args.get("path");
    if (pathValue != null && pathValue != undefined) {
      photoPath = pathValue as string;
    }
    console.log("FlutterExifRotationPlugin photoPath ===" + photoPath);
    let saveValue: Object | undefined = args.get("save");
    if (saveValue != null && saveValue != undefined) {
      save = saveValue as boolean;
    }
    console.log("FlutterExifRotationPlugin save ===" + save);
    if (photoPath == null || photoPath.length == 0) {
      result.error("error", "path is required", null);
      return;
    }

    this.doRotateImage(photoPath, save, result);
  }

  private async doRotateImage(photoPath: string, save: boolean, result: MethodResult): Promise<void> {
    console.log("FlutterExifRotationPlugin photoPath ===" + photoPath);
    try {
      let imageSourceObj: image.ImageSource = image.createImageSource(photoPath);

      // 读取 EXIF Orientation 信息，getImageProperty 返回的是字符串表示（如 "Top-left"）
      let orientation: number = 1;
      try {
        let orientationStr: string = await imageSourceObj.getImageProperty(image.PropertyKey.ORIENTATION);
        console.log("FlutterExifRotationPlugin orientationStr ===" + orientationStr);
        // 尝试从字符串映射表获取对应的数值
        if (ORIENTATION_STRING_MAP.has(orientationStr)) {
          orientation = ORIENTATION_STRING_MAP.get(orientationStr)!;
          console.log("FlutterExifRotationPlugin found in map, value ===" + orientation);
        } else {
          console.log("FlutterExifRotationPlugin not found in map, keys ===" +
          Array.from(ORIENTATION_STRING_MAP.keys()));
          // 兼容处理：如果返回的是数字字符串
          let parsed: number = Number.parseInt(orientationStr, 10);
          if (!Number.isNaN(parsed)) {
            orientation = parsed;
            console.log("FlutterExifRotationPlugin parsed as number ===" + orientation);
          }
        }
      } catch (exifError) {
        // 图片不支持 EXIF 或无 EXIF 数据，视为正常方向
        console.log("FlutterExifRotationPlugin EXIF read error ===" + exifError);
        orientation = 1;
      }


      console.log("FlutterExifRotationPlugin mapped orientation ===" + orientation);
      let angle: number = FlutterExifRotationPlugin.getRotationAngle(orientation);
      console.log("FlutterExifRotationPlugin angle ===" + angle);

      // 解码图片为 PixelMap
      let decodingOpts: image.DecodingOptions = { editable: true };
      let pixelMap: image.PixelMap = await imageSourceObj.createPixelMap(decodingOpts);

      // 根据 EXIF Orientation 旋转图片
      await pixelMap.rotate(angle);

      // 编码为 JPEG（与 Bitmap.CompressFormat.JPEG quality=100 一致）
      let packer: image.ImagePacker = image.createImagePacker();
      let packOpts: image.PackingOption = {
        format: "image/jpeg",
        quality: 100,
        needsPackProperties: true  // 保留 EXIF 信息
      };
      packOpts.desiredDynamicRange = image.PackingDynamicRange.AUTO;
      let buffer: ArrayBuffer = await packer.packToData(pixelMap, packOpts);

      // 覆写回原文件
      let file: fs.File = fs.openSync(photoPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      fs.writeSync(file.fd, buffer);
      fs.closeSync(file.fd);
      console.info('FlutterExifRotationPlugin: openSync ');
      if (save && this.context != null) {
        await this.saveToGallery(buffer);
      }

      await pixelMap.release();
      await packer.release();
      await imageSourceObj.release();

      result.success(photoPath);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      result.error("FlutterExifRotationPlugin", "IOexception: " + e.message, null);
    }
  }

  private static getRotationAngle(orientation: number): number {
    if (orientation == ORIENTATION_ROTATE_90) {
      return 90;
    } else if (orientation == ORIENTATION_ROTATE_180) {
      return 180;
    } else if (orientation == ORIENTATION_ROTATE_270) {
      return 270;
    }
    return 0;
  }

  private async saveToGallery(buffer: ArrayBuffer): Promise<void> {
    if (this.context == null) {
      return;
    }
    try {
      let dirpath = this.context.tempDir + '/rotated_image.jpg';
      let dirFile = fs.openSync(dirpath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      fs.writeSync(dirFile.fd, buffer);
      fs.closeSync(dirFile);

      let dirUri = fileUri.getUriFromPath(dirpath);
      try {
        let srcFileUris: Array<string> = [dirUri];
        let photoCreationConfigs: Array<photoAccessHelper.PhotoCreationConfig> = [{
          fileNameExtension: 'jpg',
          photoType: photoAccessHelper.PhotoType.IMAGE,
        }];
        let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
        let desFileUris: Array<string> =
          await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
        console.info('FlutterExifRotationPlugin: showAssetsCreationDialog success, data is ' + desFileUris);
        if (desFileUris.length > 0) {
          try {
            let srcFile = fs.openSync(srcFileUris[0], fs.OpenMode.READ_ONLY);
            let desFile = fs.openSync(desFileUris[0], fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            fs.copyFileSync(srcFile.fd, desFile.fd);
            fs.closeSync(srcFile);
            fs.closeSync(desFile);
          } catch (e) {
            console.error('FlutterExifRotationPlugin: copy file failed', e);
          }
        }
      } catch (err) {
        console.error('FlutterExifRotationPlugin: showAssetsCreationDialog failed',
          `error: ${err.code}, ${err.message}`);
      }
    } catch (err) {
      console.error('FlutterExifRotationPlugin: saveFile failed', err);
    }
  }
}
