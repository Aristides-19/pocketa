import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/routes.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PAppBar({super.key});

  static final titles = {
    const HomeRoute().location: LocaleKeys.nav_home.tr(),
    const TransactionsRoute().location: LocaleKeys.nav_transactions.tr(),
    const InsightsRoute().location: LocaleKeys.nav_insights.tr(),
    const ProfileRoute().location: LocaleKeys.nav_profile.tr(),
  };

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final title = titles[currentLocation] ?? AppInfo.appName;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
