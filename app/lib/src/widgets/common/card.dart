import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: .zero,
      elevation: 0,
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.borderRadius,
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: padding ?? const .symmetric(horizontal: 18, vertical: 12),
        child: child,
      ),
    );
  }
}
