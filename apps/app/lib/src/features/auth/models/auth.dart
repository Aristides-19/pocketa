import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';

@freezed
abstract class Auth with _$Auth {
  const factory Auth({required String email, String? name}) = _Auth;
}
