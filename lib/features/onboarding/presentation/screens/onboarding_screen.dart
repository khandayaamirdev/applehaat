import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/route_names.dart';
import '../widgets/onboarding_slide1_graphic.dart';
import '../widgets/onboarding_slide2_graphic.dart';
import '../widgets/onboarding_slide3_graphic.dart';

/// OnboardingScreen implements Screen 2 — AppleHaat Onboarding Walkthrough
/// strictly following the provided Stitch design source of truth.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalSlides = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSlide(int index) {
    if (index >= 0 && index < _totalSlides && index != _currentPage) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 380),
        curve: const Cubic(0.25, 1.0, 0.5, 1.0),
      );
    }
  }

  void _goToAuth() {
    // Navigate to Login/Register and replace route to prevent back-navigation
    context.go(RouteNames.loginPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // bg-slate-50
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Header
            _buildTopHeader(),

            // Swipeable Viewport (PageView)
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildSlide(
                    graphic: (size) => OnboardingSlide1Graphic(size: size),
                    title: 'Everything Apple,\nIn One Place',
                    subtitle: 'Connect with the apple community across Kashmir.',
                    maxSubtitleWidth: 280,
                  ),
                  _buildSlide(
                    graphic: (size) => OnboardingSlide2Graphic(size: size),
                    title: 'Connect Directly',
                    subtitle:
                        'Growers, buyers, suppliers and service providers can find and connect with each other.',
                    maxSubtitleWidth: 290,
                  ),
                  _buildSlide(
                    graphic: (size) => OnboardingSlide3Graphic(size: size),
                    title: 'Find. List. Connect.',
                    subtitle:
                        'List your apples, discover products and services, and chat directly with the people you need.',
                    maxSubtitleWidth: 290,
                  ),
                ],
              ),
            ),

            // Bottom Controls & CTA Section
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  /// Top Navigation Header with Skip button on the right
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 8),
      child: SizedBox(
        height: 44,
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _goToAuth,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Skip',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B), // text-slate-500
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Individual Slide layout containing the illustration graphic and responsive text copy
  Widget _buildSlide({
    required Widget Function(double size) graphic,
    required String title,
    required String subtitle,
    required double maxSubtitleWidth,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapt graphic size dynamically based on available height to avoid overflow on small screens
        final availableHeight = constraints.maxHeight;
        final isCompactScreen = availableHeight < 480;

        // Size between 200 and 256 depending on screen height
        final double graphicSize = isCompactScreen
            ? (availableHeight * 0.48).clamp(180.0, 220.0)
            : (availableHeight * 0.54).clamp(210.0, 256.0);

        final double titleFontSize = isCompactScreen ? 22.0 : 25.0;
        final double subtitleFontSize = isCompactScreen ? 13.0 : 14.5;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration / Graphic
              Center(
                child: SizedBox(
                  width: graphicSize,
                  height: graphicSize,
                  child: Center(
                    child: graphic(graphicSize),
                  ),
                ),
              ),

              // Text Copy Block
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A), // text-slate-900
                      letterSpacing: -0.5,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxSubtitleWidth),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B), // text-slate-500
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Bottom Controls: Animated Dots Indicator, Get Started CTA on slide 3, and Step Counter
  Widget _buildBottomControls() {
    final isLastSlide = _currentPage == _totalSlides - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Interactive Dots Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalSlides, (index) {
                final isActive = index == _currentPage;
                return GestureDetector(
                  onTap: () => _goToSlide(index),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isActive ? 28 : 8,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFDC2626) // red-600
                            : const Color(0xFFE2E8F0), // slate-200
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                );
              }),
            ),

            // On Slide 3: Get Started Button (Slides 1 & 2 have no buttons — swipe only)
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isLastSlide
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _goToAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626), // red-600
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor:
                                const Color(0xFFDC2626).withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 12),

            // Step Counter Footnote
            Text(
              'Step ${_currentPage + 1} of $_totalSlides',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF94A3B8), // text-slate-400
              ),
            ),
          ],
        ),
      ),
    );
  }
}
