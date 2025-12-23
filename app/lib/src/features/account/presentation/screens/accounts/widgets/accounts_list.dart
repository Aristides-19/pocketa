import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/account/services/account_service.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class AccountsList extends ConsumerWidget {
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAccounts = ref.watch($allAccountsQuery);

    return allAccounts.when(
      loading: () => Container(),
      error: (_, _) => Container(),
      data: (payload) => payload == null
          ? Container()
          : CommonList(
              items: payload.accounts,
              itemBuilder: (ctx, i, account) {
                return Text(account.toString());
              },
            ),
    );
  }
}
