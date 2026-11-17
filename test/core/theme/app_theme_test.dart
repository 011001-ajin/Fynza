import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynza/core/theme/app_theme.dart';

void main() {
  test('light and dark themes use Google Sans', () {
    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      expect(theme.textTheme.bodyMedium?.fontFamily, AppTheme.fontFamily);
    }
  });

  test('app bars do not tint or elevate when content scrolls underneath', () {
    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      expect(theme.appBarTheme.scrolledUnderElevation, 0);
      expect(theme.appBarTheme.surfaceTintColor, Colors.transparent);
    }
  });
}
