import 'package:flutter/material.dart';

class AppTheme {
  // Define your color constants
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFFA5D6A7);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF9FBE7);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color errorColor = Color(0xFFF44336);

  // Create the ThemeData
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor, // Set the error color in the ColorScheme
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: primaryTextColor), // Use appropriate text style names
        bodyMedium: TextStyle(
            color:
                secondaryTextColor), // Updated for Flutter's latest TextTheme
        bodySmall:
            TextStyle(color: Colors.black54), // Optional for smaller text
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      // Additional theming options can be added here
    );
  }
}
