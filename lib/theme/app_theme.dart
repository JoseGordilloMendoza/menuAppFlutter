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

/// Tipografías: Poppins para el texto y Lilita One para títulos y precios.
class AppText {
  static const body = 'Poppins';
  static const displayFamily = 'LilitaOne';

  /// Estilo de titular. Lilita One solo tiene un peso, por eso no se
  /// le asigna negrita.
  static TextStyle display(
    double size, {
    Color color = AppColors.navy,
    double height = 1.1,
    double letterSpacing = 0,
    List<Shadow>? shadows,
  }) => TextStyle(
    fontFamily: displayFamily,
    fontSize: size,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    fontWeight: FontWeight.w400,
    shadows: shadows,
  );
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.orange,
    primary: AppColors.orange,
    surface: AppColors.cream,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: AppText.body,
  );
  final text = base.textTheme;
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontFamily: AppText.displayFamily,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: text.headlineSmall?.copyWith(
        fontFamily: AppText.displayFamily,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: text.titleLarge?.copyWith(
        fontFamily: AppText.displayFamily,
        fontWeight: FontWeight.w400,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.navy,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: AppText.displayFamily,
        fontSize: 22,
        color: AppColors.navy,
      ),
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE6DCCD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE6DCCD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.orange, width: 2),
      ),
      prefixIconColor: AppColors.orange,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        textStyle: const TextStyle(
          fontFamily: AppText.body,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
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
