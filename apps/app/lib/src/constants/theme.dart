import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocketa/src/constants/constants.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.darkSky,
    scaffoldBackgroundColor: AppColors.lightGray,
    textTheme: TextTheme(
      displayLarge: _ibm(Colors.black87, FontWeight.w900), // Muy destacado
      displayMedium: _ibm(Colors.black87, FontWeight.w700),
      displaySmall: _ibm(Colors.black87, FontWeight.w600),

      headlineLarge: _ibm(Colors.black87, FontWeight.w600),
      headlineMedium: _ibm(Colors.black87, FontWeight.w500),
      headlineSmall: _ibm(Colors.black87, FontWeight.w500),

      titleLarge: _ibm(Colors.black87, FontWeight.w500),
      titleMedium: _ibm(Colors.black87, FontWeight.w500),
      titleSmall: _ibm(AppColors.midGray, FontWeight.w400),

      bodyLarge: _ibm(Colors.black87, FontWeight.w400),
      bodyMedium: _ibm(Colors.black87, FontWeight.w400),
      bodySmall: _ibm(AppColors.midGray, FontWeight.w300),

      labelLarge: _ibm(Colors.black87, FontWeight.w500),
      labelMedium: _ibm(AppColors.midGray, FontWeight.w400),
      labelSmall: _ibm(AppColors.midGray, FontWeight.w300),
    ),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: AppColors.darkSky, size: 18),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.darkSky,
      onPrimary: AppColors.white,
      secondary: AppColors.vividSky,
      onSecondary: AppColors.darkSky,
      surface: AppColors.lightGray,
      onSurface: Colors.black87,
      surfaceContainer: AppColors.lightWhite,
      error: AppColors.red,
      onError: AppColors.white,
      tertiary: AppColors.lightSky,
      onTertiary: AppColors.darkSky,
      outline: AppColors.opaqueDarkSky,
    ),
    tooltipTheme: TooltipThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 8),
      verticalOffset: 24,
      preferBelow: false,
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white, // Color del texto
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(15),
  );

  static TextStyle _ibm(Color color, FontWeight fontWeight) =>
      GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(color: color, fontWeight: fontWeight),
      );
}
