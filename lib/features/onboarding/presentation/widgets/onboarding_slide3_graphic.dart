import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// OnboardingSlide3Graphic renders the exact 2x2 Feature Cards Grid from Stitch:
/// - Card 1: Apple Listing (Sell & buy crops)
/// - Card 2: Products (Boxes, fertilizers)
/// - Card 3: Services (Cold store, grading)
/// - Card 4: Direct Chat (Connect instantly with online badge)
class OnboardingSlide3Graphic extends StatelessWidget {
  final double size;

  const OnboardingSlide3Graphic({
    super.key,
    this.size = 256,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: SizedBox(
          width: 290,
          height: 290,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        borderColor: const Color(0xFFFEE2E2), // border-red-100
                        iconBgColor: const Color(0xFFFEF2F2), // bg-red-50
                        title: 'Apple Listing',
                        subtitle: 'Sell & buy crops',
                        icon: const _AppleIcon(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCard(
                        borderColor: const Color(0xFFFEF3C7), // border-amber-100
                        iconBgColor: const Color(0xFFFFFBEB), // bg-amber-50
                        title: 'Products',
                        subtitle: 'Boxes, fertilizers',
                        icon: const _ProductBoxIcon(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        borderColor: const Color(0xFFE0F2FE), // border-sky-100
                        iconBgColor: const Color(0xFFF0F9FF), // bg-sky-50
                        title: 'Services',
                        subtitle: 'Cold store, grading',
                        icon: const _TruckIcon(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCard(
                        borderColor: const Color(0xFFD1FAE5), // border-emerald-100
                        iconBgColor: const Color(0xFFECFDF5), // bg-emerald-50
                        title: 'Direct Chat',
                        subtitle: 'Connect instantly',
                        hasOnlineDot: true,
                        icon: const _ChatIcon(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required Color borderColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Widget icon,
    bool hasOnlineDot = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (hasOnlineDot)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981), // bg-emerald-500
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: icon,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A), // slate-900
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B), // slate-500
                      height: 1.2,
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

/// Custom vector icon for Apple Listing
class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _AppleIconPainter(),
    );
  }
}

class _AppleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final stemPaint = Paint()
      ..color = const Color(0xFF16A34A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    final stem = Path()
      ..moveTo(12, 4)
      ..cubicTo(12.5, 2.5, 14, 2, 15, 2.5);
    canvas.drawPath(stem, stemPaint);

    final applePaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final apple = Path()
      ..moveTo(12, 6)
      ..cubicTo(7, 6, 4, 9.5, 4, 14)
      ..cubicTo(4, 19.5, 8, 22, 12, 22)
      ..cubicTo(16, 22, 20, 19.5, 20, 14)
      ..cubicTo(20, 9.5, 17, 6, 12, 6)
      ..close();
    canvas.drawPath(apple, applePaint);

    final highlightPaint = Paint()
      ..color = const Color(0xFFFECACA)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(const Offset(9, 11), 1.5, highlightPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom vector icon for Products
class _ProductBoxIcon extends StatelessWidget {
  const _ProductBoxIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _ProductBoxPainter(),
    );
  }
}

class _ProductBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final strokePaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final topFlap = Path()
      ..moveTo(12, 3)
      ..lineTo(20, 7.5)
      ..lineTo(12, 12)
      ..lineTo(4, 7.5)
      ..close();
    canvas.drawPath(topFlap, strokePaint);

    final leftSide = Path()
      ..moveTo(4, 8.5)
      ..lineTo(4, 16)
      ..lineTo(12, 20.5)
      ..lineTo(12, 13);
    canvas.drawPath(leftSide, strokePaint);

    final rightSide = Path()
      ..moveTo(20, 8.5)
      ..lineTo(20, 16)
      ..lineTo(12, 20.5);
    canvas.drawPath(rightSide, strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom vector icon for Services (Truck)
class _TruckIcon extends StatelessWidget {
  const _TruckIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _TruckPainter(),
    );
  }
}

class _TruckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final strokePaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..isAntiAlias = true;

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 6, 13, 9),
        const Radius.circular(1.5),
      ),
      strokePaint,
    );

    // Cab
    final cab = Path()
      ..moveTo(15, 9)
      ..lineTo(19, 9)
      ..lineTo(22, 12)
      ..lineTo(22, 15)
      ..lineTo(15, 15)
      ..lineTo(15, 9)
      ..close();
    canvas.drawPath(cab, strokePaint);

    // Wheels
    canvas.drawCircle(const Offset(6.5, 17.5), 2, strokePaint);
    canvas.drawCircle(const Offset(17.5, 17.5), 2, strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom vector icon for Direct Chat
class _ChatIcon extends StatelessWidget {
  const _ChatIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _ChatPainter(),
    );
  }
}

class _ChatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final strokePaint = Paint()
      ..color = const Color(0xFF059669) // stroke-emerald-600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Chat bubble outline
    final bubble = Path()
      ..moveTo(21, 12)
      ..cubicTo(21, 16.418, 16.97, 20, 12, 20)
      ..cubicTo(10.45, 20, 8.98, 19.64, 7.745, 19.051)
      ..lineTo(3, 20)
      ..lineTo(4.395, 16.28)
      ..cubicTo(3.512, 15.042, 3, 13.574, 3, 12)
      ..cubicTo(3, 7.582, 7.03, 4, 12, 4)
      ..cubicTo(16.97, 4, 21, 7.582, 21, 12)
      ..close();
    canvas.drawPath(bubble, strokePaint);

    // 3 dots inside chat bubble
    final dotPaint = Paint()
      ..color = const Color(0xFF059669)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(const Offset(8.25, 12), 1.0, dotPaint);
    canvas.drawCircle(const Offset(12, 12), 1.0, dotPaint);
    canvas.drawCircle(const Offset(15.75, 12), 1.0, dotPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
