import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/account/services/account_service.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/services/toaster_provider.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  Widget _buildSkeleton() {
    return CommonCard(
      child: Skeletonizer(
        child: Row(
          children: [
            const Column(
              crossAxisAlignment: .start,
              children: [
                ContainerSkeleton(width: 120, height: 20),
                SizedBox(height: 6),
                ContainerSkeleton(width: 150, height: 16),
                SizedBox(height: 4),
                ContainerSkeleton(width: 160, height: 16),
              ],
            ),
            const Spacer(),
            PIconButton(
              icon: const FaIcon(FontAwesomeIcons.shuffle),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(WidgetRef ref, AsyncValue account) {
    final theme = Theme.of(ref.context);

    return CommonCard(
      child: Row(
        children: [
          const SizedBox(width: 6),
          FaIcon(FontAwesomeIcons.xmark, color: theme.colorScheme.error),

          const SizedBox(width: 20),
          Expanded(child: Text(LocaleKeys.profile_account_load_error.tr())),

          // Retry Button
          LabelButton(
            label: LocaleKeys.actions_retry.tr(),
            onPressed: () => ref.refresh(currentAccount),
            color: theme.colorScheme.error,
            loading: account.isLoading,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final account = ref.watch(currentAccount);

    ref.listen((currentAccount), (_, curr) {
      if (curr.hasError && !curr.isLoading) {
        final e = curr.error;
        if (e is Exception) ref.read($toastService).showException(e);
      }
    });

    return account.when(
      loading: () => _buildSkeleton(),
      error: (_, _) => _buildError(ref, account),
      data: (account) => account == null
          ? _buildSkeleton()
          : CommonCard(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(account.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        '${LocaleKeys.profile_base_currency.tr()}: ${account.baseCurrency}',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withAlpha(
                            128,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${LocaleKeys.profile_conversion_currency.tr()}: ${account.conversionCurrency}',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withAlpha(
                            128,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Switch Account Button
                  PIconButton(
                    icon: const FaIcon(FontAwesomeIcons.shuffle),
                    onPressed: () {},
                    tooltip: LocaleKeys.profile_switch_account.tr(),
                  ),
                ],
              ),
            ),
    );
  }
}
