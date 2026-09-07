import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/route_names.dart';
import 'package:mobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mobile/features/onboarding/presentation/widgets/onboarding_slide1_graphic.dart';
import 'package:mobile/features/onboarding/presentation/widgets/onboarding_slide2_graphic.dart';
import 'package:mobile/features/onboarding/presentation/widgets/onboarding_slide3_graphic.dart';

void main() {
  Widget createTestWidget() {
    final router = GoRouter(
      initialLocation: RouteNames.onboardingPath,
      routes: [
        GoRoute(
          path: RouteNames.onboardingPath,
          name: RouteNames.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: RouteNames.loginPath,
          name: RouteNames.login,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Login Screen Target')),
          ),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('Screen 2 — AppleHaat Onboarding Walkthrough (Swipe-Only Navigation)', () {
    testWidgets('Renders Slide 1 without any Back or Next buttons, only Skip and sliding',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Slide 1 Graphic & Text
      expect(find.byType(OnboardingSlide1Graphic), findsOneWidget);
      expect(find.text('Everything Apple,\nIn One Place'), findsOneWidget);
      expect(
        find.text('Connect with the apple community across Kashmir.'),
        findsOneWidget,
      );

      // Verify no Back or Next buttons exist
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      expect(find.text('Back'), findsNothing);
      expect(find.text('Next'), findsNothing);

      // Controls present
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Step 1 of 3'), findsOneWidget);
    });

    testWidgets('Sliding/swiping navigates through Slides 1 -> 2 -> 3 without Back/Next buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Initial on Slide 1
      expect(find.text('Step 1 of 3'), findsOneWidget);
      expect(find.text('Back'), findsNothing);
      expect(find.text('Next'), findsNothing);

      // 2. Slide left -> Slide 2
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingSlide2Graphic), findsOneWidget);
      expect(find.text('Connect Directly'), findsOneWidget);
      expect(
        find.text(
            'Growers, buyers, suppliers and service providers can find and connect with each other.'),
        findsOneWidget,
      );
      expect(find.text('Step 2 of 3'), findsOneWidget);
      // Verify still no Back or Next buttons
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      expect(find.text('Back'), findsNothing);
      expect(find.text('Next'), findsNothing);

      // 3. Slide left -> Slide 3
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingSlide3Graphic), findsOneWidget);
      expect(find.text('Find. List. Connect.'), findsOneWidget);
      expect(
        find.text(
            'List your apples, discover products and services, and chat directly with the people you need.'),
        findsOneWidget,
      );
      expect(find.text('Apple Listing'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);
      expect(find.text('Direct Chat'), findsOneWidget);
      expect(find.text('Step 3 of 3'), findsOneWidget);

      // Verify no Back or Next buttons, but Get Started is present on Slide 3
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      expect(find.text('Back'), findsNothing);
      expect(find.text('Next'), findsNothing);
      expect(find.text('Get Started'), findsOneWidget);

      // 4. Slide right -> back to Slide 2
      await tester.fling(find.byType(PageView), const Offset(400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Step 2 of 3'), findsOneWidget);
      expect(find.text('Get Started'), findsNothing);

      // 5. Slide right -> back to Slide 1
      await tester.fling(find.byType(PageView), const Offset(400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('Step 1 of 3'), findsOneWidget);
    });

    testWidgets('Tapping Skip navigates directly to Login/Register destination',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen Target'), findsOneWidget);
    });

    testWidgets('Tapping Get Started on Slide 3 navigates to Login/Register destination',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Swipe to Slide 3
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen Target'), findsOneWidget);
    });
  });
}
