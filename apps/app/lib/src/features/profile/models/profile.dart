import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String $id,
    required String name,
    required String baseCurrencyCode,
    required String displayCurrencyCode,
    bool? $default,
  }) = _Profile;
}
