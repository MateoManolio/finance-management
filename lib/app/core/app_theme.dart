import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData appTheme() {
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
}
