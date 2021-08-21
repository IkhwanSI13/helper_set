import 'TextHelper.dart';

class ValidatorHelper {
  static String errorEmpty = 'Tidak boleh kosong';

  String? validateText(String value, {String? errorMessage}) {
    if (value.isEmpty) return errorMessage ?? errorEmpty;
    return null;
  }

  String? validateObject(dynamic value, {String? errorMessage}) {
    if (value == null) return errorMessage ?? errorEmpty;
    return null;
  }

  ///

  static const maxNopd = 18;
  static const maxNop = 18;
  static const maxSkpd = 16;
  static const maxNpwp = 20;

  String? validateNop(String value,
      {String? errorMessage, String? errorMessage2}) {
    if (value.isEmpty) return errorMessage ?? errorEmpty;
    if (value.length < maxNop) return errorMessage2 ?? 'NOP tidak sesuai';
    return null;
  }

  String? validateMoney(String valueWithCurency, int minimalValue,
      {String? errorMessage, String? errorMessage2, String? errorMessage3}) {
    var value = TextHelper().removeCurrency(valueWithCurency);
    if (value.isEmpty) return errorMessage ?? errorEmpty;
    try {
      if (int.parse(value) < minimalValue)
        return errorMessage2 ??
            'Harus lebih dari ${TextHelper().getCurrency(minimalValue)}';
    } catch (e) {
      return errorMessage3 ?? "Format tidak sesuai";
    }
    return null;
  }

  String? validateYear(String value,
      {String? errorMessage, String? errorMessage2}) {
    if (value.isEmpty)
      return errorMessage ?? errorEmpty;
    else if (value.length != 4) return errorMessage2 ?? 'Not valid';
    return null;
  }

  String? validateMobile(String value,
      {String? errorMessage, String? errorMessage2}) {
    if (value.isEmpty) return errorMessage ?? errorEmpty;
    if (value.length < 10) return errorMessage2 ?? 'Harus lebih dari 9 angka';
    return null;
  }

  String? validateEmail(String value,
      {String? errorMessage, String? errorMessage2}) {
    if (value.isEmpty) return errorMessage ?? errorEmpty;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value)) return errorMessage2 ?? 'Email tidak valid';
    return null;
  }
}
