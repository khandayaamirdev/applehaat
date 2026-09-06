import 'package:flutter/material.dart';
import '../constants/asset_paths.dart';

/// AppleHaatLogo renders the exact brand emblem from the Stitch design.
/// It renders using a high-fidelity vector CustomPainter matching the
/// Stitch SVG specifications, with support for fallback to the raster asset.
class AppleHaatLogo extends StatelessWidget {
  final double size;
  final bool useAssetImage;

  const AppleHaatLogo({
    super.key,
    this.size = 100.0,
    this.useAssetImage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useAssetImage) {
      return Image.asset(
        AssetPaths.appLogo,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: const AppleHaatLogoPainter(),
      ),
    );
  }
}

/// CustomPainter rendering the vector AppleHaat logo matching the Stitch SVG
class AppleHaatLogoPainter extends CustomPainter {
  const AppleHaatLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Reference SVG viewBox is 160x160
    const double refSize = 160.0;
    final double scale = size.width / refSize;

    canvas.save();
    canvas.scale(scale, scale);

    // 1. Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final stemPath = Path()
      ..moveTo(78, 36)
      ..cubicTo(77, 24, 85, 15, 91, 12);
    canvas.drawPath(stemPath, stemPaint);

    // 2. Leaf with linear gradient
    final leafPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF43A047),
          Color(0xFF2E7D32),
        ],
      ).createShader(const Rect.fromLTWH(80, 10, 40, 40))
      ..style = PaintingStyle.fill;

    final leafPath = Path()
      ..moveTo(84, 26)
      ..cubicTo(96, 15, 116, 18, 120, 28)
      ..cubicTo(118, 42, 98, 40, 84, 26)
      ..close();
    canvas.drawPath(leafPath, leafPaint);

    // 3. Apple Body with Kashmiri cleft aesthetic
    final applePath = Path()
      ..moveTo(80, 44)
      ..cubicTo(66, 32, 38, 30, 26, 50)
      ..cubicTo(14, 70, 18, 108, 40, 134)
      ..cubicTo(55, 152, 72, 153, 80, 146)
      ..cubicTo(88, 153, 105, 152, 120, 134)
      ..cubicTo(142, 108, 146, 70, 134, 50)
      ..cubicTo(122, 30, 94, 32, 80, 44)
      ..close();

    // Subtle drop shadow glow (matches SVG feDropShadow dx=0 dy=8 flood-color=#C62828 flood-opacity=0.25 stdDeviation=12)
    final shadowPaint = Paint()
      ..color = const Color(0xFFC62828).withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
    canvas.save();
    canvas.translate(0, 8);
    canvas.drawPath(applePath, shadowPaint);
    canvas.restore();

    // Apple Body Gradient: #E53935 (0%), #C62828 (60%), #8E0000 (100%)
    final applePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE53935),
          Color(0xFFC62828),
          Color(0xFF8E0000),
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(const Rect.fromLTWH(20, 20, 120, 130))
      ..style = PaintingStyle.fill;
    canvas.drawPath(applePath, applePaint);

    // 4. Subtle Specular Highlight Curve
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final highlightPath = Path()
      ..moveTo(42, 54)
      ..cubicTo(34, 68, 36, 92, 48, 112);
    canvas.drawPath(highlightPath, highlightPaint);

    // 5. Central subtle bazaar / seed accent dot symbolizing "Haat"
    final dotPaint = Paint()
      ..color = const Color(0xFFFFF9C4).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(80, 98), 4.5, dotPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
