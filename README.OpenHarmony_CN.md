# flutter_exif_rotation

本项目基于 [flutter_exif_rotation](https://pub.dev/packages/flutter_exif_rotation) 开发。

## 简介
flutter_exif_rotation 是一个 Flutter 插件，用于修正部分设备在拍摄横屏照片时产生的图片方向问题。该插件读取图片的 EXIF 方向信息，自动旋转图片至正确方向。<br/>

## 下载安装

进入到工程目录并在 pubspec.yaml 中添加以下依赖：

```yaml
dependencies:
  flutter_exif_rotation:
    git:
      url: https://gitcode.com/openharmony-sig/fluttertpc_flutter_exif_rotation.git
      ref: 0.5.2-ohos-1.0.0
```

执行命令

```bash
flutter pub get
```

> TAG 命名规则：`原库版本-ohos-版本号-betax`，不同 TAG 之间的变更详见 OHOSCHANGELOG.md。

| Flutter 框架版本 | TAG 名称 | 备注 |
| ---------------- | ----------------------- | ---- |
| 3.22.1-ohos-1.1.0 | 0.5.2-ohos-1.0.0 | |
| 3.27.5-ohos-1.0.4 | 0.5.2-ohos-1.0.0 | |
| 3.35.8-ohos-0.0.2 | 0.5.2-ohos-1.0.0 | |

## 约束与限制

### 兼容性

在以下版本中已测试通过

1. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;
2. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;
3. Flutter: 3.35.8-ohos-0.0.2; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;

### 权限要求

无

## 使用示例
flutter_exif_rotation 提供了简单易用的 API，让图片方向修正如以下片段所示：<br/>
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  final picker = ImagePicker();

  // 选择图片并修正方向
  Future<void> getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // 修正图片方向，不保存到本地
      File rotatedImage = await FlutterExifRotation.rotateImage(path: image.path);
      setState(() {
        _image = rotatedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_exif_rotation 示例')),
      body: Center(
        child: _image == null
            ? const Text('未选择图片')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: '选择图片',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## 使用说明

### 1. 修正图片方向

使用 `rotateImage` 方法修正图片方向，返回修正后的 File 对象：

```dart
File rotatedImage = await FlutterExifRotation.rotateImage(path: imagePath);
```

### 2. 修正图片方向并保存

使用 `rotateAndSaveImage` 方法修正图片方向并保存到设备，返回修正后的 File 对象：

```dart
File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(path: imagePath);
```

> 注意：`rotateAndSaveImage` 会将修正后的图片保存到设备存储空间，`rotateImage` 仅在内存中处理，不占用额外存储空间。

## 接口说明

### API

| 名称 | 类型 | 参数类型 | 返回值 | OHOS 平台支持 | 描述 |
| -------- | -------- | -------- | ---------- | ------------- | -------- |
| rotateImage() | 方法 | path: 图片路径（String） | File | yes | 修正图片方向 |
| rotateAndSaveImage() | 方法 | path: 图片路径（String） | File | yes | 修正图片方向并保存 |

## 遗留问题

无

## 其他

无

## 目录结构

```
|---- flutter_exif_rotation
|     |---- android   # Android 适配代码
|     |---- example   # 多平台的完整示例应用
|           |---- lib  # 示例代码
|           |---- ohos # OpenHarmony 工程
|     |---- ios       # iOS 适配代码
|     |---- lib       # 核心代码实现
|           |---- flutter_exif_rotation.dart  # 库的主入口文件
|     |---- ohos      # OpenHarmony 适配代码
|     |---- test      # 单元测试文件
|     |---- CHANGELOG.md              # 更新日志
|     |---- LICENSE                   # 开源协议
|     |---- README.OpenHarmony_CN.md  # 中文说明文档
|     |---- README.OpenHarmony.md     # 英文说明文档
|     |---- README.md                 # 原库说明文档
|     |---- pubspec.yaml              # 配置文件
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_flutter_exif_rotation/issues) ，当然，也非常欢迎发 [PR](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_flutter_exif_rotation/pulls) 共建。

## 开源协议

本项目基于 [BSD-3-Clause](LICENSE) ，请自由地享受和参与开源。
