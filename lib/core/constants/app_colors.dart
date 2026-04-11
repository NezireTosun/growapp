import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary (GrowApp Blue)
  static const Color primary = Color(0xFF2F4FA3);
  static const Color primaryDark = Color(0xFF243D85);
  static const Color primaryLight = Color(0xFF4163BE);

  // Primary Gradient
  static const Color gradientStart = Color(0xFF2F4FA3);
  static const Color gradientEnd = Color(0xFF243D85);

  // Secondary
  static const Color secondary = Color(0xFF5B8EFF);

  // Blue Surface & Border
  static const Color primarySurface = Color(0x1F2F4FA3);
  static const Color primaryBorder = Color(0x402F4FA3);

  // Success (yeşil olarak kalıyor, success farklı anlam taşır)
  static const Color success = Color(0xFF2ECC40);
  static const Color successLight = Color(0x1F2ECC40);

  // Warning
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFF4E5);

  // Danger
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFDECEC);

  // Info
  static const Color info = Color(0xFF5B8EFF);
  static const Color infoLight = Color(0xFFEBF1FF);

  // Neutral / Background (Light Theme)
  static const Color background = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEDEFF2);
  static const Color surfaceLight = Color(0xFFEEF2F8);

  // Text (Light Theme)
  static const Color textPrimary = Color(0xFF0E1629);
  static const Color textSecondary = Color(0xFF253354);
  static const Color textTertiary = Color(0xFF4E5F7A);
  static const Color textMuted = Color(0xFF8A97AF);

  // Icon / Navigation
  static const Color iconActive = Color(0xFF2F4FA3);
  static const Color iconInactive = Color(0xFF8A97AF);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0E1629);
  static const Color darkSurface = Color(0xFF141E35);
  static const Color darkCard = Color(0xFF1C2844);
  static const Color darkCardHover = Color(0xFF253354);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF8A97AF);
  static const Color darkTextMuted = Color(0xFF4E5F7A);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
