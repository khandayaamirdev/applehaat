import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// AppleHaatButton standardizes all primary and secondary CTAs.
/// Includes integrated loading spinner when `isLoading: true`.
class AppleHaatButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final double? width;
  final double height;

  const AppleHaatButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width = double.infinity,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    final childContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppColors.primary : AppColors.textWhite,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: AppDimensions.space8),
        ],
        Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(
            color: isOutlined ? AppColors.primary : AppColors.textWhite,
          ),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: effectiveOnPressed,
              child: childContent,
            )
          : ElevatedButton(
              onPressed: effectiveOnPressed,
              child: childContent,
            ),
    );
  }
}
