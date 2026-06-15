import 'dart:ui';
import 'package:flutter/material.dart';

/// ── Light palette ────────────────────────────────────────
/// Trustworthy, clean: white canvas, ink-black primary, gold used
/// sparingly as a brand highlight, green for "live/verified" trust.
/// Field names kept stable across the app.
class AppColors {
  static const bg = Color(0xFFFFFFFF); // white canvas
  static const bgSoft = Color(0xFFF7F7F5); // section wash
  static const card = Color(0xFFFFFFFF);
  static const cardHi = Color(0xFFF2F2EF);
  static const ink = Color(0xFF15161A); // primary (buttons, headings)
  static const accent = Color(0xFFF2B600); // gold highlight
  static const accent2 = Color(0xFFE0903A);
  static const accentDark = Color(0xFFCB9A00);
  static const trust = Color(0xFF12B981); // verified / online / live
  static const text = Color(0xFF15161A); // primary text = ink
  static const subtext = Color(0xFF6C6C74); // secondary
  static const faint = Color(0xFFA0A0A8); // tertiary
  static const danger = Color(0xFFE5484D);
  static const amber = Color(0xFFF2B600);
  static const line = Color(0xFFEAEAE6); // light hairline

  static const brandGradient = LinearGradient(
    colors: [Color(0xFFF2B600), Color(0xFFE0903A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get dark => light; // alias kept so main.dart works
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bg,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme.light(
          primary: AppColors.ink,
          secondary: AppColors.accent,
          surface: AppColors.card,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.ink),
          titleTextStyle: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          isDense: true,
          hintStyle: const TextStyle(color: AppColors.faint, fontSize: 15),
          labelStyle: const TextStyle(color: AppColors.subtext),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIconColor: AppColors.faint,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.line)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.ink, width: 1.6)),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.line)),
        ),
      );
}

class AppText {
  static const display = TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
      letterSpacing: -1.0,
      height: 1.02);
  static const h1 = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
      letterSpacing: -0.7,
      height: 1.05);
  static const h2 = TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
      letterSpacing: -0.5);
  static const title = TextStyle(
      fontSize: 15.5,
      fontWeight: FontWeight.w600,
      color: AppColors.text,
      letterSpacing: -0.2);
  static const body =
      TextStyle(fontSize: 14.5, color: AppColors.text, height: 1.4);
  static const muted =
      TextStyle(fontSize: 13, color: AppColors.subtext, height: 1.4);
  static const small = TextStyle(fontSize: 11.5, color: AppColors.faint);
  static const eyebrow = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.subtext,
      letterSpacing: 1.8);
  static const meter = TextStyle(
      fontFamily: 'monospace',
      fontWeight: FontWeight.w700,
      color: AppColors.text,
      letterSpacing: -0.5,
      fontFeatures: [FontFeature.tabularFigures()]);
}

class AppDeco {
  /// Soft, believable elevation for a light UI.
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
            color: const Color(0xFF15161A).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8)),
        BoxShadow(
            color: const Color(0xFF15161A).withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1)),
      ];

  static List<BoxShadow> glow(Color c, {double blur = 20, double spread = 0}) =>
      [BoxShadow(color: c.withOpacity(0.18), blurRadius: blur, spreadRadius: spread)];

  static BoxDecoration card({Color? border}) => BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border ?? AppColors.line),
        boxShadow: cardShadow,
      );

  static BoxDecoration get pageBg => const BoxDecoration(color: AppColors.bg);
}
