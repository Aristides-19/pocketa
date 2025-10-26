import 'package:pocketa/src/features/account/models/account.dart';
import 'package:pocketa/src/utils/riverpod/async_notifier_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_service.g.dart';

@Riverpod(keepAlive: true, name: 'profileProvider')
class AccountService extends _$AccountService with AsyncNotifierMixin {
  @override
  Future<Account> build() async {
    return const Account(
      id: 'default_id',
      name: 'Bank',
      baseCurrency: 'VES',
      conversionCurrency: 'USD',
      isDefault: true,
      type: AccountType.manual,
    );
  }
}
