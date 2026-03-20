import 'package:flutter/material.dart';

enum AppThemePreference {
  system,
  light,
  dark;

  ThemeMode get themeMode {
    switch (this) {
      case AppThemePreference.system:
        return ThemeMode.system;
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
    }
  }
}

class Etc {
  final Uri backendUrl = Uri.parse('http://localhost:8080');
  final AppThemePreference themePreference = AppThemePreference.system;
}

final Etc etc = Etc();
