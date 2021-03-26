import 'TextHelper.dart';

class ValidatorHelper {
  static String errorEmpty = 'Tidak boleh kosong';

  String validateText(String value) {
    if (value.isEmpty) return errorEmpty;
    return null;
  }

  String validateObject(dynamic value) {
    if (value == null) return errorEmpty;
    return null;
  }

  static const maxNopd = 18;
  static const maxNop = 18;
  static const maxSkpd = 16;
  static const maxNpwp = 20;

  String validateNop(String value) {
    if (value.isEmpty) return errorEmpty;
    if (value.length < maxNop) return 'NOP tidak sesuai';
    return null;
  }

  String validateMoney(String valueWithCurency, int minimalValue) {
    var value = TextHelper().removeCurrency(valueWithCurency);
    if (value.isEmpty) return errorEmpty;
    try {
      if (int.parse(value) < minimalValue)
        return 'Harus lebih dari ${TextHelper().getCurrency(minimalValue)}';
    } catch (e) {
      return "Format tidak sesuai";
    }
    return null;
  }

  String validateYear(String value) {
    if (value.isEmpty)
      return errorEmpty;
    else if (value.length != 4) return 'Not valid';
    return null;
  }

  String validateDropDown(dynamic value) {
    if (value == null) return errorEmpty;
    return null;
  }

  String validateMobile(String value) {
    if (value.isEmpty) return errorEmpty;
    if (value.length < 10) return 'Harus lebih dari 9 angka';
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return errorEmpty;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) return 'Email tidak valid';
    return null;
  }
}
