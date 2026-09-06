import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/service_provider_subcategory_screen.dart';
import '../../features/auth/presentation/screens/supplier_subcategory_screen.dart';
import '../../features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/feature_placeholder_screen.dart';
import '../../features/dashboard/presentation/screens/grower_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/service_provider_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/supplier_dashboard_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_names.dart';

/// Global navigator key
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// AppRouter provider configured for AppleHaat screen navigation.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splashPath,
    routes: [
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.otpPath,
        name: RouteNames.otp,
        builder: (context, state) {
          final mobile = state.extra as String?;
          return OtpScreen(mobileNumber: mobile);
        },
      ),
      GoRoute(
        path: RouteNames.registrationPath,
        name: RouteNames.registration,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: RouteNames.roleSelectionPath,
        name: RouteNames.roleSelection,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return RoleSelectionScreen(registrationData: data);
        },
      ),
      GoRoute(
        path: RouteNames.growerDashboardPath,
        name: RouteNames.growerDashboard,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final name = (data?['fullName'] ?? data?['name']) as String?;
          return GrowerDashboardScreen(growerName: name);
        },
      ),
      GoRoute(
        path: RouteNames.buyerDashboardPath,
        name: RouteNames.buyerDashboard,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final name = (data?['fullName'] ?? data?['name']) as String?;
          return BuyerDashboardScreen(buyerName: name);
        },
      ),
      GoRoute(
        path: RouteNames.supplierSubcategoryPath,
        name: RouteNames.supplierSubcategory,
        builder: (context, state) => SupplierSubcategoryScreen(
          registrationData: state.extra,
        ),
      ),
      GoRoute(
        path: RouteNames.supplierDashboardPath,
        name: RouteNames.supplierDashboard,
        builder: (context, state) {
          final extraMap = state.extra as Map<String, dynamic>?;
          final regData = extraMap?['registrationData'] as Map<String, dynamic>?;
          final name = (regData?['fullName'] ?? regData?['name']) as String?;
          final categories = (extraMap?['selectedCategories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList();
          return SupplierDashboardScreen(
            supplierName: name,
            selectedCategories: categories,
          );
        },
      ),
      GoRoute(
        path: RouteNames.serviceSubcategoryPath,
        name: RouteNames.serviceSubcategory,
        builder: (context, state) => ServiceProviderSubcategoryScreen(
          registrationData: state.extra,
        ),
      ),
      GoRoute(
        path: RouteNames.serviceDashboardPath,
        name: RouteNames.serviceDashboard,
        builder: (context, state) {
          final extraMap = state.extra as Map<String, dynamic>?;
          final regData = extraMap?['registrationData'] as Map<String, dynamic>?;
          final name = (regData?['fullName'] ?? regData?['name']) as String?;
          final services = (extraMap?['selectedServices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList();
          return ServiceProviderDashboardScreen(
            providerName: name,
            selectedServices: services,
          );
        },
      ),
      GoRoute(
        path: RouteNames.addListingPath,
        name: RouteNames.addListing,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Add Apple Listing',
          icon: Icons.add_circle_outline_rounded,
        ),
      ),
      GoRoute(
        path: RouteNames.growerBuyersPath,
        name: RouteNames.growerBuyers,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Buyers',
          icon: Icons.shopping_bag_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.growerSuppliersPath,
        name: RouteNames.growerSuppliers,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Suppliers',
          icon: Icons.inventory_2_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.growerServicesPath,
        name: RouteNames.growerServices,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Services',
          icon: Icons.handyman_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.chatPath,
        name: RouteNames.chat,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Chat',
          icon: Icons.chat_bubble_outline_rounded,
        ),
      ),
      GoRoute(
        path: RouteNames.profilePath,
        name: RouteNames.profile,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Profile',
          icon: Icons.person_outline_rounded,
        ),
      ),
      GoRoute(
        path: RouteNames.myListingsPath,
        name: RouteNames.myListings,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'My Listings',
          icon: Icons.list_alt_rounded,
        ),
      ),
      GoRoute(
        path: RouteNames.editListingPath,
        name: RouteNames.editListing,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Edit Listing',
          icon: Icons.edit_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.notificationsPath,
        name: RouteNames.notifications,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Notifications',
          icon: Icons.notifications_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.addBuyingRequestPath,
        name: RouteNames.addBuyingRequest,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Add Buying Request',
          icon: Icons.add_circle_outline_rounded,
        ),
      ),
      GoRoute(
        path: RouteNames.findGrowersPath,
        name: RouteNames.findGrowers,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Find Growers',
          icon: Icons.park_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.buyerSuppliersPath,
        name: RouteNames.buyerSuppliers,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Suppliers',
          icon: Icons.inventory_2_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.buyerServicesPath,
        name: RouteNames.buyerServices,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Services',
          icon: Icons.local_shipping_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.editBuyingRequestPath,
        name: RouteNames.editBuyingRequest,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: 'Edit Buying Request',
          icon: Icons.edit_outlined,
        ),
      ),
      GoRoute(
        path: RouteNames.supplierAddListingPath,
        name: RouteNames.supplierAddListing,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: '+ Add Listing',
          icon: Icons.add_circle_outline_rounded,
        ),
      ),
      GoRoute(
        path: RouteNames.serviceAddServicePath,
        name: RouteNames.serviceAddService,
        builder: (context, state) => const FeaturePlaceholderScreen(
          title: '+ Add Service',
          icon: Icons.add_circle_outline_rounded,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
