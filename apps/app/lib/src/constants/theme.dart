import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocketa/src/constants/constants.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.darkSky,
    scaffoldBackgroundColor: AppColors.lightGray,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: AppColors.darkSky, size: 18),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.darkSky,
      onPrimary: AppColors.white,
      secondary: AppColors.vividSky,
      onSecondary: AppColors.darkSky,
      surface: AppColors.white,
      onSurface: Colors.black87,
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
}
