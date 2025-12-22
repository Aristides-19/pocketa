import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/routes.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PAppBar({super.key});

  static final titles = [
    (title: AppInfo.appName, route: const HomeRoute().location),
    (
      title: LocaleKeys.nav_transactions.tr(),
      route: const TransactionsRoute().location,
    ),
    (
      title: LocaleKeys.nav_insights.tr(),
      route: const InsightsRoute().location,
    ),
    (title: LocaleKeys.nav_profile.tr(), route: const ProfileRoute().location),
  ];

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final title = titles
        .firstWhere(
          (item) => item.route == currentLocation,
          orElse: () => (title: AppInfo.appName, route: ''),
        )
        .title;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
