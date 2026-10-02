import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const background = Color(0xFFF7F9FA);
  static const primary = Color(0xFF3E8E89);
  static const textPrimary = Color(0xFF20272B);
  static const textSecondary = Color(0xFF6F7A80);
  static const success = Color(0xFF4F9B70);
  static const warning = Color(0xFFD79835);
  static const danger = Color(0xFFD66B62);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: primary.withValues(alpha: .16),
        labelTextStyle: WidgetStatePropertyAll(TextStyle(color: textPrimary)),
      ),
    );
  }
}
