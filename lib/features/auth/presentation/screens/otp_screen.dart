import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// OtpScreen implements Screen 3 (OTP Verification) strictly matching the
/// Stitch design source of truth.
class OtpScreen extends StatefulWidget {
  final String? mobileNumber;

  const OtpScreen({
    super.key,
    this.mobileNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with SingleTickerProviderStateMixin {
  static const int _codeLength = AppConstants.otpLength;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  Timer? _resendTimer;
  int _secondsLeft = AppConstants.otpResendCooldownSeconds;

  String? _errorMessage;
  String? _infoMessage;
  bool _isVerifying = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _codeLength,
      (index) => TextEditingController(),
    );

    _focusNodes = List.generate(
      _codeLength,
      (index) => FocusNode(),
    );

    for (int i = 0; i < _codeLength; i++) {
      final index = i;
      _focusNodes[index].addListener(() {
        if (mounted) setState(() {});
      });
      _controllers[index].addListener(() {
        if (mounted) setState(() {});
      });
    }

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _startCountdown();

    // Automatically focus the first OTP digit field after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _shakeController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _resendTimer?.cancel();
    _secondsLeft = AppConstants.otpResendCooldownSeconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onResendOtp() {
    if (_secondsLeft > 0) return;

    setState(() {
      _startCountdown();
      _errorMessage = null;
      _infoMessage = 'A new 6-digit OTP has been sent.';
    });

    // Automatically refocus first field if needed
    _focusNodes[0].requestFocus();
  }

  void _onDigitChanged(int index, String value) {
    // Clear any active error message on interaction
    if (_errorMessage != null || _infoMessage != null) {
      setState(() {
        _errorMessage = null;
        _infoMessage = null;
      });
    }

    // Handle full paste (e.g. 6 digits entered at once)
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      for (int i = 0; i < digits.length && (index + i) < _codeLength; i++) {
        _controllers[index + i].text = digits[i];
      }
      final nextIndex = (index + digits.length).clamp(0, _codeLength - 1);
      _focusNodes[nextIndex].requestFocus();
      return;
    }

    if (value.isNotEmpty) {
      // Keep only the first digit entered
      if (value.length > 1) {
        _controllers[index].text = value.substring(0, 1);
      }
      // Auto-advance to next cell if available
      if (index < _codeLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last cell filled - keep focus or dismiss
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onVerifyPressed() async {
    if (_isVerifying || _isVerified) return;

    final enteredCode = _controllers.map((c) => c.text.trim()).join();

    // Validate that 6 digits are entered
    if (enteredCode.length < _codeLength || enteredCode == '000000') {
      setState(() {
        _errorMessage = 'Incorrect OTP. Please check code or request a new one.';
        _infoMessage = null;
      });
      _shakeController.forward(from: 0.0);

      // Focus first empty cell
      for (int i = 0; i < _codeLength; i++) {
        if (_controllers[i].text.isEmpty) {
          _focusNodes[i].requestFocus();
          break;
        }
      }
      return;
    }

    // Clear messages and simulate mock verification state
    setState(() {
      _errorMessage = null;
      _infoMessage = null;
      _isVerifying = true;
    });

    // Simulated network verification delay
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      _isVerifying = false;
      _isVerified = true;
    });

    // Brief verified celebration before navigating
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // Navigate to Screen 4 (Registration) replacing route so user cannot go back
    context.go(RouteNames.registrationPath);
  }

  String _formatMobile(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return '+91 98765 43210';
    }
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
    }
    return '+91 $raw';
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

                      // BEGIN: VerificationCard
                      _buildVerificationCard(),

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
        'Verify Your Number',
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

  /// Main Verification Card containing OTP inputs, timer, resend, and verify button
  Widget _buildVerificationCard() {
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
            blurRadius: 36,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
          const BoxShadow(
            color: Color(0x0AC62828),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Target Phone Info & Edit Action
          Center(
            child: Column(
              children: [
                Text(
                  'ENTER 6-DIGIT CODE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.stone500,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _formatMobile(widget.mobileNumber),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => context.go(RouteNames.loginPath),
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ruby600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.ruby600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // BEGIN: OTP 6-Digit Cells (with shake animation on error)
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              final double offset = sin(_shakeAnimation.value * pi * 4) * 6.0;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: _buildOtpInputRow(),
          ),

          // Inline Error Message Cue
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFEE2E2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: AppColors.ruby600,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ruby600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Inline Resend Flash Notification
          if (_infoMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: Color(0xFF047857),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _infoMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF047857),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Timer & Resend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Opacity(
                  opacity: _secondsLeft > 0 ? 1.0 : 0.4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.stone400,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            text: 'Resend OTP in ',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.stone500,
                            ),
                            children: [
                              TextSpan(
                                text: '00:${_secondsLeft < 10 ? '0$_secondsLeft' : _secondsLeft}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.stone700,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _secondsLeft == 0 ? _onResendOtp : null,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _secondsLeft == 0 ? AppColors.ruby600 : AppColors.stone400,
                      decoration: _secondsLeft == 0 ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: AppColors.ruby600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Primary Action Button: Verify
          _buildVerifyButton(),
        ],
      ),
    );
  }

  /// 6 individual OTP digit cells row with responsive sizing
  Widget _buildOtpInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_codeLength, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: SizedBox(
              height: 56.0,
              child: _buildDigitCell(index),
            ),
          ),
        );
      }),
    );
  }

  /// Individual OTP digit input cell
  Widget _buildDigitCell(int index) {
    final bool hasFocus = _focusNodes[index].hasFocus;
    final bool isError = _errorMessage != null;

    Color borderColor;
    Color bgColor;

    if (isError) {
      borderColor = AppColors.ruby600;
      bgColor = Colors.white;
    } else if (hasFocus) {
      borderColor = AppColors.ruby600;
      bgColor = Colors.white;
    } else {
      borderColor = const Color(0xFFE5E7EB);
      bgColor = const Color(0xFFFBFBF9);
    }

    return Focus(
      onKeyEvent: (node, event) {
        // Handle backspace when current cell is empty to navigate backwards
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
          if (_controllers[index].text.isEmpty && index > 0) {
            _controllers[index - 1].clear();
            _focusNodes[index - 1].requestFocus();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          boxShadow: hasFocus
              ? [
                  BoxShadow(
                    color: AppColors.ruby600.withValues(alpha: 0.18),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(_codeLength),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            onChanged: (value) => _onDigitChanged(index, value),
          ),
        ),
      ),
    );
  }

  /// Primary Action Button (Verify) matching Stitch styling
  Widget _buildVerifyButton() {
    Color buttonColor;
    if (_isVerified) {
      buttonColor = const Color(0xFF2E7D32); // Success green
    } else {
      buttonColor = AppColors.ruby600;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _isVerified
                ? const Color(0x612E7D32)
                : const Color(0x61C62828),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _isVerifying || _isVerified ? null : _onVerifyPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isVerifying) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Verifying...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ] else if (_isVerified) ...[
                  const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Verified!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
