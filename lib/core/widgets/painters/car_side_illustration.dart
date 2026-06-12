import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// Side-profile car illustration shown on driver cards, transcribed from the
/// design's 132×58 SVG (body, two windows, two wheels and a soft ground
/// shadow). [bodyColor] varies per driver/vehicle.
class CarSideIllustration extends StatelessWidget {
  const CarSideIllustration({
    super.key,
    required this.bodyColor,
    this.width = 124,
    this.windowColor = const Color(0xFFCFE6F2),
  });

  final Color bodyColor;
  final Color windowColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * (50 / 124);
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CarSidePainter(bodyColor: bodyColor, windowColor: windowColor),
      ),
    );
  }
}

class _CarSidePainter extends CustomPainter {
  _CarSidePainter({required this.bodyColor, required this.windowColor});

  final Color bodyColor;
  final Color windowColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Design SVG viewBox is 0 0 132 58.
    final k = size.width / 132.0;
    Offset p(double x, double y) => Offset(x * k, y * k);

    // Ground shadow.
    canvas.drawOval(
      Rect.fromCenter(center: p(66, 52), width: 116 * k, height: 8 * k),
      Paint()..color = AppColors.shadow.withOpacity(0.08),
    );

    final body = Path()
      ..moveTo(6 * k, 40 * k)
      ..cubicTo(6 * k, 36 * k, 9 * k, 34 * k, 14 * k, 33 * k)
      ..lineTo(30 * k, 32 * k)
      ..cubicTo(40 * k, 23 * k, 50 * k, 18 * k, 66 * k, 18 * k)
      ..cubicTo(84 * k, 18 * k, 96 * k, 24 * k, 104 * k, 32 * k)
      ..lineTo(120 * k, 35 * k)
      ..cubicTo(126 * k, 36 * k, 128 * k, 39 * k, 128 * k, 43 * k)
      ..lineTo(128 * k, 46 * k)
      ..cubicTo(128 * k, 48 * k, 126 * k, 49 * k, 124 * k, 49 * k)
      ..lineTo(10 * k, 49 * k)
      ..cubicTo(7 * k, 49 * k, 6 * k, 48 * k, 6 * k, 45 * k)
      ..close();
    canvas.drawPath(body, Paint()..color = bodyColor);

    final winPaint = Paint()..color = windowColor.withOpacity(0.92);
    final win1 = Path()
      ..moveTo(44 * k, 20 * k)
      ..cubicTo(52 * k, 20 * k, 59 * k, 20 * k, 64 * k, 20 * k)
      ..lineTo(62 * k, 32 * k)
      ..lineTo(41 * k, 32 * k)
      ..cubicTo(41 * k, 27 * k, 42 * k, 23 * k, 44 * k, 20 * k)
      ..close();
    final win2 = Path()
      ..moveTo(68 * k, 20 * k)
      ..cubicTo(80 * k, 21 * k, 90 * k, 26 * k, 98 * k, 32 * k)
      ..lineTo(66 * k, 32 * k)
      ..lineTo(66 * k, 20 * k)
      ..close();
    canvas.drawPath(win1, winPaint);
    canvas.drawPath(win2, winPaint);

    final tyre = Paint()..color = const Color(0xFF1B2730);
    final hub = Paint()..color = const Color(0xFF8392A0);
    for (final cx in [38.0, 98.0]) {
      canvas.drawCircle(p(cx, 48), 9.5 * k, tyre);
      canvas.drawCircle(p(cx, 48), 4 * k, hub);
    }
  }

  @override
  bool shouldRepaint(_CarSidePainter old) =>
      old.bodyColor != bodyColor || old.windowColor != windowColor;
}
