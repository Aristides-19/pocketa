import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/profile/presentation/widgets/widgets.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static final Map<String, Map<String, Object>> sections = {
    'account': {
      'title': LocaleKeys.profile_section_account.tr(),
      'children': [
        {
          'title': LocaleKeys.profile_personal_data.tr(),
          'leading': const FaIcon(FontAwesomeIcons.userGear),
        },
        {
          'title': LocaleKeys.profile_security.tr(),
          'leading': const FaIcon(FontAwesomeIcons.shieldHalved),
        },
        {
          'title': LocaleKeys.profile_notifications.tr(),
          'leading': const FaIcon(FontAwesomeIcons.bell),
        },
        {
          'title': LocaleKeys.profile_categories.tr(),
          'leading': const FaIcon(FontAwesomeIcons.layerGroup),
        },
      ],
    },
    'current_profile': {
      'title': LocaleKeys.profile_section_current_profile.tr(),
      'children': [
        {
          'title': LocaleKeys.profile_edit_profile.tr(),
          'leading': const FaIcon(FontAwesomeIcons.tag),
        },
      ],
    },
    'options': {
      'title': LocaleKeys.profile_section_options.tr(),
      'children': [
        {
          'title': LocaleKeys.profile_dark_mode.tr(),
          'leading': const FaIcon(FontAwesomeIcons.moon),
          'trailing': const ThemeSwitcher(),
        },
        {
          'title': LocaleKeys.profile_language.tr(),
          'leading': const FaIcon(FontAwesomeIcons.language),
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final theme = Theme.of(context);

    return ScrollableScreen(
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(
                width: 84,
                child: BoringAvatar(
                  name: auth.value?.user?.$id ?? '',
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
                auth.value?.user?.name ?? '',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                auth.value?.user?.email ?? '',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withAlpha(128),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        ItemSection(section: sections['account']!),

        const SizedBox(height: 16),
        ItemSection(section: sections['current_profile']!),

        const SizedBox(height: 16),
        ItemSection(section: sections['options']!),

        const SizedBox(height: 48),
        Item(
          text: LocaleKeys.auth_logout.tr(),
          trailing: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
          onTap: () {
            if (!auth.isLoading) ref.read(authProvider.notifier).logout();
          },
        ),

        const SizedBox(height: 10),
        Text(
          'v${AppInfo.appVersion}',
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withAlpha(72),
          ),
        ),
      ],
    );
  }
}
