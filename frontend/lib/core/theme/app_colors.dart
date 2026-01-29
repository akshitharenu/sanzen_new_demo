import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryDark = Color(0xFF1D3724);
  static const Color primaryGreen = Color(0xFF0E552B);
  static const Color gold = Color(0xFFC2A563);
  static const Color goldBright = Color(0xFFF7CE45);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF313131);
  static const Color grey = Color(0xFFB8B8B8);
  static const Color lightGrey = Color(0xFFD9D9D9);

  // Social Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF43A047);
  static const Color info = Color(0xFF448AFF);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);

  // Transparent
  static const Color blackOverlay = Color(0x66000000);
  static const Color whiteOverlay = Color(0x33FFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryGreen],
  );

  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryDark, primaryGreen],
  );

  static const RadialGradient primaryRadialGradient = RadialGradient(
    center: Alignment(0.0, -0.38),
    radius: 0.7,
    colors: [primaryGreen, primaryDark],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x99FFFFFF),
      Color(0x99AFAFAF),
    ],
  );
}
