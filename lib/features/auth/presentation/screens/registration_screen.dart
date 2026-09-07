import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// RegistrationScreen implements Screen 4 (Create Your Account / Registration)
/// strictly reproducing the Stitch design source of truth.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  String? _selectedState;
  String? _nameError;
  String? _addressError;
  String? _stateError;

  bool _isNameFocused = false;
  bool _isAddressFocused = false;

  static const List<String> _states = [
    'Jammu & Kashmir',
    'Himachal Pradesh',
    'Punjab',
    'Haryana',
    'Delhi',
    'Uttar Pradesh',
    'Uttarakhand',
    'Rajasthan',
    'Gujarat',
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'West Bengal',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      setState(() {
        _isNameFocused = _nameFocusNode.hasFocus;
      });
    });
    _addressFocusNode.addListener(() {
      setState(() {
        _isAddressFocused = _addressFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    String? nameError;
    String? addressError;
    String? stateError;

    if (name.isEmpty) {
      nameError = 'Please enter your name or company name';
    } else if (name.length < 2) {
      nameError = 'Name must be at least 2 characters';
    }

    if (address.isEmpty) {
      addressError = 'Please enter your village/town or address';
    } else if (address.length < 3) {
      addressError = 'Address must be at least 3 characters';
    }

    if (_selectedState == null || _selectedState!.isEmpty) {
      stateError = 'Please select your State/UT';
    }

    setState(() {
      _nameError = nameError;
      _addressError = addressError;
      _stateError = stateError;
    });

    if (nameError != null || addressError != null || stateError != null) {
      return;
    }

    // Unfocus all fields
    _nameFocusNode.unfocus();
    _addressFocusNode.unfocus();

    // In-memory registration data for local state / testing
    final registrationData = {
      'fullName': name,
      'address': address,
      'state': _selectedState,
    };

    // Navigate to Screen 5 (Role Selection Placeholder)
    context.pushNamed(RouteNames.roleSelection, extra: registrationData);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.parchment,
        body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              physics: const ClampingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 390.0,
                    minHeight: constraints.maxHeight - 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // BEGIN: BrandHeader
                      _buildHeader(),

                      const SizedBox(height: 16),

                      // BEGIN: RegistrationCard
                      _buildRegistrationCard(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

  /// Screen title presentation
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        'Fill Registration Details',
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1F2937),
          letterSpacing: -0.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// White registration card containing input fields and submit button
  Widget _buildRegistrationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: AppColors.stone200.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Name / Company Name Field
            _buildNameField(),

            const SizedBox(height: 16),

            // Address Field
            _buildAddressField(),

            const SizedBox(height: 16),

            // State Dropdown Field
            _buildStateField(),

            const SizedBox(height: 24),

            // Continue Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// Full Name / Company Name Input
  Widget _buildNameField() {
    final hasError = _nameError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full Name / Company Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError
                  ? AppColors.ruby600
                  : _isNameFocused
                      ? AppColors.ruby600
                      : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: _isNameFocused
                ? [
                    BoxShadow(
                      color: AppColors.ruby600.withValues(alpha: 0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              hintText: 'Enter your name',
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (_) {
              if (_nameError != null) {
                setState(() {
                  _nameError = null;
                });
              }
            },
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              _nameError!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ruby600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Address Input
  Widget _buildAddressField() {
    final hasError = _addressError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError
                  ? AppColors.ruby600
                  : _isAddressFocused
                      ? AppColors.ruby600
                      : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: _isAddressFocused
                ? [
                    BoxShadow(
                      color: AppColors.ruby600.withValues(alpha: 0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: _addressController,
            focusNode: _addressFocusNode,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              hintText: 'Enter your village/town or address',
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (_) {
              if (_addressError != null) {
                setState(() {
                  _addressError = null;
                });
              }
            },
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              _addressError!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ruby600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// State Dropdown Selector
  Widget _buildStateField() {
    final hasError = _stateError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'State',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError ? AppColors.ruby600 : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedState,
            icon: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF64748B),
                size: 22,
              ),
            ),
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.apartment_outlined,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            hint: const Text(
              'Select State/UT',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
            items: _states.map((state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedState = value;
                _stateError = null;
              });
            },
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              _stateError!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ruby600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Primary Submit Button (Continue)
  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59C62828),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: AppColors.ruby600,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _onContinuePressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
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
