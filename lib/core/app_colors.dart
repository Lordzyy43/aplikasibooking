import 'package:flutter/material.dart';

class AppColors {
  // --- Brand Identity ---
  static const Color primary = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFFE3F2FD);
  static const Color secondary = Color(0xFFFFA000); // Pastikan ini ada (tadi error)
  static const Color accent = Color(0xFF2979FF);

  // --- Background & Surface ---
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color divider = Color(0xFFEEEEEE);

  // --- Typography (Gunakan alias agar kodingan lama tidak error) ---
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF424242);
  static const Color textMuted = Color(0xFF9E9E9E);

  // ALIAS untuk kompatibilitas kodingan yang sudah kamu buat
  static const Color textDark = textPrimary;
  static const Color textLight = textSecondary;

  // --- Status ---
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color available = Color(0xFF4CAF50);
}
