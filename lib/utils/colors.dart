import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Russian flag inspired blues
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color primaryBlueLight = Color(0xFF42A5F5);
  static const Color primaryBlueDark = Color(0xFF0D47A1);

  // Secondary Colors - Warm and encouraging
  static const Color secondaryAmber = Color(0xFFFFA726);
  static const Color secondaryAmberLight = Color(0xFFFFD54F);
  static const Color secondaryAmberDark = Color(0xFFFF8F00);

  // Accent Colors
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color accentOrange = Color(0xFFFF7043);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightShadow = Color(0x1F000000);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkDivider = Color(0xFF404040);
  static const Color darkShadow = Color(0x3F000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueLight],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryAmber, secondaryAmberLight],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
  );

  // Voice Animation Colors
  static const List<Color> voiceWaveColors = [
    primaryBlue,
    primaryBlueLight,
    secondaryAmber,
    accentGreen,
  ];

  // Difficulty Level Colors
  static const Map<int, Color> difficultyColors = {
    1: Color(0xFF4CAF50), // Green - Easy
    2: Color(0xFF8BC34A), // Light Green - Medium Easy
    3: Color(0xFFFFC107), // Amber - Medium
    4: Color(0xFFFF9800), // Orange - Hard
    5: Color(0xFFF44336), // Red - Very Hard
  };

  // Module Category Colors (Light)
  static const List<Color> moduleColorsLight = [
    Color(0xFFE3F2FD), // Light Blue
    Color(0xFFF3E5F5), // Light Purple
    Color(0xFFE8F5E8), // Light Green
    Color(0xFFFFF3E0), // Light Orange
    Color(0xFFE1F5FE), // Light Cyan
    Color(0xFFFCE4EC), // Light Pink
  ];

  // Module Category Colors (Dark)
  static const List<Color> moduleColorsDark = [
    Color(0xFF1A237E), // Dark Blue
    Color(0xFF4A148C), // Dark Purple
    Color(0xFF1B5E20), // Dark Green
    Color(0xFFE65100), // Dark Orange
    Color(0xFF006064), // Dark Cyan
    Color(0xFFAD1457), // Dark Pink
  ];

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Transparent Colors
  static const Color transparent = Colors.transparent;
  static const Color semiTransparent = Color(0x80000000);
  static const Color lightTransparent = Color(0x40000000);
}

// Extension for getting theme-based colors
extension AppColorsExtension on AppColors {
  static Color getModuleColor(int index, bool isDark) {
    final colors = isDark ? AppColors.moduleColorsDark : AppColors.moduleColorsLight;
    return colors[index % colors.length];
  }

  static Color getDifficultyColor(int difficulty) {
    return AppColors.difficultyColors[difficulty] ?? AppColors.info;
  }
}