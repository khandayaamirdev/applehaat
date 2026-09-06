import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import 'applehaat_button.dart';

enum AppleHaatStateType { loading, error, empty }

/// AppleHaatStateView handles unified loading, error, and empty states.
class AppleHaatStateView extends StatelessWidget {
  final AppleHaatStateType stateType;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryText;
  final Widget? customIcon;

  const AppleHaatStateView.loading({
    super.key,
    this.message = 'Loading AppleHaat...',
  })  : stateType = AppleHaatStateType.loading,
        title = null,
        onRetry = null,
        retryText = 'Retry',
        customIcon = null;

  const AppleHaatStateView.error({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Unable to connect to the server. Please check your connection and retry.',
    required this.onRetry,
    this.retryText = 'Retry',
    this.customIcon,
  }) : stateType = AppleHaatStateType.error;

  const AppleHaatStateView.empty({
    super.key,
    this.title = 'No records found',
    this.message = 'There is currently no information available.',
    this.onRetry,
    this.retryText = 'Refresh',
    this.customIcon,
  }) : stateType = AppleHaatStateType.empty;

  @override
  Widget build(BuildContext context) {
    if (stateType == AppleHaatStateType.loading) {
      return Center(
        child: Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              if (message != null) ...[
                const SizedBox(height: AppDimensions.space16),
                Text(
                  message!,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    }

    final isError = stateType == AppleHaatStateType.error;
    final defaultIcon = Icon(
      isError ? Icons.wifi_off_rounded : Icons.inbox_outlined,
      size: 56,
      color: isError ? AppColors.error : AppColors.textTertiary,
    );

    return Center(
      child: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customIcon ?? defaultIcon,
            const SizedBox(height: AppDimensions.space16),
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space8),
            ],
            if (message != null) ...[
              Text(
                message!,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space24),
            ],
            if (onRetry != null)
              AppleHaatButton(
                text: retryText,
                onPressed: onRetry,
                width: 180,
                isOutlined: !isError,
              ),
          ],
        ),
      ),
    );
  }
}
