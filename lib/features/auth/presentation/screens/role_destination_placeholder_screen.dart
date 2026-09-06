import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// RoleDestinationPlaceholderScreen is a minimal temporary destination for
/// Screen 6, 7, 8, or 9 (Subcategory Selection or Dashboard screens).
/// Created strictly for testing Screen 5 Role Selection navigation.
class RoleDestinationPlaceholderScreen extends StatelessWidget {
  final String title;
  final String screenNumber;
  final String roleName;

  const RoleDestinationPlaceholderScreen({
    super.key,
    required this.title,
    required this.screenNumber,
    required this.roleName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.stone900),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.ruby50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.dashboard_outlined,
                    size: 48,
                    color: AppColors.ruby600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Screen $screenNumber: $title',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.stone900,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.orchard50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.orchard100),
                  ),
                  child: Text(
                    'Selected Role: $roleName',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.orchard700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Temporary destination for Screen 5 navigation testing.\n$title will be implemented in a subsequent step.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.stone600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
