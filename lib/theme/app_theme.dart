import 'package:flutter/material.dart';

class AppColors {
  static const orange = Color(0xFFDA4B0B);
  static const cream = Color(0xFFFFFBF4);
  static const navy = Color(0xFF14233A);
  static const green = Color(0xFF087C63);
  static const amber = Color(0xFF9A5D00);
  static const red = Color(0xFFB33434);
  static const sun = Color(0xFFFFC145);
  static const ember = Color(0xFFB8360A);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.orange,
    primary: AppColors.orange,
    surface: AppColors.cream,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.cream,
    appBarTheme: const AppBarThemeData(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.navy,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFEDE5DA)),
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFFFE9D8),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    ),
  );
}
