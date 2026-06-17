import 'package:flutter/material.dart';

/// Growve 앱(plant_it_fe)과 동일한 컬러 팔레트.
class GrowveColors {
  static const cream = Color(0xFFF7F1E7);
  static const paper = Color(0xFFFFFCF6);
  static const line = Color(0xFFE4DED3);
  static const text = Color(0xFF2C2825);
  static const muted = Color(0xFF81796C);
  static const green = Color(0xFF426D3E);
  static const greenDark = Color(0xFF2D4B31);
  static const greenSoft = Color(0xFFE4EEDA);
  static const mint = Color(0xFFDCEAD8);
}

class GrowveTheme {
  /// 본문 콘텐츠의 최대 가로 폭(웹에서 가독성을 위해 제한).
  static const double maxContentWidth = 760;

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: GrowveColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: GrowveColors.green,
        primary: GrowveColors.green,
        surface: GrowveColors.paper,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: GrowveColors.text,
        displayColor: GrowveColors.text,
      ),
    );
  }
}
