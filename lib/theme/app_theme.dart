import 'package:flutter/material.dart';

// =========================
// APP THEME
// Satu sumber warna & style, dipakai di semua screen
// biar Home & Detail Produk konsisten.
// =========================

class AppColors {
  static const primary = Color(0xFF1B8A5A); // hijau tua, senada sama harga
  static const primaryLight = Color(0xFFE6F4EC);
  static const accent = Color(0xFFFF9800); // orange untuk rating/badge
  static const background = Colors.white; // putih polos, bukan abu-abu
  static const card = Colors.white;
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF7A7A7A);
  static const divider = Color(0xFFEDEDED);
}

class AppTheme {
  // Pasang ini di MaterialApp supaya app SELALU pakai tema terang,
  // apapun setting dark mode di laptop/HP user.
  // Contoh: MaterialApp(theme: AppTheme.theme, themeMode: AppTheme.themeMode)
  static const ThemeMode themeMode = ThemeMode.light;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // Shadow konsisten buat card di seluruh app
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}