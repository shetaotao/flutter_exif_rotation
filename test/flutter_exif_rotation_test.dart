import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_exif_rotation');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '42';
        case 'rotateImage':
          return '/test/path/rotated_image.jpg';
        default:
          return null;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterExifRotation.platformVersion, '42');
  });

  test('rotateImage returns File with correct path', () async {
    final file = await FlutterExifRotation.rotateImage(path: '/test/image.jpg');
    expect(file.path, '/test/path/rotated_image.jpg');
  });

  test('rotateAndSaveImage returns File with correct path', () async {
    final file = await FlutterExifRotation.rotateAndSaveImage(path: '/test/image.jpg');
    expect(file.path, '/test/path/rotated_image.jpg');
  });

  test('rotateImage calls method channel with correct arguments', () async {
    String? capturedPath;
    bool? capturedSave;
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'rotateImage') {
        capturedPath = methodCall.arguments['path'];
        capturedSave = methodCall.arguments['save'];
      }
      return '/test/path/rotated_image.jpg';
    });

    await FlutterExifRotation.rotateImage(path: '/custom/path.jpg');
    expect(capturedPath, '/custom/path.jpg');
    expect(capturedSave, false);
  });

  test('rotateAndSaveImage calls method channel with save=true', () async {
    bool? capturedSave;
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'rotateImage') {
        capturedSave = methodCall.arguments['save'];
      }
      return '/test/path/rotated_image.jpg';
    });

    await FlutterExifRotation.rotateAndSaveImage(path: '/custom/path.jpg');
    expect(capturedSave, true);
  });

  test('rotateImage handles empty path gracefully', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'rotateImage') {
        return '/default/rotated.jpg';
      }
      return null;
    });

    final file = await FlutterExifRotation.rotateImage(path: '');
    expect(file.path, isNotEmpty);
  });
}
