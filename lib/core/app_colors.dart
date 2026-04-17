import 'package:flutter/material.dart';

class AppColors {
  // --- Warna Utama (Brand Identity) ---
  static const Color primary = Color(0xFF1E88E5); // Biru Sporty
  static const Color primaryLight = Color(0xFFE3F2FD); // Untuk background card/highlight
  static const Color secondary = Color(0xFFFFA000); // Oranye Aksen

  // --- Warna Background & Surface ---
  static const Color background = Color(0xFFF8F9FA); // Sedikit lebih bersih dari F5F5F5
  static const Color surface = Colors.white; // Untuk card & modal

  // --- Warna Teks ---
  static const Color textDark = Color(0xFF1A1A1A); // Lebih pekat, lebih elegan
  static const Color textLight = Color(0xFF757575);
  static const Color textMuted = Color(0xFF9E9E9E); // Untuk sub-teks yang tidak penting

  // --- Warna Status (Penting untuk Booking App) ---
  static const Color success = Color(0xFF2E7D32); // Hijau (Booking Berhasil)
  static const Color error = Color(0xFFD32F2F); // Merah (Booking Batal/Penuh)
  static const Color warning = Color(0xFFF57C00); // Oranye gelap (Pending)

  // --- Warna Aksen Tambahan ---
  static const Color divider = Color(0xFFEEEEEE); // Untuk garis pembatas halus
}
