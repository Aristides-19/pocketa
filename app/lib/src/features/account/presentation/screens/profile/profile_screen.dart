import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/account/models/types.dart';
import 'package:pocketa/src/features/account/presentation/screens/profile/widgets/widgets.dart';
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
    final theme = Theme.of(context);

    return RefreshableScreen(
      onRefresh: () async {
        ref.invalidate($allAccountsQuery);
        return await ref.refresh($currentAccountQuery.future);
      },
      child: ScrollableScreen(
        children: [
          // Auth Info
          const Center(child: AuthInfo()),

          // Profile Card
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
            onTap: () => ref.read($authMutation.notifier).logout(),
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
    );
  }
}
