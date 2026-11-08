import 'package:flutter/material.dart';

class AppColors {
  // Warna Utama (Brand Colors)
  static const Color primaryTeal = Color(0xFF0D9488);     // Teal (#0D9488) - Tombol & Akses UI
  static const Color primaryDarkTeal = Color(0xFF0B766C); // Dark Teal (#0B766C) - Header Gradient[cite: 1]
  static const Color primaryNavy = Color(0xFF1E3A8A);     // Navy Blue (#1E3A8A) - Header Utama & Accent[cite: 1]

  // Warna Status Laporan & Alert
  static const Color statusRed = Color(0xFFC62828);     // Merah - Darurat / Ditolak / Tingkat 5[cite: 1]
  static const Color statusAmber = Color(0xFFB45309);   // Amber - Dalam Proses / Peringatan[cite: 1]
  static const Color statusGreen = Color(0xFF0D9488);   // Hijau Teal - Selesai / Verifikasi[cite: 1]

  // Warna Netral & Latar Belakang (Light Theme)
  static const Color background = Color(0xFFEEF2F1);    // Light Gray Background (#eef2f1)[cite: 1]
  static const Color surface = Color(0xFFFFFFFF);       // Card Background White[cite: 1]
  static const Color textMain = Color(0xFF14211F);      // Text Utama (#14211f)[cite: 1]
  static const Color textMuted = Color(0xFF5D6C69);     // Text Subtitle / Gray (#5d6c69)[cite: 1]
  static const Color borderLine = Color(0xFFDBE4E2);    // Border Card & Divider (#dbe4e2)[cite: 1]
}