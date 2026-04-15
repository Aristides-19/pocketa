import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/account/models/account.dart';
import 'package:pocketa/src/features/account/presentation/screens/accounts/widgets/account_card.dart';
import 'package:pocketa/src/features/account/services/account_service.dart';
import 'package:pocketa/src/utils/riverpod/riverpod.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class AccountsList extends HookConsumerWidget {
  const AccountsList({super.key});

  void _setCurrentAccount(WidgetRef ref, Account account) {
    log('Setting current account: ${account.name}');
    ref.read($accountMutation.notifier).setCurrent(account);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAccounts = ref.watch($allAccountsQuery);
    final currentAccount = ref.watch($currentAccountQuery);

    final accounts = (allAccounts, currentAccount).watch();

    return accounts.when(
      loading: () => Container(),
      error: (_, _) => Container(),
      data: (data) {
        final (payload, current) = data;

        if (payload == null || current == null) {
          return Container();
        }

        return RadioGroup(
          groupValue: current,
          onChanged: (_) {},

          /// Radio is purely visual here, should delete this and use Radio onTap for triggering father onSelect??
          child: CommonList(
            items: payload.accounts,
            itemBuilder: (ctx, i, account) => AccountCard(
              account: account,
              isCurrent: current == account,
              onSelect: (account) => _setCurrentAccount(ref, account),
            ),
          ),
        );
      },
    );
  }
}
