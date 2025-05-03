import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primaryGreen =
      Color(0xFF2E7D32); // Dark green for primary actions
  static const Color lightGreen =
      Color(0xFFA5D6A7); // Light green for backgrounds
  static const Color accentGreen =
      Color(0xFF4CAF50); // Medium green for accents

  // Secondary colors
  static const Color secondary =
      Color(0xFFFF9800); // Orange for warnings/notifications
  static const Color error = Color(0xFFD32F2F); // Red for errors
  static const Color success = Color(0xFF388E3C); // Green for success states

  // Neutrals
  static const Color textDark = Color(0xFF212121); // Primary text
  static const Color textMedium = Color(0xFF757575); // Secondary text
  static const Color textLight = Color(0xFFBDBDBD); // Disabled text
  static const Color divider = Color(0xFFE0E0E0); // Dividers

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light backgrounds
  static const Color backgroundDark =
      Color(0xFF121212); // Dark mode backgrounds
  static const Color cardLight = Color(0xFFFFFFFF); // Card backgrounds
  static const Color cardDark = Color(0xFF1E1E1E); // Dark mode card backgrounds

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF2E7D32), // Dark green
    Color(0xFF4CAF50), // Medium green
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFE8F5E9), // Very light green
    Color(0xFFC8E6C9), // Light green
  ];
}
