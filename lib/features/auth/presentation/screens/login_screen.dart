import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/applehaat_logo.dart';

/// LoginScreen implements Screen 2 (Login / Register) strictly following
/// the Stitch design source of truth.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  String? _errorMessage;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {
        _isFocused = _phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    final rawNumber = _phoneController.text.trim();
    final validationError = Validators.validateMobile(rawNumber);

    if (validationError != null) {
      setState(() {
        _errorMessage = validationError;
      });
      return;
    }

    // Clear any previous error
    setState(() {
      _errorMessage = null;
    });

    // Unfocus keyboard before navigating
    _phoneFocusNode.unfocus();

    // Navigate to Screen 3 (OTP) passing the validated 10-digit number
    context.pushNamed(RouteNames.otp, extra: rawNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32.0,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // BEGIN: BrandHeader
                      _buildHeader(),

                      // BEGIN: AuthenticationCard
                      _buildAuthCard(),

                      // BEGIN: LegalAndRegionalFooter
                      _buildFooter(),
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

  /// Top Brand Header with Logo, Wordmark, and Regional Pill
  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),

        // AppleHaat Kashmir Logo
        const AppleHaatLogo(
          size: 100,
        ),
        const SizedBox(height: 12),

        // Brand Wordmark: Apple (Stone-900) + Haat (Ruby-600)
        RichText(
          text: TextSpan(
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Apple',
                style: TextStyle(color: AppColors.stone900),
              ),
              TextSpan(
                text: 'Haat',
                style: TextStyle(color: AppColors.ruby600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Screen Title
        Text(
          'Welcome to AppleHaat',
          style: AppTextStyles.headlineSm.copyWith(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: AppColors.stone800,
            letterSpacing: -0.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Regional Subtitle Pill with subtle green indicator dot
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.orchard50,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.orchard100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orchard600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                AppConstants.appTagline,
                style: const TextStyle(
                  color: AppColors.orchard700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Authentication Input Card matching the Stitch design
  Widget _buildAuthCard() {
    final hasError = _errorMessage != null;

    Color borderColor = AppColors.stone200;
    Color bgColor = AppColors.stone50;

    if (hasError) {
      borderColor = AppColors.error;
      bgColor = AppColors.ruby50.withValues(alpha: 0.3);
    } else if (_isFocused) {
      borderColor = AppColors.ruby600;
      bgColor = Colors.white;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.stone200.withValues(alpha: 0.8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2C1810),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large Accessible Field Label
          const Text(
            'Mobile Number',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: AppColors.stone900,
            ),
          ),
          const SizedBox(height: 12),

          // Pre-filled Country Code & Big Phone Input Container
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: borderColor,
                width: 2.0,
              ),
              boxShadow: _isFocused && !hasError
                  ? [
                      BoxShadow(
                        color: AppColors.ruby600.withValues(alpha: 0.12),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Flag and +91 Prefix
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 10, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      // Minimalist India Flag Badge
                      _buildIndiaFlag(),
                      const SizedBox(width: 8),
                      const Text(
                        '+91',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.stone900,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Divider Line
                Container(
                  width: 1,
                  height: 28,
                  color: AppColors.stone200,
                  margin: const EdgeInsets.only(right: 8),
                ),

                // Number Input Field
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (val) {
                      if (_errorMessage != null) {
                        setState(() {
                          _errorMessage = null;
                        });
                      }
                    },
                    onSubmitted: (_) => _onContinuePressed(),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.stone900,
                      letterSpacing: 1.2,
                    ),
                    decoration: const InputDecoration(
                      hintText: '98765 43210',
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.stone400,
                        letterSpacing: 1.0,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Error Message Display
          if (hasError) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Informative Helper Note with Shield Icon
          Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 16,
                  color: AppColors.orchard600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.stone600,
                      ),
                      children: [
                        TextSpan(text: 'Log in or register with OTP • '),
                        TextSpan(
                          text: 'No password needed',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.stone800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Primary Submit Button: Continue with Arrow Icon
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _onContinuePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ruby600,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: AppColors.ruby600.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Minimalist India Flag Widget (Saffron, White with Ashoka Chakra dot, Green)
  Widget _buildIndiaFlag() {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(
          color: AppColors.stone200,
          width: 0.8,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Container(color: const Color(0xFFFF9933)),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  width: 3.2,
                  height: 3.2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF000088),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(color: const Color(0xFF128807)),
          ),
        ],
      ),
    );
  }

  /// Footer: Legal Terms & Privacy Policy Note
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: AppColors.stone500,
            height: 1.4,
          ),
          children: [
            TextSpan(text: 'By continuing, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                color: AppColors.stone700,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(text: ' & '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: AppColors.stone700,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}
