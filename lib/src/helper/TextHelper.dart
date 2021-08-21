import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextHelper {
  bool isNumeric(String s) => int.tryParse(s) != null;

  ///
  Widget getTextWithReadMore(int maxLine, String text, Function() readMore,
      {String readMoreText = "Lihat selengkapnya",
      int marginOnText = 0,
      TextStyle? textStyleNonClickable,
      TextStyle? textStyleClickable}) {
    int length = getTextLengthDependOnWidth(maxLine: maxLine) - marginOnText;
    if (length > text.length)
      return Text(text, style: textStyleNonClickable ?? TextStyle());
    return RichText(
        text: TextSpan(
            style: textStyleNonClickable ?? TextStyle(),
            children: <TextSpan>[
          TextSpan(text: text.substring(0, length - (readMoreText.length + 6))),
          TextSpan(text: "..."),
          TextSpan(
              text: " " + readMoreText,
              style: textStyleClickable ?? TextStyle(),
              recognizer: TapGestureRecognizer()..onTap = readMore)
        ]));
  }

  //todo-me improve
  int getTextLengthDependOnWidth({int maxLine = 1}) {
    int result = 42 * maxLine;
    return result;
  }

  ///
  String getCodeName(String fullName) {
    if (fullName.isNotEmpty) {
      var code = fullName.split(" ");
      if (code.length > 1)
        return code[0].substring(0, 1).toUpperCase() +
            code[1].substring(0, 1).toUpperCase();
      if (fullName.length > 1) return fullName.substring(0, 2).toUpperCase();
      return fullName.substring(0, 1).toUpperCase();
    }
    return "-";
  }

  String getHiddenText(String text) {
    var hide = "";
    var first = "";
    if (text.isNotEmpty) {
      var index = text.length ~/ 2;

      first = text.substring(0, index);
      var second = text.substring(index);
      for (var data in second.split('')) {
        if (data == " ")
          hide += " ";
        else
          hide += "*";
      }
    }
    return first + hide;
  }

  ///
  String getCurrency(int amount, {bool withoutRp = false}) {
    var myFormat = new NumberFormat("#,###", "ind");
    if (withoutRp) return myFormat.format(amount);
    return "Rp. " + myFormat.format(amount);
  }

  String getCurrencyWithDecimal(double amount, {bool withoutRp = false}) {
    var myFormat = new NumberFormat("#,##0.00", "ind");
    var result = myFormat.format(amount);
    if (result.endsWith(",00"))
      result = result.substring(0, result.length - 3);
    else if (result.endsWith("0"))
      result = result.substring(0, result.length - 1);

    if (withoutRp) return result;
    return "Rp. " + result;
  }

  String getShortAmount(int amount, {String? textMany, String? textExtra}) {
    var result = "";
    if (amount < 1000)
      result = amount.toString();
    else if (amount < 1000000) {
      var currency = getCurrency(amount, withoutRp: true);
      result = currency.substring(0, currency.indexOf(".")) + " K";
    } else if (amount < 1000000000) {
      var currency = getCurrency(amount, withoutRp: true);
      result = currency.substring(0, currency.indexOf(".")) + " M";
    }

    if (result.isNotEmpty) {
      if (textExtra != null) return result += " $textExtra";
      return result;
    }
    return textMany ?? "many";
  }

  String removeCurrency(String text) => text.replaceAll(".", "");

  ///
  String convertNumberToText(String numberToFormat) {
    var formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 2,
      // if you want to add currency symbol then pass that in this else leave it empty.
      symbol: '',
    ).format(double.parse(numberToFormat));
    return formattedNumber;
  }

  String getTotalText(int count, String word) {
    var text = "";
    text += NumberFormat.compact().format(int.parse(count.toString()));
    text += " $word";
    return text;
  }
}
