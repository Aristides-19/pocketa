import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({
    super.key,
    required this.child,
    this.padding = const .symmetric(horizontal: 18, vertical: 12),
    this.selected = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: .zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.borderRadius,
        side: BorderSide(
          color: selected
              ? colorScheme.primary.withAlpha(120)
              : colorScheme.outline,
        ),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
