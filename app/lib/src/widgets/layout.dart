import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/routes.dart';
import 'package:pocketa/src/widgets/block/block.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key, required this.child});

  final Widget child;
  static final titles = {
    const HomeRoute().location: LocaleKeys.nav_home.tr(),
    const TransactionsRoute().location: LocaleKeys.nav_transactions.tr(),
    const InsightsRoute().location: LocaleKeys.nav_insights.tr(),
    const ProfileRoute().location: LocaleKeys.nav_profile.tr(),
  };

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final title = titles[currentLocation] ?? AppInfo.appName;

    return Scaffold(
      extendBody: true,
      appBar: PAppBar(title: title),

      body: child,

      bottomNavigationBar: const BottomBar(),
    );
  }
}
