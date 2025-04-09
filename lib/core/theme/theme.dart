import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/pallet.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: screenBgColor,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: buttonBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}
