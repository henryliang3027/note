import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileRepository {
  //because user may delete the picture from gallery, we can't found the file in note if the file has been deleted
  //we can copy to TemporaryDirectory and keep the file
  Future<String> copyToTemporaryDirectory(String oldFilePath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = (oldFilePath.split('/').last);
    String newFilePath = tempPath + '/' + fileName;
    File imageFile = File(oldFilePath);
    File _ =
        await imageFile.copy(newFilePath); //No need to use return variable here
    print(newFilePath);
    return newFilePath;
  }

  //Save user's painting to TemporaryDirectory with DateTime as filename
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
