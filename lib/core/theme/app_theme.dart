import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// ThemeData oscuro y claro — estilo "Rodando Ando" automotriz.
class AppTheme {
  AppTheme._();

  /// Puntos de quiebre responsivos:
  /// < 600px Móvil | 600..1024px Tablet | >= 1024px PC/Escritorio
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  static ThemeData get dark => _buildTheme(isDark: true);
  static ThemeData get light => _buildTheme(isDark: false);

  static ThemeData _buildTheme({required bool isDark}) {
    final bg = isDark ? AppColors.asfalto : AppColors.nieblaFondo;
    final surface = isDark ? AppColors.superficie : AppColors.blancoPuro;
    final textPrimary = isDark ? AppColors.niebla : AppColors.textoOscuro;
    final textSecondary = isDark ? AppColors.nieblaSutil : AppColors.textoOscuroSutil;
    final textMuted = isDark ? AppColors.nieblaApagada : AppColors.textoOscuroApagado;
    final border = isDark ? AppColors.borde : AppColors.bordeClaro;
    final divider = isDark ? AppColors.separador : AppColors.separadorClaro;

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Inter',
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.rojoMazda,
        onPrimary: AppColors.niebla,
        secondary: isDark ? AppColors.enOrden : AppColors.enOrdenClaro,
        onSecondary: textPrimary,
        tertiary: AppColors.atencion,
        error: AppColors.error,
        onError: AppColors.niebla,
        surface: surface,
        onSurface: textPrimary,
        outline: border,
        surfaceContainerHighest: isDark ? AppColors.superficieAlt : AppColors.grisClaro,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: const BorderSide(color: AppColors.rojoMazda, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: TextStyle(color: textSecondary, fontSize: 12),
        hintStyle: TextStyle(color: textMuted, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rojoMazda,
          foregroundColor: AppColors.niebla,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(0, 44),
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: textPrimary),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary),
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 0.4),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary, letterSpacing: 0.6),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textMuted, letterSpacing: 1.0),
      ),
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 1,
        space: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: AppColors.rojoMazda,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.rojoMazda);
          }
          return TextStyle(fontSize: 12, color: textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.niebla, size: 22);
          }
          return IconThemeData(color: textSecondary, size: 22);
        }),
      ),
    );
  }
}
