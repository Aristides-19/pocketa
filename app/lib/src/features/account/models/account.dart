import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    @JsonKey(name: 'base_currency') required String baseCurrency,
    @JsonKey(name: 'conversion_currency') required String conversionCurrency,

    /// There is always at most (and at least) one default profile
    @JsonKey(name: 'is_default') required bool isDefault,
    required AccountType type,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

enum AccountType { manual, auto }
