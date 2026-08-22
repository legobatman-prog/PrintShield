import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF0B0711);
  static const ink = Color(0xFFF7F2FF);
  static const mint = Color(0xFFC77DFF);
  static const mintDeep = Color(0xFF9D4EDD);
  static const cloud = Color(0xFF110B18);
  static const slate = Color(0xFFC9BDCE);
  static const line = Color(0xFF2B1D35);
  static const warning = Color(0xFFFFB84D);
  static const surface = Color(0xFF1A1023);
  static const purpleGlow = Color(0xFF6B21A8);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cloud,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.mintDeep,
      primary: AppColors.mint,
      onPrimary: AppColors.navy,
      surface: AppColors.surface,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
      titleMedium: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
      bodyMedium: TextStyle(color: AppColors.slate, height: 1.45),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cloud,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.ink,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    ),
  );
}
