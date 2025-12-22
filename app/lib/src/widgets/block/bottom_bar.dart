import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:pocketa/src/widgets/block/nav_item.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  static final items = [
    (
      icon: FontAwesomeIcons.house,
      route: RoutePaths.home,
      tooltip: LocaleKeys.nav_home.tr(),
    ),
    (
      icon: FontAwesomeIcons.moneyBillTransfer,
      route: RoutePaths.transactions.path,
      tooltip: LocaleKeys.nav_transactions.tr(),
    ),
    (
      icon: FontAwesomeIcons.chartLine,
      route: RoutePaths.insights,
      tooltip: LocaleKeys.nav_insights.tr(),
    ),
    (
      icon: FontAwesomeIcons.solidUser,
      route: RoutePaths.user,
      tooltip: LocaleKeys.nav_profile.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final systemPadding = MediaQuery.of(context).viewPadding.bottom;
    final theme = Theme.of(context);

    return Stack(
      alignment: .center,
      clipBehavior: .none,
      children: [
        Container(
          height: 60 + systemPadding,
          padding: .only(bottom: systemPadding),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: theme.colorScheme.outline, width: 1),
            ),
          ),

          child: Row(
            mainAxisAlignment: .spaceAround,
            crossAxisAlignment: .center,
            children: [
              // Left side icons
              ...items
                  .sublist(0, items.length ~/ 2)
                  .map(
                    (item) => NavItem(
                      icon: item.icon,
                      route: item.route,
                      tooltip: item.tooltip,
                    ),
                  ),
              const SizedBox(width: 56),
              // Right side icons
              ...items
                  .sublist(items.length ~/ 2)
                  .map(
                    (item) => NavItem(
                      icon: item.icon,
                      route: item.route,
                      tooltip: item.tooltip,
                    ),
                  ),
            ],
          ),
        ),

        Positioned(
          top: -20,
          child: FloatingActionButton(
            tooltip: LocaleKeys.nav_add_transaction.tr(),
            onPressed: () => context.push(RoutePaths.transactions.add),
            child: const FaIcon(FontAwesomeIcons.plus),
          ),
        ),
      ],
    );
  }
}
