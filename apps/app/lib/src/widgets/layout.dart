import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';

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

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: ''),
        ],
      ),
    );
  }
}
