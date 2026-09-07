import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/applehaat_logo.dart';

/// SplashScreen implements Screen 1 exactly following the Stitch design source of truth.
/// Displays the AppleHaat branding, smooth 900ms subtle reveal micro-animation,
/// and automatically navigates to the next screen after 2.5 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _opacityAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _slideAnim;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Setup 900ms subtle reveal animation matching Stitch cubic-bezier(0.16, 1, 0.3, 1)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    const curve = Cubic(0.16, 1.0, 0.3, 1.0);
    final curvedAnim = CurvedAnimation(parent: _animController, curve: curve);

    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnim);
    _scaleAnim = Tween<double>(begin: 0.96, end: 1.0).animate(curvedAnim);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.04), // Translates ~6px vertically
      end: Offset.zero,
    ).animate(curvedAnim);

    _animController.forward();

    // Wait 2.5 seconds, then replace route to prevent back-navigation to splash
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go(RouteNames.onboardingPath);
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompact = mediaQuery.size.width < 360;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.mistBgTop,
              AppColors.mistBgMiddle,
              AppColors.mistBgBottom,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Safe Area Buffer
              const SizedBox(height: 16),

              // Center Brand Hero with Subtle Reveal Animation
              SlideTransition(
                position: _slideAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: FadeTransition(
                    opacity: _opacityAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 130x130 Brand Logo Container
                          const AppleHaatLogo(
                            size: 130,
                          ),
                          const SizedBox(height: 24),

                          // Brand Name with exact color split: Apple (Charcoal) + Haat (Crimson)
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.displayLg.copyWith(
                                fontSize: isCompact ? 32 : 36,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.72,
                                height: 1.0,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Apple',
                                  style: TextStyle(
                                    color: AppColors.brandCharcoal,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Haat',
                                  style: TextStyle(
                                    color: AppColors.brandCrimson,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Exact Verbatim Tagline with max 280px constraint
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(
                              AppConstants.appTagline,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyLg.copyWith(
                                fontSize: isCompact ? 14 : 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF525252),
                                letterSpacing: 0.15,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Indicator / Kashmiri Origin Note
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'v1.0 • Proudly from Kashmir',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
