import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/account/presentation/widgets/widgets.dart';
import 'package:pocketa/src/features/account/services/account_service.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/services/toaster_service.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static final sections = (
    profile: (
      title: LocaleKeys.profile_section_profile.tr(),
      children: [
        (
          title: LocaleKeys.profile_personal_data.tr(),
          leading: const FaIcon(FontAwesomeIcons.userGear),
          trailing: null,
        ),

        (
          title: LocaleKeys.profile_security.tr(),
          leading: const FaIcon(FontAwesomeIcons.shieldHalved),
          trailing: null,
        ),

        (
          title: LocaleKeys.profile_notifications.tr(),
          leading: const FaIcon(FontAwesomeIcons.bell),
          trailing: null,
        ),

        (
          title: LocaleKeys.profile_categories.tr(),
          leading: const FaIcon(FontAwesomeIcons.layerGroup),
          trailing: null,
        ),
      ],
    ),
    currentAccount: (
      title: LocaleKeys.profile_section_current_account.tr(),
      children: [
        (
          title: LocaleKeys.profile_edit_account.tr(),
          leading: const FaIcon(FontAwesomeIcons.tag),
          trailing: null,
        ),
      ],
    ),
    options: (
      title: LocaleKeys.profile_section_options.tr(),
      children: [
        (
          title: LocaleKeys.profile_dark_mode.tr(),
          leading: const FaIcon(FontAwesomeIcons.moon),
          trailing: const ThemeSwitcher(),
        ),
        (
          title: LocaleKeys.profile_language.tr(),
          leading: const FaIcon(FontAwesomeIcons.language),
          trailing: null,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStreamProvider);
    final theme = Theme.of(context);

    return auth.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => ErrorScreen(
        onRetry: () async {
          await Future.value();
        },
      ),
      data: (auth) => RefreshableScreen(
        onRefresh: () => ref.refresh(accountProvider.future),
        child: ScrollableScreen(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 84,
                    child: BoringAvatar(
                      name: auth.user?.$id ?? '',
                      type: BoringAvatarType.beam,
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    auth.user?.name ?? '',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    auth.user?.email ?? '',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const SizedBox(width: double.infinity, child: ProfileCard()),

            const SizedBox(height: 24),
            ItemSection(section: sections.profile),

            const SizedBox(height: 16),
            ItemSection(section: sections.currentAccount),

            const SizedBox(height: 16),
            ItemSection(section: sections.options),

            const SizedBox(height: 48),
            Item(
              text: LocaleKeys.auth_logout.tr(),
              trailing: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
              onTap: () => ref.read(authMutationProvider.notifier).logout(),
            ),

            const SizedBox(height: 10),
            Text(
              'v${AppInfo.appVersion}',
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  Widget _buildSkeleton() {
    return CommonCard(
      child: Skeletonizer(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 20, color: Colors.white),
                const SizedBox(height: 6),
                Container(width: 150, height: 16, color: Colors.white),
                const SizedBox(height: 4),
                Container(width: 160, height: 16, color: Colors.white),
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

          LabelButton(
            label: LocaleKeys.actions_retry.tr(),
            onPressed: () => ref.refresh(accountProvider),
            color: theme.colorScheme.error,
            isLoading: account.isLoading,
            showLoading: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final account = ref.watch(accountProvider);

    ref.listen((accountProvider), (_, curr) {
      if (curr.hasError && !curr.isLoading) {
        final e = curr.error;
        if (e is Exception) ref.read(toastProvider).showException(e);
      }
    });

    return account.when(
      loading: () => _buildSkeleton(),
      error: (_, _) => _buildError(ref, account),
      data: (account) => CommonCard(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name, style: theme.textTheme.titleMedium),
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
            const Spacer(),
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
