import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// OnboardingSlide2Graphic renders the exact Slide 2 Stitch vector illustration:
/// Central Apple Core connected through axes and colored arms to 4 ecosystem badges:
/// GROWERS (Green), SERVICES (Blue), BUYERS (Red/Pink), SUPPLIERS (Amber).
class OnboardingSlide2Graphic extends StatelessWidget {
  final double size;

  const OnboardingSlide2Graphic({
    super.key,
    this.size = 256,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _Slide2Painter(),
      ),
    );
  }
}

class _Slide2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 260.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()..isAntiAlias = true;

    // 1. Outer Dashed Orbit (circle at 130, 130, radius 72)
    _drawDashedCircle(
      canvas: canvas,
      center: const Offset(130, 130),
      radius: 72,
      color: const Color(0xFFCBD5E1),
      strokeWidth: 2,
      dashLength: 4,
      gapLength: 5,
    );

    // 2. Cross Connector Axes (E2E8F0, width 2)
    final axisPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawLine(const Offset(130, 65), const Offset(130, 195), axisPaint);
    canvas.drawLine(const Offset(65, 130), const Offset(195, 130), axisPaint);

    // 3. Colored Connection Arms (width 3, strokeCap round)
    final armPaint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Top arm (Green)
    armPaint.color = const Color(0xFF10B981);
    canvas.drawLine(const Offset(130, 105), const Offset(130, 72), armPaint);

    // Left arm (Blue)
    armPaint.color = const Color(0xFF0284C7);
    canvas.drawLine(const Offset(105, 130), const Offset(72, 130), armPaint);

    // Right arm (Pink/Red)
    armPaint.color = const Color(0xFFE11D48);
    canvas.drawLine(const Offset(155, 130), const Offset(188, 130), armPaint);

    // Bottom arm (Amber)
    armPaint.color = const Color(0xFFF59E0B);
    canvas.drawLine(const Offset(130, 155), const Offset(130, 188), armPaint);

    // 4. Central Apple Core
    paint.color = const Color(0xFFFEF2F2);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(130, 130), 24, paint);

    final coreBorderPaint = Paint()
      ..color = const Color(0xFFFCA5A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..isAntiAlias = true;
    canvas.drawCircle(const Offset(130, 130), 24, coreBorderPaint);

    // Central mini apple (scaled 0.75 translated to 130, 130)
    canvas.save();
    canvas.translate(130, 130);
    canvas.scale(0.75, 0.75);

    // Mini Leaf
    final miniLeaf = Path()
      ..moveTo(0, -14)
      ..cubicTo(1, -18, 5, -18, 5, -15)
      ..cubicTo(5, -12, 1, -13, 0, -13)
      ..close();
    paint.color = const Color(0xFF16A34A);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(miniLeaf, paint);

    // Mini Apple body
    final miniApple = Path()
      ..moveTo(0, -12)
      ..cubicTo(9, -12, 16, -4, 16, 7)
      ..cubicTo(16, 19, 8, 26, 0, 26)
      ..cubicTo(-8, 26, -16, 19, -16, 7)
      ..cubicTo(-16, -4, -9, -12, 0, -12)
      ..close();
    paint.color = const Color(0xFFDC2626);
    canvas.drawPath(miniApple, paint);

    // Mini highlight
    paint.color = const Color(0xFFFCA5A5);
    canvas.drawCircle(const Offset(-5, 2), 2, paint);

    canvas.restore(); // Restore from central apple

    // 5. Four Ecosystem Node Badges
    _drawNodeBadge(
      canvas: canvas,
      center: const Offset(130, 52),
      bgColor: const Color(0xFFECFDF5),
      borderColor: const Color(0xFFA7F3D0),
      shadowColor: const Color(0xFF10B981).withValues(alpha: 0.16),
      title: 'GROWERS',
      titleColor: const Color(0xFF047857),
      drawIcon: (c) {
        // Sprout / Orchard Icon
        final stemP = Paint()
          ..color = const Color(0xFF059669)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true;
        c.drawLine(const Offset(0, 6), const Offset(0, -6), stemP);

        final leafP = Paint()
          ..color = const Color(0xFF059669)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        c.drawCircle(const Offset(0, -6), 6, leafP);

        leafP.color = const Color(0xFFECFDF5);
        c.drawCircle(const Offset(0, -6), 2.5, leafP);
      },
    );

    _drawNodeBadge(
      canvas: canvas,
      center: const Offset(52, 130),
      bgColor: const Color(0xFFF0F9FF),
      borderColor: const Color(0xFFBAE6FD),
      shadowColor: const Color(0xFF0284C7).withValues(alpha: 0.16),
      title: 'SERVICES',
      titleColor: const Color(0xFF0369A1),
      drawIcon: (c) {
        // Truck / Logistics Icon
        final truckPaint = Paint()
          ..color = const Color(0xFF0284C7)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

        final bodyP = Path()
          ..moveTo(-8, 4)
          ..lineTo(5, 4)
          ..lineTo(5, -5)
          ..lineTo(-8, -5)
          ..close();
        c.drawPath(bodyP, truckPaint);

        final cabP = Path()
          ..moveTo(5, 4)
          ..lineTo(10, 4)
          ..lineTo(12, 0)
          ..lineTo(12, -2)
          ..lineTo(5, -2)
          ..close();
        c.drawPath(cabP, truckPaint);

        final wheelPaint = Paint()
          ..color = const Color(0xFF0369A1)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        c.drawCircle(const Offset(-4, 5), 2, wheelPaint);
        c.drawCircle(const Offset(8, 5), 2, wheelPaint);
      },
    );

    _drawNodeBadge(
      canvas: canvas,
      center: const Offset(208, 130),
      bgColor: const Color(0xFFFFF1F2),
      borderColor: const Color(0xFFFECDD3),
      shadowColor: const Color(0xFFE11D48).withValues(alpha: 0.16),
      title: 'BUYERS',
      titleColor: const Color(0xFFBE123C),
      drawIcon: (c) {
        // Shopping Bag / Store Icon
        final handlePaint = Paint()
          ..color = const Color(0xFFE11D48)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true;
        final handlePath = Path()
          ..moveTo(-6, -2)
          ..cubicTo(-6, -6, 6, -6, 6, -2);
        c.drawPath(handlePath, handlePaint);

        final bagPaint = Paint()
          ..color = const Color(0xFFE11D48)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        c.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-7, -2, 14, 12),
            const Radius.circular(2),
          ),
          bagPaint,
        );

        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        c.drawCircle(const Offset(0, 3), 1.5, dotPaint);
      },
    );

    _drawNodeBadge(
      canvas: canvas,
      center: const Offset(130, 208),
      bgColor: const Color(0xFFFFFBEB),
      borderColor: const Color(0xFFFDE68A),
      shadowColor: const Color(0xFFF59E0B).withValues(alpha: 0.16),
      title: 'SUPPLIERS',
      titleColor: const Color(0xFFB45309),
      drawIcon: (c) {
        // Packaging Box Icon
        final pTop = Paint()
          ..color = const Color(0xFFD97706)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        final topPath = Path()
          ..moveTo(0, -7)
          ..lineTo(8, -3)
          ..lineTo(0, 1)
          ..lineTo(-8, -3)
          ..close();
        c.drawPath(topPath, pTop);

        final pLeft = Paint()
          ..color = const Color(0xFFB45309)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        final leftPath = Path()
          ..moveTo(-8, -2)
          ..lineTo(0, 2)
          ..lineTo(0, 9)
          ..lineTo(-8, 5)
          ..close();
        c.drawPath(leftPath, pLeft);

        final pRight = Paint()
          ..color = const Color(0xFFF59E0B)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        final rightPath = Path()
          ..moveTo(8, -2)
          ..lineTo(0, 2)
          ..lineTo(0, 9)
          ..lineTo(8, 5)
          ..close();
        c.drawPath(rightPath, pRight);
      },
    );

    canvas.restore(); // Restore scale
  }

  void _drawNodeBadge({
    required Canvas canvas,
    required Offset center,
    required Color bgColor,
    required Color borderColor,
    required Color shadowColor,
    required String title,
    required Color titleColor,
    required void Function(Canvas) drawIcon,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-26, -26, 52, 52),
      const Radius.circular(14),
    );

    // Drop shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(rrect.shift(const Offset(0, 3)), shadowPaint);

    // Background fill
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawRRect(rrect, bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawRRect(rrect, borderPaint);

    // Draw Icon
    drawIcon(canvas);

    // Draw Title Text
    final textSpan = TextSpan(
      text: title,
      style: GoogleFonts.plusJakartaSans(
        color: titleColor,
        fontSize: 7.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, 11),
    );

    canvas.restore();
  }

  void _drawDashedCircle({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Color color,
    required double strokeWidth,
    required double dashLength,
    required double gapLength,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final circumference = 2 * math.pi * radius;
    final totalPattern = dashLength + gapLength;
    final count = (circumference / totalPattern).floor();
    final adjustedPattern = circumference / count;
    final dashAngle = (dashLength / adjustedPattern) * (2 * math.pi / count);
    final totalAngleStep = 2 * math.pi / count;

    for (int i = 0; i < count; i++) {
      final startAngle = i * totalAngleStep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
