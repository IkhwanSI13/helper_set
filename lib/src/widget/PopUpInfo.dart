import 'dart:async';

import 'package:flutter/material.dart';

showUnexpectedProblem(BuildContext context, Function() onClickTryAgain,
    {String title = "Opss, terjadi kesalahan",
    String desc = "Mohon maaf terjadi kesalahan, coba ulangi kembali",
    String assetImage}) {
  PopUpInfo(context, title, desc,
      assetImage: assetImage, textButton: "Coba kembali", onClickBottom: () {
    onClickTryAgain();
  }).show();
}

showProblemWithoutAction(BuildContext context,
    {String title = "Opss, terjadi kesalahan",
    String desc = "Mohon maaf terjadi kesalahan, coba ulangi kembali",
    String assetImage}) {
  PopUpInfo(context, title, desc, assetImage: assetImage, showButton: false)
      .show();
}

showInternetProblem(BuildContext context, Function() onClickTryAgain,
    {String title = "Opss, Gagal tersambung",
    String desc =
        "Cek koneksi WI-FI atau kuota internet dan coba ulang kembali",
    String assetImage,
    String textButton = "Coba kembali"}) {
  PopUpInfo(context, title, desc,
      assetImage: assetImage, textButton: textButton, onClickBottom: () {
    onClickTryAgain();
  }).show();
}

class PopUpInfo {
  final BuildContext context;
  final String assetImage;
  final String title;
  final TextStyle titleTextStyle;
  final String desc;
  final TextStyle descTextStyle;
  final String textButton;
  final TextStyle buttonTextStyle;
  final bool showButton;
  final bool isDismiss;
  final Function() onClickClose;
  final Function() onClickBottom;
  final Function() onDismiss;

  PopUpInfo(this.context, this.title, this.desc,
      {this.assetImage,
      this.textButton = "",
      this.showButton = true,
      this.isDismiss = true,
      this.titleTextStyle,
      this.descTextStyle,
      this.buttonTextStyle,
      this.onClickClose,
      this.onClickBottom,
      this.onDismiss});

  showWithDelay({int duration = 1}) {
    Timer(Duration(seconds: duration), () {
      show();
    });
  }

  show() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: isDismiss,
        isDismissible: isDismiss,
        backgroundColor: Colors.white,
        builder: (BuildContext modalContext) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Container(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 24, right: 24),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              if (onClickClose == null)
                                Navigator.of(modalContext).pop();
                              else
                                onClickClose();
                            },
                            child: Image.asset("assets/images/ic_close.png",
                                width: 24, height: 24))),
                  ),
                  if (assetImage != null)
                    Center(
                        child: Container(
                            margin: EdgeInsets.only(bottom: 8),
                            height: 172,
                            child: Image.asset(assetImage))),
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(left: 24, right: 24),
                          child: Text(title,
                              style: titleTextStyle,
                              textAlign: TextAlign.center))),
                  if (title != desc && desc.isNotEmpty)
                    Center(
                        child: Container(
                            margin: EdgeInsets.only(
                                top: 8, bottom: 8, left: 18, right: 18),
                            child: Text(
                              desc,
                              style: descTextStyle,
                              textAlign: TextAlign.center,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ))),
                  if (showButton)
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (onClickBottom != null) onClickBottom();
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12),
                            child: Center(
                                child:
                                    Text(textButton, style: buttonTextStyle))),
                      ),
                    ),
                  Container(height: 18)
                ])),
          );
        }).whenComplete(() {
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }
}
