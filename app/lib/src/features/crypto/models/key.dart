import 'package:freezed_annotation/freezed_annotation.dart';

part 'key.freezed.dart';
part 'key.g.dart';

@freezed
abstract class Key with _$Key {
  const factory Key({
    @JsonKey(name: 'encrypted_key') String? encryptedKeyb64,
    @JsonKey(name: 'salt') required String saltb64,
    @JsonKey(name: 'private_key') String? privateKeyb64,
  }) = _Key;

  factory Key.fromJson(Map<String, dynamic> json) => _$KeyFromJson(json);
}
