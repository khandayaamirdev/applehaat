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
import 'package:mobile/features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import 'package:mobile/features/dashboard/presentation/screens/feature_placeholder_screen.dart';
import 'package:mobile/features/dashboard/presentation/screens/grower_dashboard_screen.dart';
import 'package:mobile/features/dashboard/presentation/screens/service_provider_dashboard_screen.dart';
import 'package:mobile/features/dashboard/presentation/screens/supplier_dashboard_screen.dart';
import 'package:mobile/features/onboarding/presentation/screens/onboarding_screen.dart';
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

    // Verify arrival on OnboardingScreen and then tap Skip to reach LoginScreen
    expect(find.byType(OnboardingScreen), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Verify OnboardingScreen replaced by LoginScreen
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
    expect(find.text('Fill Registration Details'), findsOneWidget);

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

    // 12. Verify arrival on Screen 10 (SupplierDashboardScreen)
    expect(find.byType(SupplierDashboardScreen), findsOneWidget);

    // Header & Branding assertions
    expect(find.text('AppleHaat'), findsOneWidget);
    expect(find.text('Supplier'), findsOneWidget);
    expect(find.text('Kashmir Marketplace'), findsOneWidget);
    expect(find.text('Hello, Ghulam Rasool Mir'), findsOneWidget);
    expect(find.text('Welcome to AppleHaat'), findsOneWidget);
    expect(find.text('GR'), findsOneWidget);

    // Primary Action Card assertions
    expect(find.text('+ Add Listing'), findsOneWidget);
    expect(find.text('List Your Product'), findsOneWidget);

    // My Listings section assertions
    expect(find.text('My Listings'), findsOneWidget);
    expect(find.text('2 Active'), findsOneWidget);
    expect(find.text('Orchard Supplies'), findsOneWidget);

    // Listing 1: Apple Crates
    expect(find.text('Apple Crates'), findsOneWidget);
    expect(find.text('Packaging'), findsOneWidget);
    expect(find.text('500 Crates'), findsOneWidget);
    expect(find.text('₹120'), findsOneWidget);
    expect(find.text(' / Crate'), findsOneWidget);
    expect(find.text('★ Sponsored'), findsOneWidget);
    expect(find.text('Published'), findsNWidgets(2)); // Both listings are published
    expect(find.text('Make Private'), findsOneWidget);

    // Listing 2: Apple Plants
    expect(find.text('Apple Plants'), findsOneWidget);
    expect(find.text('Nursery / Plants'), findsOneWidget);
    expect(find.text('M9 & Gala Rootstocks'), findsOneWidget);
    expect(find.text('Price on enquiry'), findsOneWidget);
    expect(find.text('Sponsor'), findsOneWidget);

    // Actions on listings: View and Edit
    expect(find.text('View'), findsNWidgets(2));
    expect(find.text('Edit'), findsNWidgets(2));

    // Sponsored Visibility Info Card assertions
    expect(find.text('Boost Inquiries with Sponsored Listings'), findsOneWidget);
    expect(
      find.text(
        'Sponsored products appear at the top of search results for apple growers & buyers across Kashmir.',
      ),
      findsOneWidget,
    );

    // Direct Chat Enquiries Card assertions
    expect(find.text('Direct Chat Enquiries'), findsOneWidget);
    expect(find.text('Chat with orchard growers and buyers'), findsOneWidget);
    expect(find.text('Open Chat'), findsOneWidget);

    // Bottom Navigation Bar assertions
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget); // Bottom nav tab

    // 13. Interactivity: Test + Add Listing Navigation
    final addListingButton = find.text('+ Add Listing');
    await tester.ensureVisible(addListingButton);
    await tester.tap(addListingButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, '+ Add Listing'), findsOneWidget);

    // Return to Supplier Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(SupplierDashboardScreen), findsOneWidget);

    // 14. Interactivity: Test Open Chat Navigation
    final openChatButton = find.text('Open Chat');
    await tester.ensureVisible(openChatButton);
    await tester.tap(openChatButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Chat'), findsOneWidget);

    // Return to Supplier Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(SupplierDashboardScreen), findsOneWidget);

    // 15. Interactivity: Test Edit Listing Navigation
    final editButtons = find.text('Edit');
    await tester.ensureVisible(editButtons.first);
    await tester.tap(editButtons.first);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Edit Listing'), findsOneWidget);

    // Return to Supplier Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(SupplierDashboardScreen), findsOneWidget);

    // 16. Interactivity: Test View Listing Details Bottom Sheet
    final viewButtons = find.text('View');
    await tester.ensureVisible(viewButtons.first);
    await tester.tap(viewButtons.first);
    await tester.pumpAndSettle();

    expect(find.text('Close'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // 17. Interactivity: Test Make Private toggle
    final makePrivateButton = find.text('Make Private');
    await tester.ensureVisible(makePrivateButton);
    await tester.tap(makePrivateButton);
    await tester.pumpAndSettle();

    expect(find.text('Make Public'), findsOneWidget);
    expect(find.text('1 Active'), findsOneWidget);

    // Toggle back to Public
    await tester.tap(find.text('Make Public'));
    await tester.pumpAndSettle();

    expect(find.text('Make Private'), findsOneWidget);
    expect(find.text('2 Active'), findsOneWidget);

    // 18. Interactivity: Test Sponsor toggle on Listing 2
    final sponsorButton = find.text('Sponsor');
    await tester.ensureVisible(sponsorButton);
    await tester.tap(sponsorButton);
    await tester.pumpAndSettle();

    expect(find.text('★ Sponsored'), findsNWidgets(2)); // Both now sponsored

    // 19. Interactivity: Test Bottom Nav Profile Navigation
    final profileTab = find.text('Profile');
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);

    // Return to Supplier Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(SupplierDashboardScreen), findsOneWidget);
  });

  testWidgets(
      'Service Provider Flow: Splash -> Login -> OTP -> Registration -> RoleSelection -> ServiceProviderSubcategory -> Screen 11',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppleHaatApp(),
      ),
    );

    // Fast-forward splash and skip onboarding
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
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

    // Tap Continue -> navigates to Screen 11 (ServiceProviderDashboardScreen)
    await tester.ensureVisible(serviceContinue);
    await tester.tap(serviceContinue);
    await tester.pumpAndSettle();

    // Verify arrival on Screen 11 (ServiceProviderDashboardScreen)
    expect(find.byType(ServiceProviderDashboardScreen), findsOneWidget);

    // Header & Branding assertions
    expect(find.text('AppleHaat'), findsOneWidget);
    expect(find.text('Service'), findsOneWidget);
    expect(find.text('Kashmir Marketplace'), findsOneWidget);
    expect(find.text('Hello, Bashir Ahmad Wani'), findsOneWidget);
    expect(find.text('Welcome to AppleHaat'), findsOneWidget);
    expect(find.text('BA'), findsOneWidget);

    // Primary Action Card assertions
    expect(find.text('+ Add Service'), findsOneWidget);
    expect(find.text('List Your Service'), findsOneWidget);

    // My Services section assertions
    expect(find.text('My Services'), findsOneWidget);
    expect(find.text('2 Active'), findsOneWidget);
    expect(find.text('Apple Services'), findsOneWidget);

    // Service Card 1: Apple Grading
    expect(find.text('Apple Grading'), findsOneWidget);
    expect(find.text('Grading & Packing'), findsOneWidget);
    expect(find.text('Srinagar & Sopore'), findsOneWidget);
    expect(
      find.text(
        'Computerized color grading, washing, waxing and export carton packing.',
      ),
      findsOneWidget,
    );
    expect(find.text('★ Sponsored'), findsOneWidget);
    expect(find.text('Published'), findsNWidgets(2)); // Both published initially
    expect(find.text('Make Private'), findsOneWidget);

    // Service Card 2: Apple Transportation
    expect(find.text('Apple Transportation'), findsOneWidget);
    expect(find.text('Logistics / Transit'), findsOneWidget);
    expect(find.text('Kashmir → Delhi / Azadpur'), findsOneWidget);
    expect(
      find.text(
        'GPS-monitored refrigerated & ventilated trucks with direct mandi delivery.',
      ),
      findsOneWidget,
    );
    expect(find.text('★ Sponsor'), findsOneWidget);

    // Actions on services: View and Edit
    expect(find.text('View'), findsNWidgets(2));
    expect(find.text('Edit'), findsNWidgets(2));

    // Sponsored Services Promotion Card assertions
    expect(find.text('Boost Bookings with Sponsored Services'), findsOneWidget);
    expect(
      find.text(
        'Sponsored service listings appear at the top of search results for apple growers & buyers across Kashmir.',
      ),
      findsOneWidget,
    );

    // Direct Service Enquiries Card assertions
    expect(find.text('Direct Service Enquiries'), findsOneWidget);
    expect(find.text('Chat directly with orchard growers and buyers'), findsOneWidget);
    expect(find.text('Open Chat'), findsOneWidget);

    // Bottom Navigation Bar assertions
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);

    // Interactivity: Test + Add Service Navigation
    final addServiceButton = find.text('+ Add Service');
    await tester.tap(addServiceButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, '+ Add Service'), findsOneWidget);

    // Return to Service Provider Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceProviderDashboardScreen), findsOneWidget);

    // Interactivity: Test Open Chat Navigation
    final openChatButton = find.text('Open Chat');
    await tester.ensureVisible(openChatButton);
    await tester.tap(openChatButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Chat'), findsOneWidget);

    // Return to Service Provider Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceProviderDashboardScreen), findsOneWidget);

    // Interactivity: Test Edit Service Navigation
    final editButtons = find.text('Edit');
    await tester.ensureVisible(editButtons.first);
    await tester.tap(editButtons.first);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Edit Listing'), findsOneWidget);

    // Return to Service Provider Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceProviderDashboardScreen), findsOneWidget);

    // Interactivity: Test View Modal BottomSheet on Service 1
    final viewButtons = find.text('View');
    await tester.ensureVisible(viewButtons.first);
    await tester.tap(viewButtons.first);
    await tester.pumpAndSettle();

    expect(find.text('Location: Srinagar & Sopore'), findsOneWidget);
    expect(
      find.text('★ Sponsored Service (Promoted across Kashmir)'),
      findsOneWidget,
    );
    expect(find.text('Close'), findsOneWidget);

    // Close bottomsheet
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Interactivity: Test Make Private / Make Public toggle on Service 1
    final makePrivateButton = find.text('Make Private');
    await tester.ensureVisible(makePrivateButton);
    await tester.tap(makePrivateButton);
    await tester.pumpAndSettle();

    expect(find.text('Make Public'), findsOneWidget);
    expect(find.text('1 Active'), findsOneWidget);

    // Toggle back to Public
    final makePublicButton = find.text('Make Public');
    await tester.ensureVisible(makePublicButton);
    await tester.tap(makePublicButton);
    await tester.pumpAndSettle();

    expect(find.text('Make Private'), findsOneWidget);
    expect(find.text('2 Active'), findsOneWidget);

    // Interactivity: Test Sponsor toggle on Service 2
    final sponsorButton = find.text('★ Sponsor');
    await tester.ensureVisible(sponsorButton);
    await tester.tap(sponsorButton);
    await tester.pumpAndSettle();

    expect(find.text('★ Sponsored'), findsNWidgets(2)); // Both now sponsored

    // Interactivity: Test Bottom Nav Profile Navigation
    final profileTab = find.text('Profile');
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);

    // Return to Service Provider Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceProviderDashboardScreen), findsOneWidget);
  });

  testWidgets(
      'Grower Dashboard Flow: Splash -> Login -> OTP -> Registration -> RoleSelection -> GrowerDashboard -> Feature Placeholders',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppleHaatApp(),
      ),
    );

    // Fast-forward splash and skip onboarding
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
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

  testWidgets(
      'Buyer Dashboard Flow: Splash -> Login -> OTP -> Registration -> RoleSelection -> BuyerDashboard -> Placeholders',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppleHaatApp(),
      ),
    );

    // Fast-forward splash and skip onboarding
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
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

    // Registration (Rajesh Sharma)
    final regTextFields = find.descendant(
      of: find.byType(RegistrationScreen),
      matching: find.byType(TextField),
    );
    await tester.enterText(regTextFields.at(0), 'Rajesh Sharma');
    await tester.enterText(regTextFields.at(1), 'Sopore, Baramulla');

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

    // Role Selection: Select Buyer
    expect(find.byType(RoleSelectionScreen), findsOneWidget);
    final buyerCard = find.text('Buyer');
    await tester.ensureVisible(buyerCard);
    await tester.tap(buyerCard);
    await tester.pumpAndSettle();

    final roleContinue = find.descendant(
      of: find.byType(RoleSelectionScreen),
      matching: find.text('Continue'),
    );
    await tester.ensureVisible(roleContinue);
    await tester.tap(roleContinue);
    await tester.pumpAndSettle();

    // Verify arrival on Screen 9 (BuyerDashboardScreen)
    expect(find.byType(BuyerDashboardScreen), findsOneWidget);

    // 1. Header assertions
    expect(find.text('Buyer'), findsOneWidget);
    expect(find.text('Kashmir Marketplace'), findsOneWidget);
    expect(find.text('Hello, Rajesh Sharma'), findsOneWidget);
    expect(find.text('Welcome to AppleHaat'), findsOneWidget);
    expect(find.text('RS'), findsOneWidget);

    // 2. Search Bar assertion
    expect(find.text('Search growers or apple varieties...'), findsOneWidget);

    // 3. Find Growers Hero Card
    expect(find.text('Direct Farm Access'), findsOneWidget);
    expect(find.text('Find Growers'), findsOneWidget);
    expect(find.text('Connect directly with apple orchard owners across Kashmir'), findsOneWidget);
    expect(find.text('Explore Growers'), findsOneWidget);

    // 4. Primary Action: + Add Buying Request
    expect(find.text('+ Add Buying Request'), findsOneWidget);
    expect(find.text('Tell Growers What You Want'), findsOneWidget);

    // 5. My Buying Requests section assertions
    expect(find.text('My Buying Requests'), findsOneWidget);
    expect(find.text('1 Active'), findsOneWidget);
    expect(find.text('Red Delicious'), findsOneWidget);
    expect(find.text('1,000 Crates'), findsOneWidget);
    expect(find.text('Published'), findsOneWidget);
    expect(find.text('Offer Price'), findsOneWidget);
    expect(find.text('₹1,900'), findsOneWidget);
    expect(find.text(' / Crate'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    // 6. Featured Sponsored Grower assertions
    expect(find.text('SPONSORED'), findsOneWidget);
    expect(find.text('Verified Orchard'), findsOneWidget);
    expect(find.text('Parihaspora Apple Estate'), findsOneWidget);
    expect(find.text('Baramulla, Kashmir'), findsOneWidget);
    expect(find.text('Fresh Delicious & Kulu American'), findsOneWidget);
    expect(find.text('2,500 Crates Available'), findsOneWidget);
    expect(find.text('Chat'), findsNWidgets(2)); // Card chat button + bottom nav chat tab

    // 7. Marketplace Services assertions
    expect(find.text('Marketplace Services'), findsOneWidget);
    expect(find.text('Suppliers'), findsOneWidget);
    expect(find.text('Apple Boxes, Fertilizers & Nursery'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Grading Line, Cold Storage & Transport'), findsOneWidget);

    // 8. Bottom Navigation assertions
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Test Navigation: Add Buying Request
    final addRequestButton = find.text('+ Add Buying Request');
    await tester.ensureVisible(addRequestButton);
    await tester.tap(addRequestButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Add Buying Request'), findsOneWidget);

    // Back to Buyer Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerDashboardScreen), findsOneWidget);

    // Test Navigation: Explore Growers
    final exploreGrowersButton = find.text('Explore Growers');
    await tester.ensureVisible(exploreGrowersButton);
    await tester.tap(exploreGrowersButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Find Growers'), findsOneWidget);

    // Back to Buyer Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerDashboardScreen), findsOneWidget);

    // Test Navigation: Edit Request
    final editButton = find.text('Edit');
    await tester.ensureVisible(editButton);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Edit Buying Request'), findsOneWidget);

    // Back to Buyer Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerDashboardScreen), findsOneWidget);

    // Test Navigation: Suppliers
    final suppliersButton = find.text('Suppliers');
    await tester.ensureVisible(suppliersButton);
    await tester.tap(suppliersButton);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Suppliers'), findsOneWidget);

    // Back to Buyer Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerDashboardScreen), findsOneWidget);

    // Test Navigation: Profile Tab in bottom nav
    final profileTab = find.text('Profile');
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    expect(find.byType(FeaturePlaceholderScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);

    // Back to Buyer Dashboard
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerDashboardScreen), findsOneWidget);
  });
}
