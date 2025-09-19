
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBrown = Color(0xFF5D4037);
  static const Color darkBrown = Color(0xFF3E2723);
  static const Color lightBrown = Color(0xFF8D6E63);
  static const Color accentBrown = Color(0xFF795548);
  
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: _createMaterialColor(primaryBrown),
      primaryColor: primaryBrown,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Coolvetica',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: darkBrown,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBrown,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBrown, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Coolvetica'),
        displayMedium: TextStyle(fontFamily: 'Coolvetica'),
        displaySmall: TextStyle(fontFamily: 'Coolvetica'),
        headlineLarge: TextStyle(fontFamily: 'Coolvetica'),
        headlineMedium: TextStyle(fontFamily: 'Coolvetica'),
        headlineSmall: TextStyle(fontFamily: 'Coolvetica'),
        titleLarge: TextStyle(fontFamily: 'Coolvetica'),
        titleMedium: TextStyle(fontFamily: 'Coolvetica'),
        titleSmall: TextStyle(fontFamily: 'Coolvetica'),
        bodyLarge: TextStyle(fontFamily: 'Coolvetica'),
        bodyMedium: TextStyle(fontFamily: 'Coolvetica'),
        bodySmall: TextStyle(fontFamily: 'Coolvetica'),
        labelLarge: TextStyle(fontFamily: 'Coolvetica'),
        labelMedium: TextStyle(fontFamily: 'Coolvetica'),
        labelSmall: TextStyle(fontFamily: 'Coolvetica'),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryBrown,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}