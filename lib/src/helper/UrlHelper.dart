import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  void openToBrowser(String url) async {
    if (url.contains("whatsapp://send")) {
      url = url.replaceFirst("whatsapp://", "https://wa.me/");
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
}
