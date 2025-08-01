import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: AppInfo.appName,
      theme: AppTheme.light,
      themeMode: ThemeMode.system,

      home: Scaffold(
        appBar: AppBar(
          title: Text(
            AppInfo.appName,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: Center(),
      ),
    );
  }
}
