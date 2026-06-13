import 'package:flutter/material.dart';

/// Central color palette — classic taxi (black + yellow).
class AppColors {
  static const bg = Color(0xFF0C0C0E);
  static const bgSoft = Color(0xFF141416);
  static const card = Color(0xFF1A1A1D);
  static const cardHi = Color(0xFF232327);
  static const accent = Color(0xFFFFC400); // taxi yellow (primary)
  static const accent2 = Color(0xFFFF8A00); // warm orange (secondary)
  static const accentDark = Color(0xFFE0A800);
  static const text = Color(0xFFF7F7F5);
  static const subtext = Color(0xFF9A9A9F);
  static const danger = Color(0xFFFF5C5C);
  static const amber = Color(0xFFFFC400);

  // Brand gradient used on hero areas / primary buttons.
  static const brandGradient = LinearGradient(
    colors: [accent, accent2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// App-wide theme (Material 3, dark).
class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          secondary: AppColors.accent2,
          surface: AppColors.card,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardHi,
          hintStyle: const TextStyle(color: AppColors.subtext),
          labelStyle: const TextStyle(color: AppColors.subtext),
          prefixIconColor: AppColors.subtext,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
        ),
      );
}

/// Shared text styles.
class AppText {
  static const h1 = TextStyle(
      fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.text);
  static const h2 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text);
  static const title = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text);
  static const body = TextStyle(fontSize: 14, color: AppColors.text);
  static const muted = TextStyle(fontSize: 13, color: AppColors.subtext);
}
