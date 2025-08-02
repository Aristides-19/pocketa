import 'package:flutter/material.dart';
import 'package:pocketa/src/widgets/block/block.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBar(),

      body: child,

      bottomNavigationBar: const BottomBar(),
    );
  }
}
