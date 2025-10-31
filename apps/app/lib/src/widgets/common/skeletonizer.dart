import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';
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

class ContainerSkeleton extends StatelessWidget {
  const ContainerSkeleton({super.key, this.width = 60, this.height = 20});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
      ),
    );
  }
}
