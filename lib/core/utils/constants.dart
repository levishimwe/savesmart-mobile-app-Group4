import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  // App colors based on Figma design
  static const Color primaryGreen = Color(0xFF00695C);
  static const Color lightGreen = Color(0xFFE0F2F1);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF004D40);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF4CAF50);

  // Spacing
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;

  // Border radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 20.0;

  // Firebase collection names
  static const String usersCollection = 'users';
  static const String goalsCollection = 'goals';
  static const String transactionsCollection = 'transactions';
  static const String tipsCollection = 'tips';
  static const String savingsCollection = 'savings';

  // SharedPreferences keys
  static const String themeKey = 'theme_mode';
  static const String notificationsKey = 'notifications_enabled';
  static const String languageKey = 'language';

  // Error messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'Please check your internet connection.';
  static const String authErrorMessage =
      'Authentication failed. Please try again.';
}
