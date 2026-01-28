import 'package:flutter/material.dart';

class AppTheme {
  // =========== PUBLIC COLOR CONSTANTS ===========

  // Primary Colors for Property Tax System
  static const Color primaryColor = Color(0xFF1A5F7A); // Deep blue
  static const Color secondaryColor = Color(0xFF57CC99); // Green
  static const Color tertiaryColor = Color(0xFFFF9F1C); // Orange
  static const Color errorColor = Color(0xFFE63946); // Red
  static const Color successColor = Color(0xFF2A9D8F); // Teal
  static const Color warningColor = Color(0xFFE9C46A); // Yellow
  static const Color infoColor = Color(0xFF457B9D); // Light blue

  // Neutral Colors
  static const Color neutral50 = Color(0xFFF8F9FA);
  static const Color neutral100 = Color(0xFFE9ECEF);
  static const Color neutral200 = Color(0xFFDEE2E6);
  static const Color neutral300 = Color(0xFFCED4DA);
  static const Color neutral400 = Color(0xFFADB5BD);
  static const Color neutral500 = Color(0xFF6C757D);
  static const Color neutral600 = Color(0xFF495057);
  static const Color neutral700 = Color(0xFF343A40);
  static const Color neutral800 = Color(0xFF212529);
  static const Color neutral900 = Color(0xFF121416);

  static const Color cardBackgroundLight = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF212529);

  // Status Colors
  static const Color propertyActiveColor = Color(0xFF2A9D8F);
  static const Color propertyInactiveColor = Color(0xFFE63946);
  static const Color propertyPendingColor = Color(0xFFE9C46A);
  static const Color taxPaidColor = Color(0xFF57CC99);
  static const Color taxDueColor = Color(0xFFF4A261);
  static const Color taxOverdueColor = Color(0xFFE63946);

  // =========== TYPOGRAPHY ===========
  static const String _fontFamily = 'Inter';

  // =========== LIGHT THEME ===========
  static ThemeData get lightTheme {
    return ThemeData(
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        error: errorColor,
        brightness: Brightness.light,
        background: neutral50,
        surface: Colors.white,
        onBackground: neutral900,
        onSurface: neutral900,
      ),

      // Material 3
      useMaterial3: true,

      // Typography
      fontFamily: _fontFamily,
      textTheme: _buildLightTextTheme(),

      // ... rest of light theme properties
    );
  }

  // =========== DARK THEME ===========
  static ThemeData get darkTheme {
    return ThemeData(
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        error: errorColor,
        brightness: Brightness.dark,
        background: neutral900,
        surface: neutral800,
        onBackground: neutral100,
        onSurface: neutral100,
      ),

      // Material 3
      useMaterial3: true,

      // Typography
      fontFamily: _fontFamily,
      textTheme: _buildDarkTextTheme(),

      // ... rest of dark theme properties
    );
  }

  // =========== TEXT THEME BUILDERS ===========
  static TextTheme _buildLightTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: neutral900,
      ),
      displayMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: neutral900,
      ),
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: neutral900,
      ),
      headlineLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: neutral900,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: neutral900,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: neutral900,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: neutral900,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: neutral800,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: neutral700,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: neutral800,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: neutral700,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: neutral600,
      ),
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: neutral700,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: neutral600,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: neutral500,
      ),
    );
  }

  static TextTheme _buildDarkTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: neutral100,
      ),
      displayMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: neutral100,
      ),
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: neutral100,
      ),
      headlineLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: neutral100,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: neutral100,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: neutral100,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: neutral100,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: neutral200,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: neutral300,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: neutral200,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: neutral300,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: neutral400,
      ),
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: neutral300,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: neutral400,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: neutral500,
      ),
    );
  }

  // =========== CUSTOM TEXT STYLES ===========
  // These are static getters that you can access directly
  static TextStyle get sectionTitleStyle {
    return const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF212529), // neutral900
    );
  }

  static TextStyle get propertyIdStyle {
    return const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1A5F7A), // primaryColor
    );
  }

  static TextStyle get propertyAddressStyle {
    return const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF495057), // neutral600
    );
  }

  static TextStyle get propertyValueStyle {
    return const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1A5F7A), // primaryColor
    );
  }

  static TextStyle get propertyTaxStyle {
    return const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE63946), // errorColor
    );
  }

  static TextStyle get labelStyle {
    return const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF6C757D), // neutral500
    );
  }

  static TextStyle get valueStyle {
    return const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF212529), // neutral900
    );
  }

  // =========== CUSTOM CHIP STYLES ===========
  static ChipThemeData get activePropertyChip {
    return ChipThemeData(
      backgroundColor: propertyActiveColor.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: propertyActiveColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  static ChipThemeData get inactivePropertyChip {
    return ChipThemeData(
      backgroundColor: propertyInactiveColor.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: propertyInactiveColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  static ChipThemeData get paidTaxChip {
    return ChipThemeData(
      backgroundColor: taxPaidColor.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: taxPaidColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  static ChipThemeData get dueTaxChip {
    return ChipThemeData(
      backgroundColor: taxDueColor.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: taxDueColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}

// =========== HELPER EXTENSIONS FOR CONTEXT ===========
extension ThemeExtensions on BuildContext {
  // Quick access to theme text styles (static getters)
  TextStyle get sectionTitleStyle => AppTheme.sectionTitleStyle;
  TextStyle get propertyIdStyle => AppTheme.propertyIdStyle;
  TextStyle get propertyAddressStyle => AppTheme.propertyAddressStyle;
  TextStyle get propertyValueStyle => AppTheme.propertyValueStyle;
  TextStyle get propertyTaxStyle => AppTheme.propertyTaxStyle;
  TextStyle get labelStyle => AppTheme.labelStyle;
  TextStyle get valueStyle => AppTheme.valueStyle;

  // Quick access to theme colors (static constants)
  Color get primaryColor => AppTheme.primaryColor;
  Color get secondaryColor => AppTheme.secondaryColor;
  Color get tertiaryColor => AppTheme.tertiaryColor;
  Color get errorColor => AppTheme.errorColor;
  Color get successColor => AppTheme.successColor;
  Color get warningColor => AppTheme.warningColor;
  Color get infoColor => AppTheme.infoColor;
  Color get propertyActiveColor => AppTheme.propertyActiveColor;
  Color get propertyInactiveColor => AppTheme.propertyInactiveColor;
  Color get propertyPendingColor => AppTheme.propertyPendingColor;
  Color get taxPaidColor => AppTheme.taxPaidColor;
  Color get taxDueColor => AppTheme.taxDueColor;
  Color get taxOverdueColor => AppTheme.taxOverdueColor;

  // Neutral colors
  Color get neutral50 => AppTheme.neutral50;
  Color get neutral100 => AppTheme.neutral100;
  Color get neutral200 => AppTheme.neutral200;
  Color get neutral300 => AppTheme.neutral300;
  Color get neutral400 => AppTheme.neutral400;
  Color get neutral500 => AppTheme.neutral500;
  Color get neutral600 => AppTheme.neutral600;
  Color get neutral700 => AppTheme.neutral700;
  Color get neutral800 => AppTheme.neutral800;
  Color get neutral900 => AppTheme.neutral900;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Card background color from the current theme
  Color get cardBackground =>
      Theme.of(this).cardTheme.color ??
      (isDarkMode ? AppTheme.cardBackgroundDark : AppTheme.cardBackgroundLight);

  // Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Custom property status chip
  ChipThemeData get activePropertyChip => AppTheme.activePropertyChip;
  ChipThemeData get inactivePropertyChip => AppTheme.inactivePropertyChip;
  ChipThemeData get paidTaxChip => AppTheme.paidTaxChip;
  ChipThemeData get dueTaxChip => AppTheme.dueTaxChip;

  // Text theme shortcuts
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
}
