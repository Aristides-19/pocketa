import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pocketa/src/router/routes.dart';

class PopNavigatorPlugin extends StatelessWidget {
  const PopNavigatorPlugin({super.key});

  @override
  Widget build(BuildContext context) {
    return ToolPanelSection(
      title: 'Navigator Pop',
      children: [
        ListTile(
          title: const Text('Pop Navigator'),
          onTap: () => rootNavigatorKey.currentState?.canPop() == true
              ? rootNavigatorKey.currentState?.pop()
              : shellNavigatorKey.currentState?.canPop() == true
              ? shellNavigatorKey.currentState?.pop()
              : null,
        ),
      ],
    );
  }
}
