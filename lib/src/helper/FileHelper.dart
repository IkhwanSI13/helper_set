import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static double convertByteToMb(int byte) {
    return byte / 1000000.0;
  }

  static double convertKbToMb(int byte) {
    return byte / 1000.0;
  }

  static double convertMbToByte(int byte) {
    return byte * 1000000.0;
  }

  static double convertMbToKb(int byte) {
    return byte * 1000.0;
  }

  Future<File> copyFile(String tempPath, String lastPath) async {
    var fileName = tempPath.split("/").last;
    var frontPath = (await getApplicationDocumentsDirectory()).path;
    var file = File(tempPath);

    var newPath = "$frontPath/$lastPath";
    var isAvailable = await Directory(newPath).exists();
    if (!isAvailable) await Directory(newPath).create(recursive: true);

    File newFile = await file.copy("$newPath/$fileName");
    return newFile;
  }

  Future<String> generatePath(String docName) async {
    var frontPath = (await getApplicationDocumentsDirectory()).path;

    var newPath = "$frontPath/$docName";
    var isAvailable = await Directory(newPath).exists();
    if (!isAvailable) await Directory(newPath).create(recursive: true);

    return "$newPath/";
  }

  Future<File> writeToImageFile(Uint8List data, String nameFile,
      {String? path, String? docName}) async {
    var filePath = "";
    if (path == null)
      filePath = await generatePath(docName ?? "Doc") + nameFile;
    else
      filePath = path + nameFile;

    return new File(filePath).writeAsBytes(data);
  }
}
