import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/applehaat_logo.dart';

/// Available business roles for AppleHaat users
enum UserRole {
  grower,
  buyer,
  supplier,
  serviceProvider;

  String get displayName {
    switch (this) {
      case UserRole.grower:
        return 'Grower';
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.supplier:
        return 'Supplier';
      case UserRole.serviceProvider:
        return 'Service Provider';
    }
  }

  String get subtitle {
    switch (this) {
      case UserRole.grower:
        return 'I have an orchard';
      case UserRole.buyer:
        return 'I want to buy apples';
      case UserRole.supplier:
        return 'I sell products';
      case UserRole.serviceProvider:
        return 'I provide services';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.grower:
        return Icons.park_rounded;
      case UserRole.buyer:
        return Icons.shopping_bag_outlined;
      case UserRole.supplier:
        return Icons.inventory_2_outlined;
      case UserRole.serviceProvider:
        return Icons.handyman_outlined;
    }
  }
}

/// RoleSelectionScreen implements Screen 5 strictly matching the Stitch design.
class RoleSelectionScreen extends StatefulWidget {
  final Map<String, dynamic>? registrationData;

  const RoleSelectionScreen({
    super.key,
    this.registrationData,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  void _onRoleSelected(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _onContinuePressed() {
    if (_selectedRole == null) return;

    switch (_selectedRole!) {
      case UserRole.grower:
        context.pushNamed(
          RouteNames.growerDashboard,
          extra: widget.registrationData,
        );
        break;
      case UserRole.buyer:
        context.pushNamed(
          RouteNames.buyerDashboard,
          extra: widget.registrationData,
        );
        break;
      case UserRole.supplier:
        context.pushNamed(
          RouteNames.supplierSubcategory,
          extra: widget.registrationData,
        );
        break;
      case UserRole.serviceProvider:
        context.pushNamed(
          RouteNames.serviceSubcategory,
          extra: widget.registrationData,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              physics: const ClampingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 430.0,
                    minHeight: constraints.maxHeight - 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Subtle top navigation row for pop navigation
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: AppColors.stone800,
                          ),
                          tooltip: 'Back',
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ),

                      // BEGIN: BrandHeader
                      _buildHeader(),

                      const SizedBox(height: 20),

                      // BEGIN: Role Cards Section (4 Roles)
                      _buildRoleCards(),

                      const SizedBox(height: 20),

                      // BEGIN: Bottom Action Area
                      _buildContinueButton(),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Top Branding & Header Area matching Stitch Screen 5
  Widget _buildHeader() {
    return Column(
      children: [
        // AppleHaat Logo Mark (80x80 dp)
        const AppleHaatLogo(
          size: 80.0,
        ),
        const SizedBox(height: 8),

        // Brand Wordmark
        Text.rich(
          TextSpan(
            text: 'Apple',
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Haat',
                style: TextStyle(color: Color(0xFFDC2626)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Marketplace Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF8EE),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFDCFCE7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Flexible(
                child: Text(
                  "Kashmir's Biggest Apple Marketplace",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Screen Title
        const Text(
          'What do you do?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),

        // Subtitle
        const Text(
          'Select your role to continue',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 4 Role Selection Cards list
  Widget _buildRoleCards() {
    return Column(
      children: [
        _buildRoleCard(UserRole.grower),
        const SizedBox(height: 12),
        _buildRoleCard(UserRole.buyer),
        const SizedBox(height: 12),
        _buildRoleCard(UserRole.supplier),
        const SizedBox(height: 12),
        _buildRoleCard(UserRole.serviceProvider),
      ],
    );
  }

  /// Individual Role Card matching Stitch visual styles and interaction states
  Widget _buildRoleCard(UserRole role) {
    final isSelected = _selectedRole == role;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFEF2F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0),
          width: 2.0,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: const Color(0xFFDC2626).withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onRoleSelected(role),
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFFDC2626).withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Icon Box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    role.icon,
                    size: 24,
                    color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(width: 14),

                // Title and Subtitle Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Custom Radio / Check Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFFDC2626) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFDC2626) : const Color(0xFFCBD5E1),
                      width: 2.0,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Continue Action Button
  Widget _buildContinueButton() {
    final isEnabled = _selectedRole != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: isEnabled ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isEnabled ? _onContinuePressed : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isEnabled ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: isEnabled ? Colors.white : const Color(0xFF94A3B8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
