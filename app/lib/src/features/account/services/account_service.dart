import 'package:pocketa/src/features/account/models/account.dart';
import 'package:pocketa/src/features/account/models/account_payload.dart';
import 'package:pocketa/src/features/account/repository/account_repository.dart';
import 'package:pocketa/src/utils/riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_service.g.dart';

@Riverpod(name: r'$accountMutation')
class AccountMutation extends _$AccountMutation with AsyncNotifierMixin {
  late AccountRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read($accountRepository);
  }

  /// Create a new account. It will invalidate [AllAccountsQuery] and
  /// [CurrentAccountQuery] so they get updated values.
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
        ..invalidate($allAccountsQuery)
        ..invalidate($currentAccountQuery);
    });
  }

  /// Update an existing account. It will invalidate [AllAccountsQuery] and
  /// [CurrentAccountQuery] so they get updated values.
  Future<void> updateAc(Account account) async {
    await mutateState(() async {
      await _repo.update(account);

      ref
        ..invalidate($allAccountsQuery)
        ..invalidate($currentAccountQuery);
    });
  }

  /// Set the current account. It will invalidate [CurrentAccountQuery] and
  /// [AllAccountsQuery] so they get updated values.
  Future<void> setCurrent(Account account) async {
    await mutateState(() async {
      await _repo.setCurrent(account);
      ref
        ..invalidate($allAccountsQuery)
        ..invalidate($currentAccountQuery);
    });
  }
}

@Riverpod(keepAlive: true, name: r'$currentAccountQuery')
class CurrentAccountQuery extends _$CurrentAccountQuery
    with RequiresAuthMixin<Account> {
  @override
  Future<Account?> build() async {
    return whenAuthenticated((_) async {
      return ref.read($accountRepository).getCurrentOrElseCreate();
    });
  }
}

@Riverpod(keepAlive: true, name: r'$allAccountsQuery')
class AllAccountsQuery extends _$AllAccountsQuery
    with RequiresAuthMixin<AccountPayload> {
  @override
  Future<AccountPayload?> build() async {
    return whenAuthenticated((_) async {
      return ref.read($accountRepository).getAll();
    });
  }
}
