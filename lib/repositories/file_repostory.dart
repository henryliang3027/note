import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileRepository {
  Future<String> copyToTemporaryDirectory(String oldFilePath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = (oldFilePath.split('/').last);
    String newFilePath = tempPath + '/' + fileName;
    File imageFile = File(oldFilePath);
    File _ = await imageFile.copy(newFilePath);
    print(newFilePath);
    return newFilePath;
  }

  Future<String> saveToTemporaryDirectory(Uint8List pngBytes) async {
    String imageName = DateTime.now().toIso8601String() + ".png";
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String imageSavePath = tempPath + '/' + imageName;
    print('imageSavePath: $imageSavePath');
    await File(imageSavePath).writeAsBytes(pngBytes);
    return imageSavePath;
  }
}
