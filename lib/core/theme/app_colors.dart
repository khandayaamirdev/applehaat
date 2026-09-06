import 'package:flutter/material.dart';

/// AppColors defines the exact Stitch color tokens for AppleHaat.
abstract final class AppColors {
  // Primary (Deep Apple Crimson)
  static const Color primary = Color(0xFFA20428);
  static const Color primaryContainer = Color(0xFFC5283D);
  static const Color primaryFixed = Color(0xFFFFDAD9);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFE0E0);

  // Secondary (Orchard Green)
  static const Color secondary = Color(0xFF1C6B42);
  static const Color secondaryContainer = Color(0xFFA5F4BF);
  static const Color onSecondaryContainer = Color(0xFF247248);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Stitch Screen 1 & 2 Tokens
  static const Color brandCharcoal = Color(0xFF1F2937);
  static const Color brandCrimson = Color(0xFFC62828);
  static const Color brandGreen = Color(0xFF2E7D32);
  static const Color mistBgTop = Color(0xFFFFFFFF);
  static const Color mistBgMiddle = Color(0xFFFAFBF9);
  static const Color mistBgBottom = Color(0xFFF4F7F2);

  // Screen 2 Stitch Palette Tokens
  static const Color parchment = Color(0xFFFAFAF8);
  static const Color ruby50 = Color(0xFFFDF2F2);
  static const Color ruby600 = Color(0xFFC62828);
  static const Color ruby700 = Color(0xFFB71C1C);
  static const Color orchard50 = Color(0xFFF1F8E9);
  static const Color orchard100 = Color(0xFFDCEDC8);
  static const Color orchard600 = Color(0xFF43A047);
  static const Color orchard700 = Color(0xFF2E7D32);
  static const Color stone50 = Color(0xFFFAFAF9);
  static const Color stone200 = Color(0xFFE7E5E4);
  static const Color stone400 = Color(0xFFA8A29E);
  static const Color stone500 = Color(0xFF78716C);
  static const Color stone600 = Color(0xFF57534E);
  static const Color stone700 = Color(0xFF44403C);
  static const Color stone800 = Color(0xFF292524);
  static const Color stone900 = Color(0xFF1C1917);



  // Surface & Backgrounds
  static const Color background = Color(0xFFF9F9FF);
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // White cards
  static const Color surfaceContainerLow = Color(0xFFF1F3FF);
  static const Color surfaceContainer = Color(0xFFE8EEFF);
  static const Color surfaceContainerHigh = Color(0xFFE3E8F9);
  static const Color surfaceContainerHighest = Color(0xFFDDE2F3);
  static const Color surfaceVariant = Color(0xFFDDE2F3);

  // Text & Content
  static const Color onSurface = Color(0xFF161C27); // Dark Slate Heading
  static const Color onSurfaceVariant = Color(0xFF5A4040); // Muted Subtitle
  static const Color outline = Color(0xFF8E706F); // Decorative ribbon & footer
  static const Color outlineVariant = Color(0xFFE2BEBD); // Separator lines

  // Status & Feedback
  static const Color success = Color(0xFF1C6B42);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Dark / Inverse (Live Mandi Ticker)
  static const Color inverseSurface = Color(0xFF2A303D);
  static const Color inverseOnSurface = Color(0xFFECF0FF);
  static const Color tertiaryFixedDim = Color(0xFF71DC8D);
  static const Color tertiaryFixed = Color(0xFF8DF9A7);
  static const Color onTertiaryFixed = Color(0xFF00210B);
  static const Color inversePrimary = Color(0xFFFFB3B3);

  // Legacy compatibility mappings
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textTertiary = outline;
  static const Color textWhite = onPrimary;
  static const Color border = surfaceVariant;
  static const Color borderFocused = primary;
  static const Color primaryDark = Color(0xFF7A001C);
  static const Color accentLight = Color(0xFFFFD149);
}
