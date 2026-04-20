# flutter_exif_rotation

This project is based on [flutter_exif_rotation](https://pub.dev/packages/flutter_exif_rotation).

## Introduction
flutter_exif_rotation is a Flutter plugin for fixing image orientation issues that occur when photos are taken in landscape mode on some devices. The plugin reads the EXIF orientation information from images and automatically rotates them to the correct orientation.<br/>

## Installation

Navigate to your project directory and add the dependency in pubspec.yaml:

```yaml
dependencies:
  flutter_exif_rotation:
    git:
      url: https://gitcode.com/openharmony-sig/fluttertpc_flutter_exif_rotation.git
      ref: 0.5.2-ohos-1.0.0
```

Execute the command

```bash
flutter pub get
```

> TAG naming convention: `original-version-ohos-version-betax`. For changes between different TAGs, see OHOSCHANGELOG.md.

| Flutter Framework Version | TAG Name | Remarks |
| ---------------- | ----------------------- | ---- |
| 3.22.1-ohos-1.1.0 | 0.5.2-ohos-1.0.0 | |
| 3.27.5-ohos-1.0.4 | 0.5.2-ohos-1.0.0 | |
| 3.35.8-ohos-0.0.2 | 0.5.2-ohos-1.0.0 | |

## Constraints and Limitations

### Compatibility

Tested and verified in the following versions

1. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;
2. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;
3. Flutter: 3.35.8-ohos-0.0.2; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;

### Permission Requirements

None

## Usage Example
flutter_exif_rotation provides simple and easy-to-use APIs for fixing image orientation as shown in the following snippet:<br/>
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

  // Select image and fix orientation
  Future<void> getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Fix image orientation without saving to local storage
      File rotatedImage = await FlutterExifRotation.rotateImage(path: image.path);
      setState(() {
        _image = rotatedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_exif_rotation Example')),
      body: Center(
        child: _image == null
            ? const Text('No image selected')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Select Image',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Usage Instructions

### 1. Fix Image Orientation

Use the `rotateImage` method to fix image orientation and return the corrected File object:

```dart
File rotatedImage = await FlutterExifRotation.rotateImage(path: imagePath);
```

### 2. Fix Image Orientation and Save

Use the `rotateAndSaveImage` method to fix image orientation and save it to the device, returning the corrected File object:

```dart
File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(path: imagePath);
```

> Note: `rotateAndSaveImage` saves the corrected image to device storage, while `rotateImage` only processes in memory without occupying additional storage space.

## API Reference

### API

| Name | Type | Parameter Type | Return Type | OHOS Support | Description |
| -------- | -------- | -------- | ---------- | ------------- | -------- |
| rotateImage() | method | path: Image path (String) | File | yes | Fix image orientation |
| rotateAndSaveImage() | method | path: Image path (String) | File | yes | Fix image orientation and save |

## Known Issues

None

## Others

None

## Directory Structure

```
|---- flutter_exif_rotation
|     |---- android   # Android adapter code
|     |---- example   # Complete example app for multiple platforms
|           |---- lib  # Example code
|           |---- ohos # OpenHarmony project
|     |---- ios       # iOS adapter code
|     |---- lib       # Core code implementation
|           |---- flutter_exif_rotation.dart  # Main entry file of the library
|     |---- ohos      # OpenHarmony adapter code
|     |---- test      # Unit test files
|     |---- CHANGELOG.md              # Changelog
|     |---- LICENSE                   # License
|     |---- README.OpenHarmony_CN.md  # Chinese documentation
|     |---- README.OpenHarmony.md     # English documentation
|     |---- README.md                 # Original library documentation
|     |---- pubspec.yaml              # Configuration file
```

## Contributing

If you encounter any issues during use, please feel free to submit an [Issue](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_flutter_exif_rotation/issues). Of course, [PRs](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_flutter_exif_rotation/pulls) are also very welcome.

## License

This project is licensed under the [BSD-3-Clause](LICENSE). Please enjoy and participate in open source freely.
