import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/applehaat_logo.dart';

/// Local data model representing a Service Provider's Service Listing
class ServiceProviderListingItem {
  final String id;
  final String title;
  final String subcategory;
  final String location;
  final String description;
  bool isPublished;
  bool isSponsored;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color iconBorderColor;

  ServiceProviderListingItem({
    required this.id,
    required this.title,
    required this.subcategory,
    required this.location,
    required this.description,
    this.isPublished = true,
    this.isSponsored = false,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.iconBorderColor,
  });
}

/// ServiceProviderDashboardScreen implements Screen 11 strictly reproducing the Stitch design.
/// It serves as the primary dashboard for Service Provider users in AppleHaat.
class ServiceProviderDashboardScreen extends StatefulWidget {
  final String? providerName;
  final List<String>? selectedServices;

  const ServiceProviderDashboardScreen({
    super.key,
    this.providerName,
    this.selectedServices,
  });

  @override
  State<ServiceProviderDashboardScreen> createState() =>
      _ServiceProviderDashboardScreenState();
}

class _ServiceProviderDashboardScreenState
    extends State<ServiceProviderDashboardScreen> {
  // Mock service items matching the Stitch design
  late List<ServiceProviderListingItem> _services;

  @override
  void initState() {
    super.initState();
    _services = [
      ServiceProviderListingItem(
        id: 'srv_1',
        title: 'Apple Grading',
        subcategory: 'Grading & Packing',
        location: 'Srinagar & Sopore',
        description:
            'Computerized color grading, washing, waxing and export carton packing.',
        isPublished: true,
        isSponsored: true,
        icon: Icons.tune_rounded,
        iconColor: const Color(0xFFD97706), // amber-600
        iconBgColor: const Color(0xFFFFFBEB), // amber-50
        iconBorderColor: const Color(0xFFFDE68A), // amber-200
      ),
      ServiceProviderListingItem(
        id: 'srv_2',
        title: 'Apple Transportation',
        subcategory: 'Logistics / Transit',
        location: 'Kashmir → Delhi / Azadpur',
        description:
            'GPS-monitored refrigerated & ventilated trucks with direct mandi delivery.',
        isPublished: true,
        isSponsored: false,
        icon: Icons.local_shipping_outlined,
        iconColor: const Color(0xFF2563EB), // blue-600
        iconBgColor: const Color(0xFFEFF6FF), // blue-50
        iconBorderColor: const Color(0xFFBFDBFE), // blue-200
      ),
    ];
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'FB';
  }

  void _togglePublish(ServiceProviderListingItem item) {
    setState(() {
      item.isPublished = !item.isPublished;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.isPublished
              ? '${item.title} is now Public and Published'
              : '${item.title} is now Private (Hidden from growers & buyers)',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleSponsor(ServiceProviderListingItem item) {
    setState(() {
      item.isSponsored = !item.isSponsored;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.isSponsored
              ? '${item.title} is now Sponsored at the top of Kashmir search results!'
              : 'Sponsorship removed for ${item.title}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDeleteService(ServiceProviderListingItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Service',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Text(
          'Are you sure you want to delete "${item.title}"? This cannot be undone.',
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _services.removeWhere((s) => s.id == item.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted "${item.title}"')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewServiceDetails(ServiceProviderListingItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item.iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: item.iconBorderColor),
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subcategory,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.isPublished
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: item.isPublished
                            ? const Color(0xFFA7F3D0)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Text(
                      item.isPublished ? 'Published' : 'Private',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.isPublished
                            ? const Color(0xFF047857)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Location: ${item.location}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              if (item.isSponsored) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 14, color: Color(0xFFD97706)),
                      SizedBox(width: 4),
                      Text(
                        '★ Sponsored Service (Promoted across Kashmir)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        foregroundColor: const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _confirmDeleteService(item);
                      },
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.providerName?.isNotEmpty == true
        ? widget.providerName!
        : 'Fayaz Bhat';
    final initials = _getInitials(displayName);
    final activeCount = _services.where((s) => s.isPublished).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      bottomNavigationBar: _buildBottomNavigation(),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER & BRANDING
            _buildTopHeader(initials),

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                physics: const ClampingScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Personalized Greeting
                        _buildGreeting(displayName),
                        const SizedBox(height: 18),

                        // 2. PRIMARY ACTION: "+ Add Service"
                        _buildAddServiceAction(),
                        const SizedBox(height: 20),

                        // 3 & 4. MY SERVICES SECTION
                        _buildMyServicesSection(activeCount),
                        const SizedBox(height: 16),

                        // 5. SPONSORED SERVICES PROMOTION CARD
                        _buildSponsoredInfoCard(),
                        const SizedBox(height: 16),

                        // 6. DIRECT CHAT ENQUIRIES SHORTCUT CARD
                        _buildChatEnquiriesCard(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Header & Branding
  Widget _buildTopHeader(String initials) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Logo, Brand Wordmark & "Service" Pill Badge
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AppleHaat Logo Badge (rounded red-50 container)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2), // red-50
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFEE2E2).withValues(alpha: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6.0),
                child: const AppleHaatLogo(size: 26),
              ),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'AppleHaat',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF), // blue-50
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: const Color(0xFFDBEAFE), // blue-100
                          ),
                        ),
                        child: const Text(
                          'Service',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D4ED8), // blue-700
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Kashmir Marketplace',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right Action Icons: Notifications & Profile
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notification Button with Red Dot
              IconButton(
                onPressed: () => context.pushNamed(RouteNames.notifications),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        size: 20,
                        color: Color(0xFF475569),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Profile Button with User Initials
              IconButton(
                onPressed: () => context.pushNamed(RouteNames.profile),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF1F5F9),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Personalized Greeting Section
  Widget _buildGreeting(String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $displayName',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Welcome to AppleHaat',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// 2. Primary Action: "+ Add Service"
  Widget _buildAddServiceAction() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFDC2626), // red-600
            Color(0xFFE11D48), // rose-600
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed(RouteNames.serviceAddService),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
            child: Row(
              children: [
                // Plus Icon in frosted square container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Subtitle
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+ Add Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'List Your Service',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFEE2E2),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Arrow in circle container
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 3 & 4. My Services Section
  Widget _buildMyServicesSection(int activeCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'My Services',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$activeCount Active',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Apple Services',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Services List or Empty State
        if (_services.isEmpty)
          _buildEmptyServicesState()
        else
          Column(
            children: _services.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildServiceCard(item),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// Individual Service Card
  Widget _buildServiceCard(ServiceProviderListingItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Service Icon, Title, Subcategory, Location, Badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual Icon Box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: item.iconBorderColor),
                ),
                alignment: Alignment.center,
                child: Icon(
                  item.icon,
                  size: 24,
                  color: item.iconColor,
                ),
              ),
              const SizedBox(width: 12),

              // Title, Subcategory & Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Subcategory Pill • Location Pin
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      runSpacing: 3,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            item.subcategory,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        const Text(
                          '•',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                item.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Status & Sponsored Badges Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Published / Private Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: item.isPublished
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: item.isPublished
                            ? const Color(0xFFA7F3D0)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: item.isPublished
                                ? const Color(0xFF10B981)
                                : const Color(0xFF94A3B8),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.isPublished ? 'Published' : 'Private',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.isPublished
                                ? const Color(0xFF047857)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sponsored Tag
                  if (item.isSponsored) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB), // amber-50
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFFDE68A), // amber-200
                        ),
                      ),
                      child: const Text(
                        '★ Sponsored',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description (line-clamp-1)
          Text(
            item.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          // Bottom Action Toolbar (View, Make Private/Public, Sponsor, Edit)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Group: View & Make Private/Public (or Sponsor & View)
              Wrap(
                spacing: 12,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // If not sponsored, offer the Sponsor button here (Card 2 in Stitch)
                  if (!item.isSponsored)
                    InkWell(
                      onTap: () => _toggleSponsor(item),
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '★ Sponsor',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ),

                  // View Action
                  InkWell(
                    onTap: () => _viewServiceDetails(item),
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'View',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // If sponsored, show Make Private/Public toggle here (Card 1 in Stitch)
                  if (item.isSponsored)
                    InkWell(
                      onTap: () => _togglePublish(item),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.isPublished
                                  ? Icons.lock_outline_rounded
                                  : Icons.lock_open_rounded,
                              size: 14,
                              color: const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.isPublished ? 'Make Private' : 'Make Public',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Right Group: Edit Button
              InkWell(
                onTap: () => context.pushNamed(RouteNames.editListing),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 13,
                        color: Color(0xFF475569),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Empty State when no services are listed
  Widget _buildEmptyServicesState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_repair_service_outlined,
              size: 28,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No Services Listed Yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add your first service listing to start receiving booking inquiries from growers and buyers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => context.pushNamed(RouteNames.serviceAddService),
            child: const Text(
              '+ Add Your First Service',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Sponsored Services Promotion (Subtle, Non-dominant)
  Widget _buildSponsoredInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFDE68A).withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lightning bolt icon container
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.bolt_rounded,
              size: 18,
              color: Color(0xFFB45309),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Explanation Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Boost Bookings with Sponsored Services',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF78350F), // amber-900
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Sponsored service listings appear at the top of search results for apple growers & buyers across Kashmir.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF92400E), // amber-800
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 6. Direct Service Enquiries Shortcut Card
  Widget _buildChatEnquiriesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Left: Red Icon Box with unread notification dot
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 22,
                  color: Color(0xFFDC2626),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Direct Service Enquiries',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Chat directly with orchard growers and buyers',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Open Chat Button
          Material(
            color: const Color(0xFFDC2626),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => context.pushNamed(RouteNames.chat),
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Text(
                  'Open Chat',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 7. Fixed Universal Bottom Navigation Bar
  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: const Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home (Active)
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_rounded,
                    color: Color(0xFFDC2626),
                    size: 22,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat (with unread dot)
          InkWell(
            onTap: () => context.pushNamed(RouteNames.chat),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Color(0xFF94A3B8),
                        size: 22,
                      ),
                      Positioned(
                        top: -1,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile
          InkWell(
            onTap: () => context.pushNamed(RouteNames.profile),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF94A3B8),
                    size: 22,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
