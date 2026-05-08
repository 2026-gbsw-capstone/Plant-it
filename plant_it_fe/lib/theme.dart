import 'package:flutter/material.dart';

class PlantItColors {
  static const cream = Color(0xFFF7F1E7);
  static const paper = Color(0xFFFFFCF6);
  static const line = Color(0xFFE4DED3);
  static const text = Color(0xFF27231E);
  static const muted = Color(0xFF81796C);
  static const green = Color(0xFF426D3E);
  static const greenDark = Color(0xFF2D4B31);
  static const greenSoft = Color(0xFFE4EEDA);
  static const mint = Color(0xFFDCEAD8);
  static const ink = Color(0xFF26231F);
  static const alert = Color(0xFFF6E0DC);
  static const alertText = Color(0xFFA8483E);
  static const danger = Color(0xFFC7584A);
}

class PlantItTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'GmarketSansTTF',
      scaffoldBackgroundColor: PlantItColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PlantItColors.green,
        primary: PlantItColors.green,
        surface: PlantItColors.paper,
        error: PlantItColors.danger,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: PlantItColors.text,
        displayColor: PlantItColors.text,
        fontFamily: 'GmarketSansTTF',
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: PlantItColors.cream,
        foregroundColor: PlantItColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: PlantItColors.text,
          fontFamily: 'GmarketSansTTF',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PlantItColors.paper,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: PlantItColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: PlantItColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: PlantItColors.green, width: 1.5),
        ),
      ),
    );
  }
}
