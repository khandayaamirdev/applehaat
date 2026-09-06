import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/applehaat_logo.dart';

/// Local data model representing a Supplier's Product Listing
class SupplierListingItem {
  final String id;
  final String title;
  final String subcategory;
  final String quantityText;
  final String priceText;
  final String? priceUnit;
  final bool isPriceOnEnquiry;
  bool isPublished;
  bool isSponsored;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color iconBorderColor;

  SupplierListingItem({
    required this.id,
    required this.title,
    required this.subcategory,
    required this.quantityText,
    required this.priceText,
    this.priceUnit,
    this.isPriceOnEnquiry = false,
    this.isPublished = true,
    this.isSponsored = false,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.iconBorderColor,
  });
}

/// SupplierDashboardScreen implements Screen 10 strictly reproducing the Stitch design.
/// It serves as the primary dashboard for Supplier users in AppleHaat.
class SupplierDashboardScreen extends StatefulWidget {
  final String? supplierName;
  final List<String>? selectedCategories;

  const SupplierDashboardScreen({
    super.key,
    this.supplierName,
    this.selectedCategories,
  });

  @override
  State<SupplierDashboardScreen> createState() => _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState extends State<SupplierDashboardScreen> {
  // Mock listing items matching the Stitch design
  late List<SupplierListingItem> _listings;

  @override
  void initState() {
    super.initState();
    _listings = [
      SupplierListingItem(
        id: 'sup_1',
        title: 'Apple Crates',
        subcategory: 'Packaging',
        quantityText: '500 Crates',
        priceText: '₹120',
        priceUnit: '/ Crate',
        isPriceOnEnquiry: false,
        isPublished: true,
        isSponsored: true,
        icon: Icons.inventory_2_outlined,
        iconColor: const Color(0xFFB45309), // amber-700
        iconBgColor: const Color(0xFFFFFBEB), // amber-50
        iconBorderColor: const Color(0xFFFDE68A), // amber-200
      ),
      SupplierListingItem(
        id: 'sup_2',
        title: 'Apple Plants',
        subcategory: 'Nursery / Plants',
        quantityText: 'M9 & Gala Rootstocks',
        priceText: 'Price on enquiry',
        priceUnit: null,
        isPriceOnEnquiry: true,
        isPublished: true,
        isSponsored: false,
        icon: Icons.park_outlined,
        iconColor: const Color(0xFF047857), // emerald-700
        iconBgColor: const Color(0xFFECFDF5), // emerald-50
        iconBorderColor: const Color(0xFFA7F3D0), // emerald-200
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
    return 'MK';
  }

  void _togglePublish(SupplierListingItem item) {
    setState(() {
      item.isPublished = !item.isPublished;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.isPublished
              ? '${item.title} is now Public and Published'
              : '${item.title} is now Private (Hidden from buyers)',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleSponsor(SupplierListingItem item) {
    setState(() {
      item.isSponsored = !item.isSponsored;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.isSponsored
              ? '${item.title} is now Sponsored at the top of search results!'
              : 'Sponsorship removed for ${item.title}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDeleteListing(SupplierListingItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Listing',
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
                _listings.removeWhere((l) => l.id == item.id);
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

  void _viewListingDetails(SupplierListingItem item) {
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
              Text(
                'Availability / Specs: ${item.quantityText}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 6),
              Text(
                'Price: ${item.priceText} ${item.priceUnit ?? ""}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              if (item.isSponsored) ...[
                const SizedBox(height: 8),
                const Text(
                  '★ Sponsored Listing (Promoted across Kashmir)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB45309),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.supplierName?.isNotEmpty == true
        ? widget.supplierName!
        : 'Mohammad Khalil';
    final initials = _getInitials(displayName);
    final activeCount = _listings.where((l) => l.isPublished).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: _buildBottomNavigation(),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER & BRANDING
            _buildTopHeader(initials),

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
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

                        // 2. PRIMARY ACTION: "+ Add Listing"
                        _buildAddListingAction(),
                        const SizedBox(height: 20),

                        // 3 & 4. MY LISTINGS SECTION
                        _buildMyListingsSection(activeCount),
                        const SizedBox(height: 16),

                        // 5. SPONSORED VISIBILITY INFO CARD
                        _buildSponsoredInfoCard(),
                        const SizedBox(height: 16),

                        // 6. CHAT ENQUIRIES SHORTCUT CARD
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
          // Left: Logo, Brand Wordmark & Supplier Pill
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            // AppleHaat Logo in white rounded square
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5.0),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7), // amber-100
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFFFDE68A), // amber-200
                        ),
                      ),
                      child: const Text(
                        'Supplier',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E), // amber-800
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Kashmir Marketplace',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right: Notification Bell & Profile Controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification Bell with Badge
            IconButton(
              onPressed: () => context.pushNamed(RouteNames.notifications),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
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

  /// 2. Primary Action: "+ Add Listing"
  Widget _buildAddListingAction() {
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
          onTap: () => context.pushNamed(RouteNames.supplierAddListing),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
            child: Row(
              children: [
                // Plus Icon in frosted square container
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Subtitle
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+ Add Listing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'List Your Product',
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
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 3 & 4. My Listings Section
  Widget _buildMyListingsSection(int activeCount) {
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
                  'My Listings',
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
                'Orchard Supplies',
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

        // Listings or Empty State
        if (_listings.isEmpty)
          _buildEmptyListingsState()
        else
          Column(
            children: _listings.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildListingCard(item),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// Individual Product Listing Card
  Widget _buildListingCard(SupplierListingItem item) {
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
          // Top Row: Product Icon, Name, Subcategory, Specs, Badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Visual Box
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: item.iconBorderColor),
                ),
                alignment: Alignment.center,
                child: Icon(
                  item.icon,
                  size: 26,
                  color: item.iconColor,
                ),
              ),
              const SizedBox(width: 12),

              // Title, Subcategory & Price/Availability
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.subcategory,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Quantity • Price
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          item.quantityText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            '•',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        if (item.isPriceOnEnquiry)
                          Text(
                            item.priceText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          )
                        else ...[
                          Text(
                            item.priceText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (item.priceUnit != null)
                            Text(
                              ' ${item.priceUnit!}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Badges Column: Published & Sponsored
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
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.isPublished
                                ? const Color(0xFF10B981)
                                : const Color(0xFF94A3B8),
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

                  // Sponsored Badge (if applicable)
                  if (item.isSponsored) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: const Text(
                        '★ Sponsored',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              height: 1.0,
              thickness: 1.0,
              color: Color(0xFFF1F5F9),
            ),
          ),

          // Bottom Action Toolbar (View, Make Private/Public, Sponsor, Edit)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Group: View & Make Private/Public (or Sponsor & View)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // If not sponsored, offer the Sponsor button here (Listing 2 in Stitch)
                  if (!item.isSponsored)
                    InkWell(
                      onTap: () => _toggleSponsor(item),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB), // amber-50
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFFDE68A), // amber-200
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: Color(0xFFD97706),
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Sponsor',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // View Action
                  InkWell(
                    onTap: () => _viewListingDetails(item),
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Make Private / Make Public Toggle Action (Listing 1 in Stitch)
                  if (item.isSponsored)
                    InkWell(
                      onTap: () => _togglePublish(item),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Right Group: Edit Button & Delete Option
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit Button
                  InkWell(
                    onTap: () => context.pushNamed(
                      RouteNames.editListing,
                      extra: {'listingId': item.id, 'title': item.title},
                    ),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
                  const SizedBox(width: 4),

                  // More / Delete Action
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _confirmDeleteListing(item);
                      } else if (value == 'toggle_publish') {
                        _togglePublish(item);
                      } else if (value == 'toggle_sponsor') {
                        _toggleSponsor(item);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'toggle_publish',
                        child: Text(item.isPublished ? 'Make Private' : 'Make Public'),
                      ),
                      PopupMenuItem(
                        value: 'toggle_sponsor',
                        child: Text(item.isSponsored ? 'Remove Sponsorship' : 'Sponsor Listing'),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Listing',
                          style: TextStyle(color: Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Empty state displayed when no listings exist
  Widget _buildEmptyListingsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFFDC2626),
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Product Listings Yet',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap "+ Add Listing" above to list your orchard supplies and products.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 5. Sponsored Visibility Info Card
  Widget _buildSponsoredInfoCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFFFBEB), // amber-50
            Color(0xFFFFF7ED), // orange-50/60
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFDE68A).withValues(alpha: 0.7),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lightning bolt in rounded container
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.bolt_rounded,
              size: 20,
              color: Color(0xFFB45309),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Description
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Boost Inquiries with Sponsored Listings',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF78350F),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Sponsored products appear at the top of search results for apple growers & buyers across Kashmir.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF92400E),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 6. Direct Chat Enquiries Shortcut Card
  Widget _buildChatEnquiriesCard() {
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
                  'Direct Chat Enquiries',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Chat with orchard growers and buyers',
                  style: TextStyle(
                    fontSize: 12,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Tab (Active)
          InkWell(
            onTap: () {}, // Already on Home
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF2F2), // red-50
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.home_rounded,
                      size: 20,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
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

          // Chat Tab
          InkWell(
            onTap: () => context.pushNamed(RouteNames.chat),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Tab
          InkWell(
            onTap: () => context.pushNamed(RouteNames.profile),
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 11,
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
    );
  }
}
