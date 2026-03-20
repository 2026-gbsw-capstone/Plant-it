import 'package:flutter/material.dart';

import 'constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.forest,
      onPrimary: AppColors.cream,
      secondary: AppColors.terracotta,
      onSecondary: AppColors.cream,
      error: AppColors.danger,
      onError: AppColors.cream,
      surface: AppColors.cream,
      onSurface: AppColors.ink,
      tertiary: AppColors.lavender,
      onTertiary: AppColors.cream,
      surfaceContainerHighest: AppColors.paper,
      onSurfaceVariant: AppColors.stone,
      outline: AppColors.taupe,
      outlineVariant: AppColors.paper,
      shadow: Color(0x1A000000),
      scrim: Color(0x52000000),
      inverseSurface: AppColors.ink,
      onInverseSurface: AppColors.cream,
      inversePrimary: AppColors.sage,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'IBMPlexSansKR',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: base.textTheme.displayMedium?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          color: AppColors.ink,
          height: 1.45,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.ink,
          height: 1.45,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.7),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.paper),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.paper,
        selectedColor: AppColors.sage,
        side: BorderSide.none,
        labelStyle: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.72),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.paper),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.paper),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.forest, width: 1.5),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.forest,
        foregroundColor: AppColors.cream,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.forest,
        unselectedItemColor: AppColors.stone,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.94),
        indicatorColor: AppColors.paper,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.forest
                : AppColors.stone,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.forest
                : AppColors.stone,
            fontWeight: FontWeight.w600,
          );
        }),
      ),
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.sage,
      onPrimary: AppColors.ink,
      secondary: AppColors.terracotta,
      onSecondary: AppColors.cream,
      error: AppColors.brick,
      onError: AppColors.cream,
      surface: AppColors.charcoal,
      onSurface: AppColors.cream,
      tertiary: AppColors.lavender,
      onTertiary: AppColors.cream,
      surfaceContainerHighest: Color(0xFF433D38),
      onSurfaceVariant: AppColors.taupe,
      outline: Color(0xFF5A524A),
      outlineVariant: Color(0xFF433D38),
      shadow: Color(0x66000000),
      scrim: Color(0x99000000),
      inverseSurface: AppColors.cream,
      onInverseSurface: AppColors.ink,
      inversePrimary: AppColors.forest,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.charcoal,
      fontFamily: 'IBMPlexSansKR',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.charcoal,
        foregroundColor: AppColors.cream,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.cream,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: base.textTheme.displayMedium?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.cream,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.cream,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontFamily: 'Hahmlet',
          color: AppColors.cream,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: AppColors.cream,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          color: AppColors.cream,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          color: AppColors.cream,
          height: 1.45,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.cream,
          height: 1.45,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF3B352F),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF4B443D)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF433D38),
        selectedColor: AppColors.forest,
        side: BorderSide.none,
        labelStyle: const TextStyle(
          color: AppColors.cream,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF3B352F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF4B443D)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF4B443D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.sage, width: 1.5),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.sage,
        foregroundColor: AppColors.ink,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2B2723),
        selectedItemColor: AppColors.sage,
        unselectedItemColor: AppColors.taupe,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF2B2723),
      ),
    );
  }
}
