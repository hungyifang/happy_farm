import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class NonceGenerator {
  final values = List<int>.generate(32, (_) => Random.secure().nextInt(256));

  String get nonce =>
      sha256.convert(utf8.encode(base64Url.encode(values))).toString();
  String get rawNonce => base64Url.encode(values);
}
