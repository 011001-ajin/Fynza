import 'package:flutter/material.dart';

/// Central Material 3 theme for Fynza.
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Google Sans';
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // Warm Vanilla Cream Palette
  static const Color primaryAmber = Color(
    0xFFF6A63C,
  ); // Warm Apricot / Honey Amber
  static const Color scaffoldCream = Color(
    0xFFFDF8F3,
  ); // Warm cozy cream scaffold
  static const Color cardWhite = Color(0xFFFFFFFF); // Cloud white cards
  static const Color textCharcoal = Color(
    0xFF23201D,
  ); // Deep warm charcoal text
  static const Color textTaupe = Color(0xFF857E77); // Warm taupe for subtitles
  static const Color borderCream = Color(0xFFF0E7DC); // Soft hairline divider

  // Pastel Feature Accents (Expenses blush & Income mint)
  static const Color expenseCardBg = Color(0xFFFDECE9); // Soft rose blush
  static const Color expenseAccent = Color(0xFFD94136); // Warm coral red
  static const Color incomeCardBg = Color(0xFFE6F5EC); // Matcha mint
  static const Color incomeAccent = Color(0xFF238244); // Forest jade green
  static const Color expenseCardBgDark = Color(0xFF331D1C);
  static const Color expenseCardPressedBgDark = Color(0xFF482725);
  static const Color expenseAccentDark = Color(0xFFFF8A80);
  static const Color expenseCardPressedBg = Color(0xFFF9D5CF);
  static const Color incomeCardBgDark = Color(0xFF162D20);
  static const Color incomeCardPressedBgDark = Color(0xFF1E3E2C);
  static const Color incomeAccentDark = Color(0xFF81C784);
  static const Color incomeCardPressedBg = Color(0xFFD2EEDC);

  static const Color tealAccent = Color(0xFF2E7A7D);
  static const Color budgetWarningAccent = Color(0xFFF57F17);
  static const Color dashboardBudgetCardDark = Color(0xFF2E233C);
  static const Color dashboardBudgetCard = Color(0xFFF3ECFA);
  static const Color dashboardBudgetBadgeDark = Color(0xFF4A385E);
  static const Color dashboardBudgetBadge = Color(0xFFE2D4F5);
  static const Color dashboardBudgetAccent = Color(0xFF8E61C9);
  static const Color dashboardCategoryCardDark = Color(0xFF1E2D3B);
  static const Color dashboardCategoryCard = Color(0xFFEAF4FC);
  static const Color dashboardCategoryAccent = Color(0xFF2980B9);
  static const Color warmSurfaceHighlight = Color(0xFFF7F2EB);

  // Pastel Rainbow Chart Palette
  static const List<Color> pastelChartColors = [
    Color(0xFFF49E8C), // Pastel Peach (Food)
    Color(0xFF7DBCE6), // Soft Sky Blue (Transport)
    Color(0xFFC2A5E7), // Pastel Lilac (Shopping)
    Color(0xFFF7CE72), // Warm Sunlight (Entertainment)
    Color(0xFF7FDCB8), // Soft Seafoam (Others)
  ];

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryAmber,
      brightness: Brightness.light,
    ).copyWith(surface: scaffoldCream);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: scaffoldCream,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(48, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(48, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      textTheme: _buildGoogleSansTextTheme(ThemeData.light().textTheme),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryAmber,
      brightness: Brightness.dark,
    ).copyWith(surface: const Color(0xFF191715));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(48, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(48, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      textTheme: _buildGoogleSansTextTheme(ThemeData.dark().textTheme),
    );
  }

  /// Applies the bundled Google Sans family with readable text leading.
  static TextTheme _buildGoogleSansTextTheme(TextTheme base) {
    final googleSans = base.apply(fontFamily: fontFamily);

    return googleSans.copyWith(
      displayLarge: googleSans.displayLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      displayMedium: googleSans.displayMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      displaySmall: googleSans.displaySmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      headlineLarge: googleSans.headlineLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: googleSans.headlineMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: googleSans.headlineSmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      titleLarge: googleSans.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      titleMedium: googleSans.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      titleSmall: googleSans.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: googleSans.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: googleSans.bodyMedium?.copyWith(height: 1.45),
    );
  }
}
