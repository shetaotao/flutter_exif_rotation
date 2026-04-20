# flutter_exif_rotation

本项目基于 [flutter_exif_rotation](https://github.com/NGhebreial/flutter_exif_rotation) 开发，为 OpenHarmony Flutter 场景提供图片 EXIF 方向修正功能。

## 1. 安装与使用

### 1.1 安装方式

进入工程目录并在 `pubspec.yaml` 中添加依赖：

#### pubspec.yaml

```yaml
dependencies:
  flutter_exif_rotation:
    git:
      url: https://gitcode.com/org/OpenHarmony-Flutter/flutter_exif_rotation
      ref: master
```
执行命令：

```bash
flutter pub get
```

### 1.2 使用案例

使用案例详见 [example](example/lib/main.dart)。


## 2. 约束条件
1. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
2. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
3. Flutter: 3.35.8-ohos-0.0.2; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;

## 3. 版本和框架对应关系
|       | 3.7 | 3.22 | 3.27 | 3.35
|-------|:---:|:----:|:----:|:----:|
| 1.0.0 |  ❌  |  ✅   |  ✅   |  ✅   |

## 4. API

> [!TIP] "ohos Support" 列：yes 表示支持；no 表示不支持；partially 表示部分支持。

| Name | Description | Type | Input | Output | ohos Support |
| --- | --- | --- | --- | --- | --- |
| rotateImage | 修正图片方向 | function | path: 图片路径 | File | yes |
| rotateAndSaveImage | 修正图片方向并保存 | function | path: 图片路径 | File | yes |

## 5. 开源协议

本项目基于 [BSD-3-Clause](LICENSE) 开源。
