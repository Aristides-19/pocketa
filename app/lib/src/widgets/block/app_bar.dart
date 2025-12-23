import 'package:flutter/material.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
