import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pocketa/src/features/account/models/account.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class AccountCard extends HookWidget {
  const AccountCard({
    super.key,
    required this.account,
    required this.isCurrent,
    required this.onSelect,
  });

  final Account account;
  final bool isCurrent;
  final void Function(Account) onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CommonCard(
      selected: isCurrent,
      onTap: () => onSelect(account),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(account.name, style: theme.textTheme.titleMedium),
                    if (account.isDefault) ...[
                      const SizedBox(width: 8),
                      const CommonBadge(content: 'Default', variant: .primary),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${LocaleKeys.profile_base_currency.tr()}: ${account.baseCurrency}',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(128),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${LocaleKeys.profile_conversion_currency.tr()}: ${account.conversionCurrency}',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(128),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Switch Account Button
          Radio(value: account),
        ],
      ),
    );
  }
}
