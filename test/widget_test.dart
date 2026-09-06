import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/otp_screen.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/auth/presentation/screens/role_destination_placeholder_screen.dart';
import 'package:mobile/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:mobile/features/auth/presentation/screens/service_provider_subcategory_screen.dart';
import 'package:mobile/features/auth/presentation/screens/supplier_subcategory_screen.dart';
import 'package:mobile/features/dashboard/presentation/screens/feature_placeholder_screen.dart';
import 'package:mobile/features/dashboard/presentation/screens/grower_dashboard_screen.dart';
import 'package:mobile/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('Full flow: Splash -> Login -> OTP -> Registration -> RoleSelection -> SupplierSubcategory -> Screen 10',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppleHaatApp(),
      ),
    );

    // 1. Initial Splash Screen assertion
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text("Kashmir's Biggest Apple Marketplace"), findsOneWidget);

    // 2. Advance time past the 2.5s splash navigation timer
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Verify SplashScreen replaced by LoginScreen
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);

    // 3. Enter valid 10-digit mobile number and continue
    final loginPhoneField = find.byType(TextField);
    final continueButton = find.text('Continue');
    await tester.enterText(loginPhoneField, '9876543210');
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // 4. Verify arrival on Screen 3 (OtpScreen)
    expect(find.byType(OtpScreen), findsOneWidget);
    expect(find.text('Verify Your Number'), findsOneWidget);

    // 5. Enter 6-digit OTP across the cells and submit
    final digitFields = find.descendant(
      of: find.byType(OtpScreen),
      matching: find.byType(TextField),
    );
    expect(digitFields, findsNWidgets(6));

    final sampleOtp = ['8', '4', '1', '9', '2', '0'];
    for (int i = 0; i < 6; i++) {
      await tester.enterText(digitFields.at(i), sampleOtp[i]);
      await tester.pump();
    }

    // Tap Verify on OTP screen
    await tester.tap(find.text('Verify'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    // 6. Verify arrival on Screen 4 (RegistrationScreen)
    expect(find.byType(RegistrationScreen), findsOneWidget);
    expect(find.text('Create Your Account'), findsOneWidget);

    // Fill in registration form fields
    final regTextFields = find.descendant(
      of: find.byType(RegistrationScreen),
      matching: find.byType(TextField),
    );
    expect(regTextFields, findsNWidgets(2));

    await tester.enterText(regTextFields.at(0), 'Ghulam Rasool Mir');
    await tester.pump();

    await tester.enterText(regTextFields.at(1), 'Sopore Fruit Mandi, Baramulla');
    await tester.pump();

    // State dropdown selection
    final stateDropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(stateDropdown);
    await tester.tap(stateDropdown);
    await tester.pumpAndSettle();

    final jkOption = find.text('Jammu & Kashmir').last;
    await tester.tap(jkOption);
    await tester.pumpAndSettle();

    // Submit registration form
    final regContinueButton = find.descendant(
      of: find.byType(RegistrationScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(regContinueButton);
    await tester.tap(regContinueButton);
    await tester.pumpAndSettle();

    // 7. Verify arrival on Screen 5 (RoleSelectionScreen)
    expect(find.byType(RoleSelectionScreen), findsOneWidget);
    expect(find.text('What do you do?'), findsOneWidget);

    // Select Supplier role and Continue
    await tester.tap(find.text('Supplier'));
    await tester.pumpAndSettle();

    final roleContinueButton = find.descendant(
      of: find.byType(RoleSelectionScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(roleContinueButton);
    await tester.tap(roleContinueButton);
    await tester.pumpAndSettle();

    // 8. Verify arrival on Screen 6 (SupplierSubcategoryScreen)
    expect(find.byType(SupplierSubcategoryScreen), findsOneWidget);
    expect(find.text('What do you sell?'), findsOneWidget);
    expect(find.text('You can select one or more categories below'), findsOneWidget);

    // Verify all 5 categories from Stitch design
    expect(find.text('Apple Crates / Boxes'), findsOneWidget);
    expect(find.text('Plants / Nursery'), findsOneWidget);
    expect(find.text('Fertilisers'), findsOneWidget);
    expect(find.text('Pesticides'), findsOneWidget);
    expect(find.text('High-Density Orchard Material'), findsOneWidget);

    // 9. Test Continue disabled when no category is selected
    final supplierContinueButton = find.descendant(
      of: find.byType(SupplierSubcategoryScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(supplierContinueButton);
    await tester.tap(supplierContinueButton);
    await tester.pumpAndSettle();

    // Still on SupplierSubcategoryScreen
    expect(find.byType(SupplierSubcategoryScreen), findsOneWidget);
    expect(find.byType(RoleDestinationPlaceholderScreen), findsNothing);

    // 10. Multi-select: tap "Apple Crates / Boxes" and "Pesticides"
    await tester.tap(find.text('Apple Crates / Boxes'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pesticides'));
    await tester.pumpAndSettle();

    // Verify both items show checked icons
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));

    // 11. Tap Continue to navigate to Screen 10 (Supplier Dashboard)
    await tester.ensureVisible(supplierContinueButton);
    await tester.tap(supplierContinueButton);
    await tester.pumpAndSettle();

    // 12. Verify arrival on Screen 10 (Supplier Dashboard Placeholder)
    expect(find.byType(RoleDestinationPlaceholderScreen), findsOneWidget);
    expect(find.text('Screen 10: Supplier Dashboard'), findsOneWidget);
    expect(find.text('Selected Role: Supplier'), findsOneWidget);

    // 13. Back navigation from Screen 10 returns to Screen 6
    final backButton = find.byIcon(Icons.arrow_back_ios_new_rounded);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.byType(RoleDestinationPlaceholderScreen), findsNothing);
    expect(find.byType(SupplierSubcategoryScreen), findsOneWidget);

    // 14. Unselect "Pesticides" to verify multi-select toggle
    await tester.tap(find.text('Pesticides'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_rounded), findsNWidgets(1));
  });

  testWidgets(
      'Service Provider Flow: Splash -> Login -> OTP -> Registration -> RoleSelection -> ServiceProviderSubcategory -> Screen 11',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppleHaatApp(),
      ),
    );

    // Fast-forward splash
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // OTP
    final digitFields = find.descendant(
      of: find.byType(OtpScreen),
      matching: find.byType(TextField),
    );
    for (int i = 0; i < 6; i++) {
      await tester.enterText(digitFields.at(i), '$i');
    }
    await tester.tap(find.text('Verify'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    // Registration
    final regTextFields = find.descendant(
      of: find.byType(RegistrationScreen),
      matching: find.byType(TextField),
    );
    await tester.enterText(regTextFields.at(0), 'Bashir Ahmad Wani');
    await tester.enterText(regTextFields.at(1), 'Shopian, Jammu & Kashmir');

    final stateDropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(stateDropdown);
    await tester.tap(stateDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jammu & Kashmir').last);
    await tester.pumpAndSettle();

    final regContinue = find.descendant(
      of: find.byType(RegistrationScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(regContinue);
    await tester.tap(regContinue);
    await tester.pumpAndSettle();

    // Role Selection: Select Service Provider
    expect(find.byType(RoleSelectionScreen), findsOneWidget);
    final serviceProviderCard = find.text('Service Provider');
    await tester.ensureVisible(serviceProviderCard);
    await tester.tap(serviceProviderCard);
    await tester.pumpAndSettle();

    final roleContinue = find.descendant(
      of: find.byType(RoleSelectionScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(roleContinue);
    await tester.tap(roleContinue);
    await tester.pumpAndSettle();

    // Verify arrival on Screen 7 (ServiceProviderSubcategoryScreen)
    expect(find.byType(ServiceProviderSubcategoryScreen), findsOneWidget);
    expect(find.text('What services do you provide?'), findsOneWidget);
    expect(find.text('You can select one or more categories below'), findsOneWidget);

    // Verify all 6 services from Stitch design
    expect(find.text('Grading Line'), findsOneWidget);
    expect(find.text('Apple grading'), findsOneWidget);
    expect(find.text('Cold Storage'), findsOneWidget);
    expect(find.text('Apple storage'), findsOneWidget);
    expect(find.text('Transportation'), findsOneWidget);
    expect(find.text('Apple transport'), findsOneWidget);
    expect(find.text('Pruner'), findsOneWidget);
    expect(find.text('Orchard pruning'), findsOneWidget);
    expect(find.text('Packaging'), findsOneWidget);
    expect(find.text('Apple packing'), findsOneWidget);
    expect(find.text('Orchard Management'), findsOneWidget);
    expect(find.text('Orchard management'), findsOneWidget);

    // Continue is disabled initially when 0 services selected
    final serviceContinue = find.descendant(
      of: find.byType(ServiceProviderSubcategoryScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(serviceContinue);
    await tester.tap(serviceContinue);
    await tester.pumpAndSettle();

    // Still on Screen 7
    expect(find.byType(ServiceProviderSubcategoryScreen), findsOneWidget);
    expect(find.byType(RoleDestinationPlaceholderScreen), findsNothing);

    // Select "Grading Line" and "Cold Storage"
    final gradingLineCard = find.text('Grading Line');
    await tester.ensureVisible(gradingLineCard);
    await tester.tap(gradingLineCard);
    await tester.pumpAndSettle();

    final coldStorageCard = find.text('Cold Storage');
    await tester.ensureVisible(coldStorageCard);
    await tester.tap(coldStorageCard);
    await tester.pumpAndSettle();

    // Verify 2 checkmarks
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));

    // Also select "Orchard Management"
    final orchardMgmtCard = find.text('Orchard Management');
    await tester.ensureVisible(orchardMgmtCard);
    await tester.tap(orchardMgmtCard);
    await tester.pumpAndSettle();

    // Verify 3 checkmarks
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(3));

    // Tap Continue -> navigates to Screen 11 placeholder
    await tester.ensureVisible(serviceContinue);
    await tester.tap(serviceContinue);
    await tester.pumpAndSettle();

    // Verify arrival on Screen 11
    expect(find.byType(RoleDestinationPlaceholderScreen), findsOneWidget);
    expect(find.text('Screen 11: Service Provider Dashboard'), findsOneWidget);
    expect(find.text('Selected Role: Service Provider'), findsOneWidget);

    // Tap back button from Screen 11 -> returns to Screen 7
    final backBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RoleDestinationPlaceholderScreen), findsNothing);
    expect(find.byType(ServiceProviderSubcategoryScreen), findsOneWidget);

    // Unselect "Cold Storage" to test toggle
    await tester.ensureVisible(coldStorageCard);
    await tester.tap(coldStorageCard);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
  });

  testWidgets(
      'Grower Dashboard Flow: Splash -> Login -> OTP -> Registration -> RoleSelection -> GrowerDashboard -> Feature Placeholders',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppleHaatApp(),
      ),
    );

    // Fast-forward splash
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // OTP
    final digitFields = find.descendant(
      of: find.byType(OtpScreen),
      matching: find.byType(TextField),
    );
    for (int i = 0; i < 6; i++) {
      await tester.enterText(digitFields.at(i), '$i');
    }
    await tester.tap(find.text('Verify'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    // Registration
    final regTextFields = find.descendant(
      of: find.byType(RegistrationScreen),
      matching: find.byType(TextField),
    );
    await tester.enterText(regTextFields.at(0), 'Ghulam Ahmad');
    await tester.enterText(regTextFields.at(1), 'Shopian, Jammu & Kashmir');

    final stateDropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(stateDropdown);
    await tester.tap(stateDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jammu & Kashmir').last);
    await tester.pumpAndSettle();

    final regContinue = find.descendant(
      of: find.byType(RegistrationScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(regContinue);
    await tester.tap(regContinue);
    await tester.pumpAndSettle();

    // Role Selection: Select Grower
    expect(find.byType(RoleSelectionScreen), findsOneWidget);
    final growerCard = find.text('Grower');
    await tester.ensureVisible(growerCard);
    await tester.tap(growerCard);
    await tester.pumpAndSettle();

    final roleContinue = find.descendant(
      of: find.byType(RoleSelectionScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(roleContinue);
    await tester.tap(roleContinue);
    await tester.pumpAndSettle();

    // Verify arrival on Screen 8 (GrowerDashboardScreen)
    expect(find.byType(GrowerDashboardScreen), findsOneWidget);

    // 1. Header assertions
    expect(find.text('Grower'), findsOneWidget);
    expect(find.text('Kashmir Marketplace'), findsOneWidget);
    expect(find.text('Hello, Ghulam Ahmad'), findsOneWidget);
    expect(find.text('Welcome to AppleHaat'), findsOneWidget);

    // 2. Primary Action assertion
    expect(find.text('+ Add Apple Listing'), findsOneWidget);
    expect(find.text('Sell Your Apples'), findsOneWidget);

    // 3. My Listings section assertions
    expect(find.text('My Listings'), findsOneWidget);
    expect(find.text('2 Active'), findsOneWidget);
    expect(find.text('View All'), findsOneWidget);
    expect(find.text('Red Delicious'), findsOneWidget);
    expect(find.text('500 Crates'), findsOneWidget);
    expect(find.text('₹1,800'), findsOneWidget);
    expect(find.text('Delicious'), findsOneWidget);
    expect(find.text('300 Crates'), findsOneWidget);
    expect(find.text('₹1,700'), findsOneWidget);
    expect(find.text('Edit'), findsNWidgets(2));

    // 4. Marketplace Shortcuts assertions
    expect(find.text('Marketplace'), findsOneWidget);
    expect(find.text('Connect Directly'), findsOneWidget);
    expect(find.text('Buyers'), findsOneWidget);
    expect(find.text('Suppliers'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);

    // 5. Bottom Navigation assertions
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Test Navigation to Add Apple Listing placeholder
    final addListingButton = find.text('+ Add Apple Listing');
    await tester.ensureVisible(addListingButton);
    await tester.tap(addListingButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Add Apple Listing'), findsOneWidget);

    // Navigate back to Grower Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(GrowerDashboardScreen), findsOneWidget);

    // Test Navigation to Buyers marketplace shortcut
    final buyersButton = find.text('Buyers');
    await tester.ensureVisible(buyersButton);
    await tester.tap(buyersButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Buyers'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    // Test Navigation to Chat bottom nav tab
    final chatTab = find.text('Chat');
    await tester.tap(chatTab);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Chat'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(GrowerDashboardScreen), findsOneWidget);
  });
}
