import 'package:pocketa/src/features/account/models/account.dart';
import 'package:pocketa/src/features/account/models/account_payload.dart';
import 'package:pocketa/src/features/account/repository/account_repository.dart';
import 'package:pocketa/src/utils/riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_service.g.dart';

@Riverpod(name: 'accountMutation')
class AccountMutation extends _$AccountMutation with AsyncNotifierMixin {
  late AccountRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read(accountRepository);
  }

  Future<void> create({
    required String name,
    required String baseCurrency,
    required String conversionCurrency,
    bool isDefault = false,
  }) async {
    await mutateState(() async {
      await _repo.create(
        name: name,
        baseCurrency: baseCurrency,
        conversionCurrency: conversionCurrency,
        isDefault: isDefault,
      );
      ref
        ..invalidate(allAccounts)
        ..invalidate(currentAccount);
    });
  }

  Future<void> updateAc(Account account) async {
    await mutateState(() async {
      await _repo.update(account);

      ref
        ..invalidate(allAccounts)
        ..invalidate(currentAccount);
    });
  }

  Future<void> setCurrent(Account account) async {
    await mutateState(() async {
      await _repo.setCurrent(account);
      ref
        ..invalidate(allAccounts)
        ..invalidate(currentAccount);
    });
  }
}

@Riverpod(keepAlive: true, name: 'currentAccount')
class CurrentAccount extends _$CurrentAccount with RequiresAuthMixin<Account> {
  @override
  Future<Account?> build() async {
    return whenAuthenticated((_) async {
      return ref.read(accountRepository).getCurrentOrElseCreate();
    });
  }
}

@Riverpod(keepAlive: true, name: 'allAccounts')
class AllAccounts extends _$AllAccounts with RequiresAuthMixin<AccountPayload> {
  @override
  Future<AccountPayload?> build() async {
    return whenAuthenticated((_) async {
      return ref.read(accountRepository).getAll();
    });
  }
}
