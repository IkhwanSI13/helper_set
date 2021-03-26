import 'package:flutter/material.dart';

//    redmi 4x
//    I/flutter (30145): Ikhwan cek width:360.0
//    I/flutter (30145): Ikhwan cek height:640.0, constraint: 616
//    I/flutter (30145): Ikhwan cek height without SafeArea:616.0
//    total char on row with margin 16 on left and right: 42 char   ||  42: 360

//    mi8
//    I/flutter (15731): Ikhwan cek width:490.90908026892316
//    I/flutter (15731): Ikhwan cek height:1021.8181596708697
//    I/flutter (15731): Ikhwan cek height without SafeArea:981.3636150931529

class ScreenHelper {
  int sizeHeightNormal = 0;
  int sizeHeightBig = 1;

  int demandHeightNormal = 640;
  int demandHeightBig = 900;

  ///Use layout builder to pass bad habit
  double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

  int getTypeHeight(BuildContext context) {
    var height = getHeight(context);
    if (height > demandHeightBig) {
      return sizeHeightBig;
    }
    return sizeHeightNormal;
  }

  double getHeightDependOnWidth(
      BuildContext context, double imageWidth, double imageHeight) {
    var width = getWidth(context);
    return width * imageHeight / imageWidth;
  }
}
