import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'nav_item.g.dart';

class NavItem extends ConsumerWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.route,
    required this.index,
    required this.tooltip,
  });

  final IconData icon;
  final String route;
  final int index;
  final String tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final isSelected = currentIndex == index;
    final iconTheme = IconTheme.of(context);

    return IconButton(
      onPressed: () {
        context.go(route);
        ref.read(currentIndexProvider.notifier).setIndex(index);
      },
      tooltip: tooltip,
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

@Riverpod(keepAlive: true)
class CurrentIndex extends _$CurrentIndex {
  @override
  int build() => 0;
  void setIndex(int index) => state = index;
}
