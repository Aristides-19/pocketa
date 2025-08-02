import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/router/routes/routes.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PAppBar({super.key});

  static final List<Map<String, String>> titles = [
    {'title': AppInfo.appName, 'route': RoutePaths.home},
    {'title': 'Transactions', 'route': RoutePaths.transactions.path},
    {'title': 'Insights', 'route': RoutePaths.insights},
    {'title': 'Profile', 'route': RoutePaths.user},
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
