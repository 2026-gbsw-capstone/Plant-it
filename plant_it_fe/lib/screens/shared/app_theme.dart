import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF5EFE6);
  static const surface = Color(0xFFEFE9DF);
  static const text = Color(0xFF2E2924);
  static const subText = Color(0xFF6D655D);
  static const green = Color(0xFF4D7448);
  static const lightGreen = Color(0xFF7EA06F);
  static const blue = Color(0xFF5C83A5);
  static const red = Color(0xFFA23C2D);
  static const navDark = Color(0xFF2B2724);
  static const line = Color(0xFFDCD4C8);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
        brightness: Brightness.light,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'GmarketSansTTF',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'twaySky',
          fontSize: 42,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          height: 1.25,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'twaySky',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'twaySky',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.text,
          height: 1.65,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.text,
          height: 1.55,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'twaySky',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: AppColors.green, width: 1.4),
        ),
        hintStyle: const TextStyle(color: AppColors.subText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
