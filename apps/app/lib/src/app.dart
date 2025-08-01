import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/router/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: AppInfo.appName,
      theme: AppTheme.light,
      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
