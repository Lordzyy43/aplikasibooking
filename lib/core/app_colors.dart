import 'package:flutter/material.dart';

class AppColors {
  // Stitch design tokens: ArenaFlow / "Stadium Atelier"
  static const Color primary = Color(0xFF003D9B);
  static const Color primaryContainer = Color(0xFF0052CC);
  static const Color primaryLight = Color(0xFFDAE2FF);
  static const Color secondary = Color(0xFF4C5D8D);
  static const Color secondaryContainer = Color(0xFFB6C8FE);
  static const Color tertiary = Color(0xFF9A3F00);
  static const Color accent = Color(0xFFFF6D00);

  // Background and surfaces
  static const Color background = Color(0xFFF9F9FD);
  static const Color surface = Color(0xFFF9F9FD);
  static const Color surfaceLowest = Color(0xFFFFFFFF);
  static const Color surfaceLow = Color(0xFFF3F3F7);
  static const Color surfaceHigh = Color(0xFFE7E8EB);
  static const Color surfaceVariant = Color(0xFFE2E2E6);
  static const Color divider = Color(0xFFC3C6D6);

  // Typography
  static const Color textPrimary = Color(0xFF191C1E);
  static const Color textSecondary = Color(0xFF434654);
  static const Color textMuted = Color(0xFF737685);

  // Aliases for compatibility with the existing codebase
  static const Color textDark = textPrimary;
  static const Color textLight = textSecondary;
  static const Color primaryBlue = primary;
  static const Color darkText = textPrimary;
  static const Color greyText = textMuted;

  // Status
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color available = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFDDF3E4);
  static const Color warningContainer = Color(0xFFFFE7CC);
  static const Color errorContainer = Color(0xFFFFDAD6);
}
