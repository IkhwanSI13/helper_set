import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashHelper {
  String hashSha256(String text) =>
      (sha256.convert(utf8.encode(text))).toString();

  String hashMd5(String text) => md5.convert(utf8.encode(text)).toString();
}
