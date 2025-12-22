import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/account/models/types.dart';
import 'package:pocketa/src/features/account/presentation/widgets/widgets.dart';
import 'package:pocketa/src/features/account/services/account_service.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static final _sections = (
    profile: (
      title: LocaleKeys.profile_section_profile.tr(),
      children: <ProfileSection>[
        (
          title: LocaleKeys.profile_personal_data.tr(),
          leading: const FaIcon(FontAwesomeIcons.userGear),
          trailing: null,
          onTap: null,
        ),

        (
          title: LocaleKeys.profile_security.tr(),
          leading: const FaIcon(FontAwesomeIcons.shieldHalved),
          trailing: null,
          onTap: null,
        ),

        (
          title: LocaleKeys.profile_notifications.tr(),
          leading: const FaIcon(FontAwesomeIcons.bell),
          trailing: null,
          onTap: null,
        ),

        (
          title: LocaleKeys.profile_categories.tr(),
          leading: const FaIcon(FontAwesomeIcons.layerGroup),
          trailing: null,
          onTap: null,
        ),
      ],
    ),
    currentAccount: (
      title: LocaleKeys.profile_section_current_account.tr(),
      children: <ProfileSection>[
        (
          title: LocaleKeys.profile_edit_account.tr(),
          leading: const FaIcon(FontAwesomeIcons.tag),
          trailing: null,
          onTap: null,
        ),
      ],
    ),
    options: (
      title: LocaleKeys.profile_section_options.tr(),
      children: <ProfileSection>[
        (
          title: LocaleKeys.profile_dark_mode.tr(),
          leading: const FaIcon(FontAwesomeIcons.moon),
          trailing: const ThemeSwitcher(),
          onTap: null,
        ),
        (
          title: LocaleKeys.profile_language.tr(),
          leading: const FaIcon(FontAwesomeIcons.language),
          trailing: null,
          onTap: null,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStream);
    final theme = Theme.of(context);

    return auth.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const ErrorScreen(),
      data: (auth) => RefreshableScreen(
        onRefresh: () async {
          ref.invalidate(allAccounts);
          return await ref.refresh(currentAccount.future);
        },
        child: ScrollableScreen(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 84,
                    child: BoringAvatar(
                      name: auth.user?.$id ?? '',
                      type: .beam,
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

            // Profile Section
            const SizedBox(height: 24),
            ProfileItemsSection(section: _sections.profile),

            // Current Account Section
            const SizedBox(height: 16),
            ProfileItemsSection(section: _sections.currentAccount),

            // Options Section
            const SizedBox(height: 16),
            ProfileItemsSection(section: _sections.options),

            // Logout Button
            const SizedBox(height: 48),
            ProfileItem(
              text: LocaleKeys.auth_logout.tr(),
              trailing: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
              onTap: () => ref.read(authMutation.notifier).logout(),
            ),

            const SizedBox(height: 10),
            // App Version
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
