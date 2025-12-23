import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/src/features/account/models/account.dart';

part 'account_payload.freezed.dart';

@freezed
abstract class AccountPayload with _$AccountPayload {
  const factory AccountPayload({required IList<Account> accounts}) =
      _AccountPayload;
}
