import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeletonizer extends StatelessWidget {
  const Skeletonizer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.primary.withAlpha(10),
      highlightColor: theme.colorScheme.primary.withAlpha(15),
      child: child,
    );
  }
}
