# flutter_exif_rotation

This project is based on [flutter_exif_rotation](https://github.com/NGhebreial/flutter_exif_rotation) and provides image EXIF orientation correction functionality for OpenHarmony Flutter scenarios.

## 1. Installation and Usage

### 1.1 Installation

Navigate to your project directory and add the dependency in `pubspec.yaml`:

#### pubspec.yaml

```yaml
dependencies:
  flutter_exif_rotation:
    git:
      url: https://gitcode.com/org/OpenHarmony-Flutter/flutter_exif_rotation
      ref: master
```

Execute the command:

```bash
flutter pub get
```

### 1.2 Usage Example

For detailed usage examples, see [example](example/lib/main.dart).


## 2. Constraints
1. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
2. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
3. Flutter: 3.35.8-ohos-0.0.2; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;

## 3. Version and Framework Mapping
|       | 3.7 | 3.22 | 3.27 | 3.35
|-------|:---:|:----:|:----:|:----:|
| 1.0.0 |  ❌  |  ✅   |  ✅   |  ✅   |

## 4. API

> [!TIP] "ohos Support" column: yes means supported; no means not supported; partially means partially supported.

| Name | Description | Type | Input | Output | ohos Support |
| --- | --- | --- | --- | --- | --- |
| rotateImage | Fix image orientation | function | path: image path | File | yes |
| rotateAndSaveImage | Fix image orientation and save | function | path: image path | File | yes |

## 5. License

This project is licensed under the [BSD-3-Clause](LICENSE).
