import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    // Emerald Green palette with warm coral accents
    const primaryColor = Color(0xFF00C9A7); // Vibrant emerald green
    // const secondaryColor = Color(0xFF1DD3B0); // Mint green
    const tertiaryColor = Color(0xFF4FE3C1); // Turquoise
    const accentOrange = Color(0xFFFF8C42); // Warm coral orange
    const backgroundColor = Color(0xFF0D1821); // Deep greenish-black
    const surfaceColor = Color(0xFF1A2332); // Slightly lighter surface
    const errorColor = Color.fromARGB(255, 255, 79, 66); // Warm coral orange

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: tertiaryColor,
        tertiary: accentOrange,
        surface: surfaceColor,
        error: errorColor, // Using warm coral for error/important actions
        onPrimary: const Color(0xFF0D1821), // Dark text on primary
        onSecondary: const Color(0xFF0D1821), // Dark text on secondary
        onSurface: const Color(0xFFE8F5F1), // Light greenish-white text
        tertiaryContainer:
            const Color.fromARGB(255, 255, 160, 100), // Dark text on tertiary
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: const Color(0xFFE8F5F1), // Light greenish-white
        displayColor: const Color(0xFFE8F5F1),
      ),
      scaffoldBackgroundColor: backgroundColor,
      // Card theme with the new surface color
      cardTheme: const CardThemeData(
        color: surfaceColor,
        elevation: 0,
      ),
      // Icon theme with primary color
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
    );
  }

  static ThemeData get lightTheme {
    // Paleta "Frosted Mint & Ocean" - Estilo Glassmorphism diurno
    const backgroundColor =
        Color(0xFFF0F4F8); // Blanco hielo / gris azulado muy suave
    const surfaceColor = Color(0xFFFFFFFF); // Blanco puro (base)

    // Colores de las burbujas de fondo y botones
    const primaryAccent =
        Color(0xFF1AC88E); // Verde marino/esmeralda vibrante (Botón +)
    const tertiaryAccent =
        Color(0xFF29B6F6); // Celeste/Azul claro (Burbuja secundaria)

    // Indicadores financieros
    const expenseColor = Color(0xFFFF5252); // Rojo vibrante/coral
    const incomeColor =
        Color(0xFF00B0FF); // Azul luminoso para ingresos (según la imagen)

    // Textos y elementos sobre-superficie (usado para opacidades del glassmorphism)
    const textPrimary = Color(0xFF1E293B); // Azul marino oscuro / casi negro
    const textSecondary = Color(0xFF64748B); // Gris medio
    const onSurfaceDark =
        Color(0xFF0F172A); // Color oscuro para crear los cristales ahumados

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryAccent,
        secondary: tertiaryAccent,
        surface: surfaceColor,
        error: expenseColor,
        tertiary: incomeColor,
        // Usamos onSurface como un color oscuro para que los cristales con alpha (como la NavBar o Tarjetas)
        // se oscurezcan sutilmente como en la imagen.
        onSurface: onSurfaceDark,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor.withValues(
            alpha: 0.4), // Base de tarjeta semi-transparente
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.largeRadius),
          side: BorderSide(
              color: onSurfaceDark.withValues(alpha: 0.1),
              width: 1), // Borde sutil oscuro
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.largeRadius),
          side:
              BorderSide(color: onSurfaceDark.withValues(alpha: 0.1), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: onSurfaceDark.withValues(alpha: 0.05),
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: BorderSide(color: onSurfaceDark.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: BorderSide(color: onSurfaceDark.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
      ),
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),
    );
  }
}
