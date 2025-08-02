import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:collection/collection.dart';
import 'package:pocketa/src/widgets/block/nav_item.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  static final List<Map<String, dynamic>> items = [
    {
      'icon': FontAwesomeIcons.house,
      'route': RoutePaths.home,
      'tooltip': 'Home',
    },
    {
      'icon': FontAwesomeIcons.moneyBillTransfer,
      'route': RoutePaths.transactions.path,
      'tooltip': 'Transactions',
    },
    {
      'icon': FontAwesomeIcons.chartLine,
      'route': RoutePaths.insights,
      'tooltip': 'Insights',
    },
    {
      'icon': FontAwesomeIcons.solidUser,
      'route': RoutePaths.user,
      'tooltip': 'Profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side icons
              ...items
                  .sublist(0, items.length ~/ 2)
                  .mapIndexed(
                    (index, item) => NavItem(
                      icon: item['icon'],
                      route: item['route'],
                      index: index,
                      tooltip: item['tooltip'],
                    ),
                  ),
              const SizedBox(width: 56),
              // Right side icons
              ...items
                  .sublist(items.length ~/ 2)
                  .mapIndexed(
                    (index, item) => NavItem(
                      icon: item['icon'],
                      route: item['route'],
                      index: index + items.length ~/ 2,
                      tooltip: item['tooltip'],
                    ),
                  ),
            ],
          ),
        ),

        Positioned(
          top: -20,
          child: FloatingActionButton(
            tooltip: 'Add Transaction',
            onPressed: () {
              context.go(RoutePaths.transactions.add);
            },
            child: const FaIcon(FontAwesomeIcons.plus),
          ),
        ),
      ],
    );
  }
}
