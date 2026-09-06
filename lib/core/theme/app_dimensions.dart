import 'package:flutter/material.dart';

/// AppDimensions centralizes standard spacing, radius, and elevation values.
abstract final class AppDimensions {
  // Spacing & Padding
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Screen Insets
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: space20,
    vertical: space16,
  );

  // Border Radii
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;
  static const double radiusCircular = 999.0;

  // Heights
  static const double buttonHeight = 52.0;
  static const double inputHeight = 52.0;
  static const double otpBoxSize = 48.0;
}
