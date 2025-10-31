import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/src/features/account/models/account.dart';

part 'account_payload.freezed.dart';

@freezed
abstract class AccountPayload with _$AccountPayload {
  const factory AccountPayload({required List<Account> accounts}) =
      _AccountPayload;
}
