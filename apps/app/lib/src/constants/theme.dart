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
    colorScheme: ColorScheme(
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
    ),
  );
}
