import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.route,
    required this.tooltip,
  });

  final IconData icon;
  final String route;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isSelected = currentLocation == route;
    final iconTheme = IconTheme.of(context);

    return IconButton(
      onPressed: () => context.go(route),
      tooltip: tooltip,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: FaIcon(
          icon,
          key: ValueKey(isSelected), // for animSwitcher
          color: isSelected ? iconTheme.color : iconTheme.color!.withAlpha(30),
        ),
      ),
    );
  }
}
