import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  bool isImage(String url) {
    switch (url.split(".").last.toLowerCase()) {
      case "jpg":
      case "png":
      case "jpeg":
        return true;
      default:
        return false;
    }
  }

  Widget loadImageWidthSize(String url, double width, double height,
      {Map<String, String>? header,
      Color backgroundColor = Colors.black,
      TextStyle? textStyle}) {
    return CachedNetworkImage(
        imageUrl: url,
        httpHeaders: header ?? {"Content-Type": "application/json"},
        imageBuilder: (context, imageProvider) => SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              width: width,
              height: height,
            ),
        placeholder: (context, url) => loadDefaultImage(width, height,
            ext: "Loading",
            backgroundColor: backgroundColor,
            textStyle: textStyle),
        errorWidget: (context, url, error) => loadDefaultImage(width, height,
            backgroundColor: backgroundColor, textStyle: textStyle));
  }

  Widget loadDefaultImage(double width, double height,
          {String ext = "Photo",
          Color backgroundColor = Colors.black,
          TextStyle? textStyle}) =>
      SizedBox(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Center(
              child: Text(
            ext,
            style: textStyle ?? TextStyle(),
          )),
        ),
        width: width,
        height: height,
      );

  Widget loadAssetWithCircleBg(String path,
          {Color color = Colors.black,
          double radiusSize = 28,
          double padding = 6}) =>
      CircleAvatar(
        radius: radiusSize,
        backgroundColor: color,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(padding),
            width: 24,
            height: 24,
            child: Image.asset(path),
          ),
        ),
      );

  Widget loadUserPhoto(String url, String codeName,
      {double radiusSize = 28,
      double widthSize = 63,
      double heightSize = 63,
        double fontSize = 14,
      Map<String, String>? header}) {
    return CachedNetworkImage(
        imageUrl: url,
        httpHeaders: header ?? {"Content-Type": "application/json"},
        imageBuilder: (context, imageProvider) => SizedBox(
              child: CircleAvatar(
                radius: radiusSize,
                backgroundImage: imageProvider,
                backgroundColor: Colors.white,
              ),
              width: widthSize,
              height: heightSize,
            ),
        placeholder: (context, url) => loadCircleName(codeName,
            radiusSize: radiusSize,
            widthSize: widthSize,
            heightSize: heightSize),
        errorWidget: (context, url, error) => loadCircleName(codeName,
            radiusSize: radiusSize,
            widthSize: widthSize,
            heightSize: heightSize));
  }

  Widget loadCircleName(String codeName,
      {double radiusSize = 28,
      double widthSize = 63,
      double heightSize = 63,
      double fontSize = 14}) {
    var colorCircle = generateColor(codeName);
    return SizedBox(
      child: CircleAvatar(
        radius: radiusSize,
        backgroundColor: colorCircle,
        child: Text(
          codeName,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      ),
      width: widthSize,
      height: heightSize,
    );
  }

  Color generateColor(String codename) {
    var code = "";
    if (codename.isEmpty)
      code = "g";
    else
      code = codename[0].toLowerCase();
    if (code == 'a' || code == 'b' || code == 'c') return Color(0xffBB6BD9);
    if (code == 'd' || code == 'e' || code == 'f') return Color(0xff27AE60);
    if (code == 'g' || code == 'h' || code == 'i') return Color(0xff2D9CDB);
    if (code == 'j' || code == 'k' || code == 'l') return Color(0xffF2C94C);
    if (code == 'm' || code == 'n' || code == 'o') return Color(0xffF2994A);
    if (code == 'p' || code == 'q' || code == 'r') return Color(0xffEB5757);
    if (code == 's' || code == 't' || code == 'u') return Color(0xff2EE2B1);
    if (code == 'v' || code == 'w' || code == 'x') return Color(0xffE02884);
    if (code == 'y' || code == 'z') return Color(0xffEC8C9C);
    return Colors.black;
  }

  ///300kb
  //todo better way
  Future<File> compressImage(File fileImage,
      {int expectedSize = 300000, String path = "Pictures"}) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/$path';
    await Directory(dirPath).create(recursive: true);
    final String targetPath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}_compress.jpg';

    var currentSize = await fileImage.length();
    File? resultFile;
    var quality = 80;

    while (currentSize > expectedSize) {
      if (resultFile != null) {
        resultFile.deleteSync();
        quality = quality - 10;
      }

      resultFile = await FlutterImageCompress.compressAndGetFile(
        fileImage.absolute.path,
        targetPath,
        quality: quality,
      );
      currentSize = await resultFile!.length();
    }
    if (resultFile == null) return fileImage;
    return resultFile;
  }
}
