import 'dart:convert';

import 'package:cryptography/cryptography.dart';

String secretBoxToBase64(SecretBox box) {
  final combined = <int>[...box.nonce, ...box.cipherText, ...box.mac.bytes];
  return base64Encode(combined);
}

SecretBox secretBoxFromBase64(String b64) {
  final bytes = base64Decode(b64);
  final nonce = bytes.sublist(0, 12);
  final macBytes = bytes.sublist(bytes.length - 16);
  final cipher = bytes.sublist(12, bytes.length - 16);
  return SecretBox(cipher, nonce: nonce, mac: Mac(macBytes));
}

Future<String> secretKeyToBase64(SecretKey key) async {
  return base64Encode(await key.extractBytes());
}

SecretKey secretKeyFromBase64(String b64) {
  return SecretKey(base64Decode(b64));
}
