import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryColor = Color(0xFF002454);
  static const Color primaryDark = Color(0xFF001633);
  static const Color primaryLight = Color(0xFF003D7A);

  static const Color secondaryColor = Color(0xFF123462);
  static const Color accentColor = Color(0xFF4A90E2);

  // Background Colors
  static const Color bgColor = Color(0xFFF8F9FA);
  static const Color bgColorDark = Color(0xFFECEFF1);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color blue = Color(0xFF123462);
  static const Color darkRed = Color(0xFF841414);
  static const Color orange = Color(0xFFFF8133);
  static const Color red = Color(0xFFE0554E);
  static const Color green = Color(0xFF24A584);
  static const Color lightGreen = Color(0xFF75C6B2);

  // Text Colors
  static const Color black = Color(0xFF111111);
  static const Color headlineText = Color(0xFF2C3E50);
  static const Color bodyText = Color(0xFF5A6C7D);
  static const Color grey = Color(0xFF414141);
  static const Color greyLight = Color(0xFF9E9E9E);
  static const Color white = Color(0xFFFFFFFF);

  // Field Colors
  static const Color textFieldBorderColor = Color(0xFFEFF8FF);
  static const Color textFieldShade = Color(0xFFFFF2EB);
  static const Color iconBackground = Color(0xFFEBEDED);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF002454);
  static const Color gradientMiddle = Color(0xFF003D7A);
  static const Color gradientEnd = Color(0xFF4A90E2);

  static const Color cardGradientStart = Color(0xFFFFFFFF);
  static const Color cardGradientEnd = Color(0xFFF8F9FA);

  // Modern Accent Gradients
  static const Color accentGradient1 = Color(0xFF667EEA);
  static const Color accentGradient2 = Color(0xFF764BA2);

  static const Color successGradient1 = Color(0xFF56AB2F);
  static const Color successGradient2 = Color(0xFFA8E063);

  static const Color errorGradient1 = Color(0xFFE55D87);
  static const Color errorGradient2 = Color(0xFF5FC3E4);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // ============================================================================
  // GRADIENT DEFINITIONS
  // ============================================================================

  /// Primary gradient for AppBar, buttons, and major UI elements
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradientStart,
      gradientMiddle,
      gradientEnd,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Subtle card gradient for elevated surfaces
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      cardGradientStart,
      cardGradientEnd,
    ],
  );

  /// Modern accent gradient for highlights and CTAs
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentGradient1,
      accentGradient2,
    ],
  );

  /// Success gradient for positive states
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      successGradient1,
      successGradient2,
    ],
  );

  /// Error/Alert gradient
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      errorGradient1,
      errorGradient2,
    ],
  );

  /// Shimmer gradient for loading states
  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      shimmerBase,
      shimmerHighlight,
      shimmerBase,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Glass morphism gradient
  static LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      white.withOpacity(0.2),
      white.withOpacity(0.1),
    ],
  );

  /// Dark overlay gradient
  static const LinearGradient darkOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00000000),
      Color(0x80000000),
    ],
  );
}