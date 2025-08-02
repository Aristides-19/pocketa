import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/widgets/block/block.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppInfo.appName,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),

      body: child,

      bottomNavigationBar: const BottomBar(),
    );
  }
}
