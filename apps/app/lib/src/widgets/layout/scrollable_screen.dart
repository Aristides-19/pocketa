import 'package:flutter/material.dart';

class ScrollableScreen extends StatelessWidget {
  const ScrollableScreen({super.key, required this.children, this.padding});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final defaultPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 8);
    final systemPadding = MediaQuery.of(context).padding;

    return SingleChildScrollView(
      padding: defaultPadding.add(
        EdgeInsets.only(bottom: systemPadding.bottom),
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
