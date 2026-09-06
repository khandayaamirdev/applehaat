import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AppTextStyles defines the exact typography hierarchy from the Stitch design system.
/// Uses Plus Jakarta Sans for displays and headlines, and Inter for labels.
abstract final class AppTextStyles {
  static TextStyle get displayLg => GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 44 / 36,
        letterSpacing: -0.72,
        color: AppColors.onSurface,
      );

  static TextStyle get displayLgMobile => GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        height: 38 / 30,
        letterSpacing: -0.6,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 34 / 26,
        letterSpacing: -0.39,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 30 / 22,
        letterSpacing: -0.22,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineSm => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 22 / 14,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get bodySm => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 18 / 12,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelLg => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 20 / 15,
        letterSpacing: 0.15,
        color: AppColors.onPrimary,
      );

  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        letterSpacing: 0.13,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        letterSpacing: 0.33,
        color: AppColors.onSurfaceVariant,
      );

  // Backward compatibility getters
  static TextStyle get displayLarge => displayLg;
  static TextStyle get displayMedium => displayLgMobile;
  static TextStyle get headlineLarge => headlineLg;
  static TextStyle get headlineMedium => headlineMd;
  static TextStyle get titleLarge => headlineSm;
  static TextStyle get titleMedium => bodyLg;
  static TextStyle get bodyLarge => bodyLg;
  static TextStyle get bodyMedium => bodyMd;
  static TextStyle get bodySmall => bodySm;
  static TextStyle get labelLarge => labelLg;
  static TextStyle get labelMedium => labelMd;
}
