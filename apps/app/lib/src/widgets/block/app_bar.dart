import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:pocketa/src/localization/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PAppBar({super.key});

  static final List<Map<String, String>> titles = [
    {'title': AppInfo.appName, 'route': RoutePaths.home},
    {
      'title': LocaleKeys.nav_transactions.tr(),
      'route': RoutePaths.transactions.path,
    },
    {'title': LocaleKeys.nav_insights.tr(), 'route': RoutePaths.insights},
    {'title': LocaleKeys.nav_profile.tr(), 'route': RoutePaths.user},
  ];

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final title = titles.firstWhere(
      (item) => item['route'] == currentLocation,
      orElse: () => {'title': AppInfo.appName},
    )['title']!;

    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w800)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
