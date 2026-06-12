import 'package:flutter/material.dart';

/// The Wassalny "car" brand glyph, transcribed from the design's 24×24 SVG path.
///
/// Used for the logo mark, map car markers and trip transaction icons. Set
/// [wheels] to draw the two contrasting wheel dots (the full logo treatment).
class CarMarkIcon extends StatelessWidget {
  const CarMarkIcon({
    super.key,
    required this.size,
    required this.color,
    this.wheelColor,
    this.wheels = false,
  });

  final double size;
  final Color color;
  final Color? wheelColor;
  final bool wheels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CarMarkPainter(
          color: color,
          wheelColor: wheelColor ?? Colors.white,
          wheels: wheels,
        ),
      ),
    );
  }
}

class _CarMarkPainter extends CustomPainter {
  _CarMarkPainter({
    required this.color,
    required this.wheelColor,
    required this.wheels,
  });

  final Color color;
  final Color wheelColor;
  final bool wheels;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 24.0;
    Offset p(double x, double y) => Offset(x * k, y * k);
    final r24 = Radius.circular(2.4 * k);
    final r1 = Radius.circular(1 * k);

    final body = Path()
      ..moveTo(3 * k, 13 * k)
      ..lineTo(4.6 * k, 8.4 * k)
      ..arcToPoint(p(6.9, 7), radius: r24)
      ..lineTo(17.1 * k, 7 * k)
      ..arcToPoint(p(19.4, 8.4), radius: r24)
      ..lineTo(21 * k, 13 * k)
      ..lineTo(21 * k, 17.4 * k)
      ..arcToPoint(p(20, 18.4), radius: r1)
      ..lineTo(18.8 * k, 18.4 * k)
      ..arcToPoint(p(17.8, 17.4), radius: r1)
      ..lineTo(17.8 * k, 17 * k)
      ..lineTo(6.2 * k, 17 * k)
      ..lineTo(6.2 * k, 17.4 * k)
      ..arcToPoint(p(5.2, 18.4), radius: r1)
      ..lineTo(4 * k, 18.4 * k)
      ..arcToPoint(p(3, 17.4), radius: r1)
      ..close();

    canvas.drawPath(body, Paint()..color = color);

    if (wheels) {
      final wheelPaint = Paint()..color = wheelColor;
      canvas.drawCircle(p(7.4, 16.6), 1.9 * k, wheelPaint);
      canvas.drawCircle(p(16.6, 16.6), 1.9 * k, wheelPaint);
    }
  }

  @override
  bool shouldRepaint(_CarMarkPainter old) =>
      old.color != color || old.wheelColor != wheelColor || old.wheels != wheels;
}
