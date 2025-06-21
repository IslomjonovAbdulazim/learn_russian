import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: _createMaterialColor(AppColors.primaryBlue),
    primaryColor: AppColors.primaryBlue,
    primaryColorLight: AppColors.primaryBlueLight,
    primaryColorDark: AppColors.primaryBlueDark,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      primaryContainer: AppColors.primaryBlueLight,
      secondary: AppColors.secondaryAmber,
      secondaryContainer: AppColors.secondaryAmberLight,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      onBackground: AppColors.lightTextPrimary,
      onError: Colors.white,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.lightBackground,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.heading4.copyWith(
        color: AppColors.lightTextPrimary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 2,
      shadowColor: AppColors.lightShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        textStyle: AppTextStyles.buttonMedium,
        side: const BorderSide(color: AppColors.primaryBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      filled: true,
      fillColor: AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.lightTextPrimary),
      displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.lightTextPrimary),
      displaySmall: AppTextStyles.heading3.copyWith(color: AppColors.lightTextPrimary),
      headlineLarge: AppTextStyles.heading4.copyWith(color: AppColors.lightTextPrimary),
      headlineMedium: AppTextStyles.heading5.copyWith(color: AppColors.lightTextPrimary),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.lightTextPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightTextPrimary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.lightTextSecondary),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.lightTextPrimary),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.lightTextSecondary),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.lightTextSecondary),
    ),
  );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: _createMaterialColor(AppColors.primaryBlueLight),
    primaryColor: AppColors.primaryBlueLight,
    primaryColorLight: AppColors.primaryBlue,
    primaryColorDark: AppColors.primaryBlueDark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlueLight,
      primaryContainer: AppColors.primaryBlueDark,
      secondary: AppColors.secondaryAmberLight,
      secondaryContainer: AppColors.secondaryAmberDark,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.darkTextPrimary,
      onBackground: AppColors.darkTextPrimary,
      onError: Colors.white,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.darkBackground,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.heading4.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 4,
      shadowColor: AppColors.darkShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlueLight,
        foregroundColor: Colors.black,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlueLight,
        textStyle: AppTextStyles.buttonMedium,
        side: const BorderSide(color: AppColors.primaryBlueLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlueLight,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlueLight, width: 2),
      ),
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.darkTextPrimary),
      displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.darkTextPrimary),
      displaySmall: AppTextStyles.heading3.copyWith(color: AppColors.darkTextPrimary),
      headlineLarge: AppTextStyles.heading4.copyWith(color: AppColors.darkTextPrimary),
      headlineMedium: AppTextStyles.heading5.copyWith(color: AppColors.darkTextPrimary),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextPrimary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkTextSecondary),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.darkTextPrimary),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.darkTextSecondary),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.darkTextSecondary),
    ),
  );

  // Helper method to create MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};

    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final double strength in strengths) {
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