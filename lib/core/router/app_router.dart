import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/auth/presentation/screens/role_destination_placeholder_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/service_provider_subcategory_screen.dart';
import '../../features/auth/presentation/screens/supplier_subcategory_screen.dart';
import '../../features/dashboard/presentation/screens/feature_placeholder_screen.dart';
import '../../features/dashboard/presentation/screens/grower_dashboard_screen.dart';
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
          final name = data?['name'] as String?;
          return GrowerDashboardScreen(growerName: name);
        },
      ),
      GoRoute(
        path: RouteNames.buyerDashboardPath,
        name: RouteNames.buyerDashboard,
        builder: (context, state) => const RoleDestinationPlaceholderScreen(
          title: 'Buyer Dashboard',
          screenNumber: '9',
          roleName: 'Buyer',
        ),
      ),
      GoRoute(
        path: RouteNames.supplierSubcategoryPath,
        name: RouteNames.supplierSubcategory,
        builder: (context, state) => const SupplierSubcategoryScreen(),
      ),
      GoRoute(
        path: RouteNames.supplierDashboardPath,
        name: RouteNames.supplierDashboard,
        builder: (context, state) => const RoleDestinationPlaceholderScreen(
          title: 'Supplier Dashboard',
          screenNumber: '10',
          roleName: 'Supplier',
        ),
      ),
      GoRoute(
        path: RouteNames.serviceSubcategoryPath,
        name: RouteNames.serviceSubcategory,
        builder: (context, state) => const ServiceProviderSubcategoryScreen(),
      ),
      GoRoute(
        path: RouteNames.serviceDashboardPath,
        name: RouteNames.serviceDashboard,
        builder: (context, state) => const RoleDestinationPlaceholderScreen(
          title: 'Service Provider Dashboard',
          screenNumber: '11',
          roleName: 'Service Provider',
        ),
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
