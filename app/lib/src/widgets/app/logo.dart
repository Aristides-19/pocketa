import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocketa/src/constants/constants.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.width = 55, this.alignment = Alignment.center});

  final double width;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icon/logo.svg',
      width: width,
      alignment: alignment,
      semanticsLabel: '${AppInfo.appName} Logo',
    );
  }
}
