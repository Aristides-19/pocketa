import 'package:flutter/material.dart';
import 'package:pocketa/src/features/account/presentation/screens/accounts/widgets/widgets.dart';
import 'package:pocketa/src/router/routes.dart';
import 'package:pocketa/src/widgets/block/block.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBar(title: 'Accounts'),
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 33, vertical: 33),
          child: Column(
            children: [
              // const Expanded(child: Column()),
              // ListView.separated scrollbar component
              const Expanded(child: AccountsList()),

              // AccountList should implement it and listen to AllAccountsQuery
              // If the context is not mounted, don't pop
              // Success toaster for selected account, listen to errors, check possible errors

              // AccountCard with radio button to select it and account details
              // Should contain more info, including date created, if it's default, etc.
              // It should highlight the selected account besides radio button
              // Should listen to current account (CurrentAccountQuery)
              Button(
                label: '+ Add Account',
                onPressed: () => const AddAccountRoute().push(context),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
