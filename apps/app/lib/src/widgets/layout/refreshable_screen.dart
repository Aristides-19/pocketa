import 'package:flutter/material.dart';

/// For scrollable screens that support pull-to-refresh. Most screens may use this to refresh all providers on screen.
class RefreshableScreen extends StatelessWidget {
  const RefreshableScreen({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: onRefresh, child: child);
  }
}
