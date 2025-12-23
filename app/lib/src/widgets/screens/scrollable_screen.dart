import 'package:flutter/material.dart';

class ScrollableScreen extends StatelessWidget {
  /// For screens that need to be scrollable.
  const ScrollableScreen({super.key, required this.children, this.padding});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final defaultPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 8);
    final systemPadding = MediaQuery.of(context).padding;

    return SingleChildScrollView(
      padding: defaultPadding.add(.only(bottom: systemPadding.bottom)),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Column(crossAxisAlignment: .start, children: children),
    );
  }
}
