import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class ThemeSwitcher extends HookWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) => Switcher(
    enabled: Theme.of(context).brightness == Brightness.dark,
    onChanged: (value) => log('Switch toggled: $value'),
  );
}
