import 'package:flutter/material.dart';

/// OriginOS-inspired design tokens for Office Kit AI+.
class AppColors {
  static const primary = Color(0xFF246BFF);
  static const primaryDark = Color(0xFF1A54D6);
  static const primarySoft = Color(0xFFE8EFFF);
  static const green = Color(0xFF21C87A);
  static const greenSoft = Color(0xFFE6F9EF);
  static const background = Color(0xFFF5F7FB);
  static const card = Colors.white;
  static const danger = Color(0xFFFF5E57);
  static const dangerSoft = Color(0xFFFFECEB);
  static const amber = Color(0xFFFFA726);
  static const amberSoft = Color(0xFFFFF4E3);
  static const purple = Color(0xFF7C5CFF);
  static const purpleSoft = Color(0xFFF0EBFF);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const border = Color(0xFFE8EDF5);
  static const sidebarBg = Colors.white;
  static const hoverBg = Color(0xFFF1F5FF);
}

class AppRadius {
  static const double card = 24;
  static const double button = 18;
  static const double search = 28;
  static const double small = 14;
  static const double chip = 100;
}

class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF0F1B3D).withOpacity(0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
      ];
  static List<BoxShadow> get pop => [
        BoxShadow(
          color: const Color(0xFF0F1B3D).withOpacity(0.10),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ];
  static List<BoxShadow> get button => [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.30),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}

/// Central ThemeData — light OriginOS aesthetic. Dark mode is simulated
/// via [ThemeMode] + brightness override in settings (kept light-first).
class AppTheme {
  static ThemeData light() {
    const fontFamily = 'Inter';
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.card,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
        displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.4),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5),
        labelLarge: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white),
        labelMedium: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        labelSmall: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textTertiary),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 13.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.search), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.search), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.search), borderSide: const BorderSide(color: AppColors.primary, width: 1.4)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: AppColors.primarySoft,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(const Color(0xFFD4DCED)),
        thickness: WidgetStateProperty.all(8),
        radius: const Radius.circular(8),
      ),
    );
  }

  static ThemeData dark() {
    final light = AppTheme.light();
    return light.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      cardTheme: CardThemeData(
        color: const Color(0xFF131C30),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: Color(0xFF223047)),
        ),
      ),
    );
  }
}
