import 'package:flutter/material.dart';

class AppTheme {
  // New Professional Gradient colors (Matching Images: Blue at top, White at bottom)
  static const List<Color> backgroundGradient = [
    Color(0xFF3A7BFF), // Professional Blue
    Color(0xFFFFFFFF), // White
  ];
  
  // Card gradient colors (Legacy - but updated for consistency)
  static const List<Color> diaryGradient = [Color(0xFF8EACCD), Color(0xFF3A7BFF)];
  static const List<Color> syllabusGradient = [Color(0xFF6499E9), Color(0xFF3A7BFF)];
  static const List<Color> examsGradient = [Color(0xFFBEADFA), Color(0xFF3A7BFF)];
  static const List<Color> circularsGradient = [Color(0xFF91C8E4), Color(0xFF3A7BFF)];
  static const List<Color> timetableGradient = [Color(0xFF3A7BFF), Color(0xFF1E56A0)];
  static const List<Color> attendanceGradient = [Color(0xFF72A0C1), Color(0xFF3A7BFF)];

  // Professional Core Colors
  static const Color primaryColor = Color(0xFF3A7BFF);
  static const Color secondaryColor = Color(0xFF1E56A0);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF5D6D7E);
  static const Color accentColor = Color(0xFF3498DB);
  static const Color morningColor = Color(0xFF3498DB);
  static const Color eveningColor = Color(0xFFE67E22);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1645),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  static Widget gradientBackground({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: backgroundGradient,
        ),
      ),
      child: child,
    );
  }

  static Widget professionalCard({
    required Widget child,
    double borderRadius = 16,
    double elevation = 4,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget glassmorphismCard({
    required Widget child,
    required List<Color> gradientColors,
    double borderRadius = 20,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
