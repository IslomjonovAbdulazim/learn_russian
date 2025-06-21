import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // Base font families
  static String get primaryFont => GoogleFonts.inter().fontFamily!;
  static String get secondaryFont => GoogleFonts.nunito().fontFamily!;
  static String get articleFont => GoogleFonts.sourceSans3().fontFamily!;
  static String get codeFont => GoogleFonts.sourceCodePro().fontFamily!;

  // Headings - Inter font (clean, modern)
  static TextStyle get heading1 => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get heading2 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle get heading3 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get heading4 => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get heading5 => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body text - Nunito font (friendly, readable)
  static TextStyle get bodyLarge => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // Russian text - Source Sans Pro (excellent for Cyrillic)
  static TextStyle get russianLarge => GoogleFonts.sourceSans3(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  static TextStyle get russianMedium => GoogleFonts.sourceSans3(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get russianSmall => GoogleFonts.sourceSans3(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // Labels and captions
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static TextStyle get caption => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    color: AppColors.lightTextSecondary,
  );

  // Button styles
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Special styles
  static TextStyle get quote => GoogleFonts.sourceSans3(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get code => GoogleFonts.sourceCodePro(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get moduleTitle => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle get themeTitle => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get themeSubtitle => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get duration => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static TextStyle get difficulty => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  // Chat styles
  static TextStyle get chatUser => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get chatAI => GoogleFonts.sourceSans3(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get chatTimestamp => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    height: 1.2,
  );
}

// Theme-aware text styles
class ThemedTextStyles {
  static TextStyle getHeading1(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppTextStyles.heading1.copyWith(
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  static TextStyle getBodyMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppTextStyles.bodyMedium.copyWith(
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  static TextStyle getCaption(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppTextStyles.caption.copyWith(
      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
    );
  }

  static TextStyle getRussianText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppTextStyles.russianMedium.copyWith(
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }
}