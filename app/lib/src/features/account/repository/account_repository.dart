import 'dart:async';

import 'package:pocketa/src/features/account/models/account.dart';
import 'package:pocketa/src/features/account/models/account_payload.dart';
import 'package:pocketa/src/features/account/utils/exceptions.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/services/prefs_provider.dart';
import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'account_repository.g.dart';

class AccountRepository {
  AccountRepository(this._client, this._handler, this._prefs);

  final SupabaseClient _client;
  final SupabaseHandler _handler;
  final SharedPreferencesAsync _prefs;

  final _currentAccountKey = 'current_account_id';
  SupabaseQueryBuilder get _accountsdb => _client.from('accounts');
  String get _selectFields =>
      'id, name, base_currency, conversion_currency, is_default, type';

  Future<AccountPayload> getAll() async {
    return _handler.callPG(() async {
      final accounts = await _accountsdb
          .select(_selectFields)
          .then((data) => data.map((p) => Account.fromJson(p)).toList());

      return AccountPayload(accounts: accounts);
    });
  }

  Future<Account?> get(String id) async {
    return _handler.callPG(() {
      return _accountsdb
          .select(_selectFields)
          .eq('id', id)
          .limit(1)
          .maybeSingle()
          .then((data) => data == null ? null : Account.fromJson(data));
    });
  }

  /// It'll create the account in the database and return the created account.
  /// If isDefault is true, it'll set this account as the default one,
  /// unsetting any other default account.
  Future<Account> create({
    required String name,
    required String baseCurrency,
    required String conversionCurrency,
    bool isDefault = false,
  }) async {
    return _handler.callPG(() {
      return _accountsdb
          .insert({
            'name': name,
            'base_currency': baseCurrency,
            'conversion_currency': conversionCurrency,
            'is_default': isDefault,
          })
          .select(_selectFields)
          .limit(1)
          .single()
          .then((data) => Account.fromJson(data));
    }, exceptions: {const AccountLimitException()});
  }

  Future<Account> update(Account account) async {
    return _handler.callPG(() {
      return _accountsdb
          .update(
            Map.fromEntries(
              account.toJson().entries.where((e) => e.key != 'id'),
            ),
          )
          .eq('id', account.id)
          .select(_selectFields)
          .limit(1)
          .single()
          .then((data) => Account.fromJson(data));
    }, exceptions: {const CurrencyUpdateException()});
  }

  Future<void> setCurrent(Account account) async {
    return _handler.call(() async {
      await _prefs.setString(_currentAccountKey, account.id);
    });
  }

  Future<Account> getCurrentOrElseCreate() async {
    return _handler.callPG(() async {
      final currentAccountId = await _prefs.getString(_currentAccountKey);
      if (currentAccountId != null) {
        final currentAccount = await get(currentAccountId);
        if (currentAccount != null) return currentAccount;
      }

      final defaultAccount = await _accountsdb
          .select(_selectFields)
          .eq('is_default', true)
          .limit(1)
          .maybeSingle()
          .then((data) => data == null ? null : Account.fromJson(data));

      if (defaultAccount != null) {
        await setCurrent(defaultAccount);
        return defaultAccount;
      }

      return _createDefault();
    });
  }

  Future<void> clearCurrent() async {
    return _handler.call(() async {
      await _prefs.remove(_currentAccountKey);
    });
  }

  /// Call it when there are no accounts to create a default one.
  Future<Account> _createDefault() {
    return _handler.callPG(() async {
      final account = await create(
        name: LocaleKeys.profile_default_account.tr(),
        baseCurrency: 'USD',
        conversionCurrency: 'USD',
        isDefault: true,
      );
      await setCurrent(account);
      return account;
    });
  }
}

@Riverpod(keepAlive: true, name: r'$accountRepository')
AccountRepository accountRepo(Ref ref) => AccountRepository(
  ref.read($supabaseClient),
  ref.read($supabaseHandler),
  ref.read($asyncPreferences),
);
