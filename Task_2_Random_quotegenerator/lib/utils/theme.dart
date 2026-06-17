import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A42D6);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color accent = Color(0xFFFF6584); // pink (favorite heart)

  static const Color bgLight = Color(0xFFF8F7FF);
  static const Color bgDark = Color(0xFF121212);

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E2E);
  static const Color surfaceDark = Color(0xFF252535);

  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B6B8A);

  static const Color textPrimaryDark = Color(0xFFF0EEFF);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.cardLight,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      cardTheme: const CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textSecondaryLight),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.playfairDisplay(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        bodyLarge: GoogleFonts.playfairDisplay(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textPrimaryLight,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.poppins(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.cardDark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      cardTheme: const CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textSecondaryDark),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.playfairDisplay(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        bodyLarge: GoogleFonts.playfairDisplay(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textPrimaryDark,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.poppins(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
