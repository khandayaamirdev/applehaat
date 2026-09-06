import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';

/// Service category model matching the Stitch design for Screen 7
class ServiceCategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const ServiceCategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

/// ServiceProviderSubcategoryScreen implements Screen 7 strictly reproducing the Stitch design.
/// Allows service providers to select one or more services they provide.
class ServiceProviderSubcategoryScreen extends StatefulWidget {
  const ServiceProviderSubcategoryScreen({super.key});

  @override
  State<ServiceProviderSubcategoryScreen> createState() =>
      _ServiceProviderSubcategoryScreenState();
}

class _ServiceProviderSubcategoryScreenState
    extends State<ServiceProviderSubcategoryScreen> {
  final Set<String> _selectedServiceIds = {};

  static const List<ServiceCategoryItem> _services = [
    ServiceCategoryItem(
      id: 'grading_line',
      title: 'Grading Line',
      subtitle: 'Apple grading',
      icon: Icons.tune_rounded,
    ),
    ServiceCategoryItem(
      id: 'cold_storage',
      title: 'Cold Storage',
      subtitle: 'Apple storage',
      icon: Icons.ac_unit_rounded,
    ),
    ServiceCategoryItem(
      id: 'transportation',
      title: 'Transportation',
      subtitle: 'Apple transport',
      icon: Icons.local_shipping_outlined,
    ),
    ServiceCategoryItem(
      id: 'pruner',
      title: 'Pruner',
      subtitle: 'Orchard pruning',
      icon: Icons.content_cut_rounded,
    ),
    ServiceCategoryItem(
      id: 'packaging',
      title: 'Packaging',
      subtitle: 'Apple packing',
      icon: Icons.inventory_2_outlined,
    ),
    ServiceCategoryItem(
      id: 'orchard_management',
      title: 'Orchard Management',
      subtitle: 'Orchard management',
      icon: Icons.assignment_outlined,
    ),
  ];

  void _toggleService(String id) {
    setState(() {
      if (_selectedServiceIds.contains(id)) {
        _selectedServiceIds.remove(id);
      } else {
        _selectedServiceIds.add(id);
      }
    });
  }

  void _onContinuePressed() {
    if (_selectedServiceIds.isEmpty) return;

    // Navigate to Screen 11 (Service Provider Dashboard) passing selected services in memory
    context.pushNamed(
      RouteNames.serviceDashboard,
      extra: {
        'selectedServices': _selectedServiceIds.toList(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = _selectedServiceIds.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              physics: const ClampingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 420.0,
                    minHeight: constraints.maxHeight - 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Back Navigation
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: AppColors.stone800,
                            ),
                            tooltip: 'Back',
                            onPressed: () => Navigator.of(context).maybePop(),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                          const SizedBox(height: 12),

                          // Screen Heading
                          const Text(
                            'What services do you provide?',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Subtitle
                          const Text(
                            'You can select one or more categories below',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Service List Cards
                          Column(
                            children: _services.map((service) {
                              final isSelected =
                                  _selectedServiceIds.contains(service.id);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildServiceCard(service, isSelected),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Bottom Sticky Action Footer
                      Column(
                        children: [
                          _buildContinueButton(hasSelection),
                          const SizedBox(height: 10),
                          const Text(
                            'You can easily update your services later in your profile.',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
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

  /// Interactive Service Selection Card matching Stitch design
  Widget _buildServiceCard(ServiceCategoryItem service, bool isSelected) {
    const brandRed = Color(0xFFD6222E);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? brandRed : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: brandRed.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleService(service.id),
          borderRadius: BorderRadius.circular(16),
          splashColor: brandRed.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Icon Box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? brandRed : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: brandRed.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    service.icon,
                    size: 24,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(width: 14),

                // Service Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF1E293B),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkbox Circle Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? brandRed : Colors.white,
                    border: Border.all(
                      color: isSelected ? brandRed : const Color(0xFFCBD5E1),
                      width: 2.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: brandRed.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
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

  /// Primary Continue CTA Button
  Widget _buildContinueButton(bool isEnabled) {
    const brandRed = Color(0xFFD6222E);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: brandRed.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: isEnabled ? brandRed : const Color(0xFFE2E8F0),
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
