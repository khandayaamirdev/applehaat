import 'dart:math' as math;
import 'package:flutter/material.dart';

/// OnboardingSlide1Graphic renders the exact Slide 1 Stitch vector illustration:
/// Mountain peaks with snowcaps, lush orchard hills, apple trees,
/// dashed glow orbit, ruby Kashmir apple, and wooden harvest crate.
class OnboardingSlide1Graphic extends StatelessWidget {
  final double size;

  const OnboardingSlide1Graphic({
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
        painter: _Slide1Painter(),
      ),
    );
  }
}

class _Slide1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Original SVG coordinate space is 260x260
    final scale = size.width / 260.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()..isAntiAlias = true;

    // 1. Left Mountain Peak
    final leftMountain = Path()
      ..moveTo(75, 80)
      ..lineTo(130, 170)
      ..lineTo(20, 170)
      ..close();
    paint.color = const Color(0xFFCBD5E1).withValues(alpha: 0.4);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(leftMountain, paint);

    // Left Mountain Snowcap
    final leftSnow = Path()
      ..moveTo(75, 80)
      ..lineTo(90, 110)
      ..lineTo(60, 110)
      ..close();
    paint.color = Colors.white;
    canvas.drawPath(leftSnow, paint);

    // 2. Right Mountain Peak
    final rightMountain = Path()
      ..moveTo(185, 85)
      ..lineTo(240, 170)
      ..lineTo(130, 170)
      ..close();
    paint.color = const Color(0xFFCBD5E1).withValues(alpha: 0.5);
    canvas.drawPath(rightMountain, paint);

    // Right Mountain Snowcap
    final rightSnow = Path()
      ..moveTo(185, 85)
      ..lineTo(200, 112)
      ..lineTo(170, 112)
      ..close();
    paint.color = Colors.white;
    canvas.drawPath(rightSnow, paint);

    // 3. Center Mountain Peak
    final centerMountain = Path()
      ..moveTo(130, 50)
      ..lineTo(190, 170)
      ..lineTo(70, 170)
      ..close();
    paint.color = const Color(0xFFE2E8F0).withValues(alpha: 0.6);
    canvas.drawPath(centerMountain, paint);

    // Center Mountain Snowcap
    final centerSnow = Path()
      ..moveTo(130, 50)
      ..lineTo(150, 90)
      ..lineTo(110, 90)
      ..close();
    paint.color = Colors.white;
    canvas.drawPath(centerSnow, paint);

    // 4. Gentle Lush Hills (Ellipses)
    paint.color = const Color(0xFFBBF7D0).withValues(alpha: 0.85);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(130, 180), width: 210, height: 90),
      paint,
    );

    paint.color = const Color(0xFF86EFAC).withValues(alpha: 0.5);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(130, 185), width: 170, height: 64),
      paint,
    );

    // 5. Left Orchard Tree
    // Trunk
    paint.color = const Color(0xFF78350F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(73, 160, 6, 20),
        const Radius.circular(2),
      ),
      paint,
    );
    // Tree foliage
    paint.color = const Color(0xFF16A34A);
    canvas.drawCircle(const Offset(76, 150), 18, paint);
    // Red apples on left tree
    paint.color = const Color(0xFFEF4444);
    canvas.drawCircle(const Offset(72, 146), 2.5, paint);
    canvas.drawCircle(const Offset(81, 154), 2.5, paint);

    // 6. Right Orchard Tree
    // Trunk
    paint.color = const Color(0xFF78350F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(181, 160, 6, 20),
        const Radius.circular(2),
      ),
      paint,
    );
    // Tree foliage
    paint.color = const Color(0xFF16A34A);
    canvas.drawCircle(const Offset(184, 150), 18, paint);
    // Red apples on right tree
    paint.color = const Color(0xFFEF4444);
    canvas.drawCircle(const Offset(180, 154), 2.5, paint);
    canvas.drawCircle(const Offset(188, 146), 2.5, paint);

    // 7. Dashed Glow Orbit
    // Circle fill
    paint.color = const Color(0xFFFEF2F2).withValues(alpha: 0.9);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(130, 135), 48, paint);

    // Circle dashed stroke
    _drawDashedCircle(
      canvas: canvas,
      center: const Offset(130, 135),
      radius: 48,
      color: const Color(0xFFFCA5A5),
      strokeWidth: 2,
      dashLength: 5,
      gapLength: 5,
    );

    // 8. Central Ruby Kashmir Apple (Translated to 130, 132)
    canvas.save();
    canvas.translate(130, 132);

    // Leaf
    final leafPath = Path()
      ..moveTo(0, -32)
      ..cubicTo(4, -40, 14, -38, 12, -30)
      ..cubicTo(10, -24, 2, -26, 0, -26)
      ..close();
    paint.color = const Color(0xFF16A34A);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(leafPath, paint);

    // Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    final stemPath = Path()
      ..moveTo(-1, -26)
      ..cubicTo(0, -22, 1, -18, 2, -14);
    canvas.drawPath(stemPath, stemPaint);

    // Apple Body
    final appleBody = Path()
      ..moveTo(0, -15)
      ..cubicTo(14, -15, 28, -4, 28, 12)
      ..cubicTo(28, 30, 14, 42, 0, 42)
      ..cubicTo(-14, 42, -28, 30, -28, 12)
      ..cubicTo(-28, -4, -14, -15, 0, -15)
      ..close();
    paint.color = const Color(0xFFDC2626);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(appleBody, paint);

    // Specular inner curve
    final specularPath = Path()
      ..moveTo(2, -13)
      ..cubicTo(12, -13, 22, -3, 22, 10)
      ..cubicTo(22, 25, 12, 34, 2, 34);
    final specularPaint = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(specularPath, specularPaint);

    // Highlight dot
    paint.color = const Color(0xFFFECACA).withValues(alpha: 0.85);
    canvas.drawCircle(const Offset(-9, 4), 3.5, paint);

    canvas.restore(); // Restore from apple translation

    // 9. Wooden Harvest Box / Crate with Fresh Apples (Translated to 130, 186)
    canvas.save();
    canvas.translate(130, 186);

    // Apples inside crate
    paint.color = const Color(0xFFDC2626);
    canvas.drawCircle(const Offset(-16, -8), 7, paint);
    canvas.drawCircle(const Offset(16, -8), 7, paint);
    paint.color = const Color(0xFFEF4444);
    canvas.drawCircle(const Offset(0, -9), 7.5, paint);

    // Wooden crate body
    paint.color = const Color(0xFFD97706);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-32, -5, 64, 24),
        const Radius.circular(4),
      ),
      paint,
    );

    // Top slat
    paint.color = const Color(0xFFF59E0B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-30, -3, 60, 7),
        const Radius.circular(2),
      ),
      paint,
    );

    // Bottom slat
    paint.color = const Color(0xFFB45309);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-30, 7, 60, 9),
        const Radius.circular(2),
      ),
      paint,
    );

    canvas.restore(); // Restore from crate translation

    canvas.restore(); // Restore scale
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
