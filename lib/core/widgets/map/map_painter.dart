import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'map_geometry.dart';

/// Paints the static stylized map: base, city blocks, parks, avenues, the
/// grid of roads, the Nile and its bridges, plus the optional trip route.
///
/// The host passes a cover [scale] and [dx]/[dy] offset so the 390×700 design
/// view-box fills the container.
class MapBasePainter extends CustomPainter {
  MapBasePainter({
    required this.scale,
    required this.dx,
    required this.dy,
    required this.showRoute,
    required this.dashPhase,
  });

  final double scale;
  final double dx;
  final double dy;
  final bool showRoute;
  final double dashPhase;

  Offset _m(double x, double y) => Offset(x * scale + dx, y * scale + dy);
  Rect _rect(double x, double y, double w, double h) =>
      Rect.fromLTWH(x * scale + dx, y * scale + dy, w * scale, h * scale);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final fill = Paint()..style = PaintingStyle.fill;

    // Base.
    canvas.drawRect(Offset.zero & size, fill..color = MapGeometry.base);

    // City blocks.
    for (final b in MapGeometry.blocks) {
      fill.color = MapGeometry.tones[b[4].toInt()];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          _rect(b[0], b[1], b[2], b[3]),
          Radius.circular(7 * scale),
        ),
        fill,
      );
    }

    // Parks.
    fill.color = MapGeometry.park;
    canvas.drawRRect(
      RRect.fromRectAndRadius(_rect(70, 206, 48, 78), Radius.circular(9 * scale)),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(_rect(142, 438, 44, 70), Radius.circular(9 * scale)),
      fill,
    );
    canvas.drawCircle(_m(40, 612), 26 * scale, fill);

    // Diagonal avenues.
    final avenue = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = MapGeometry.avenue
      ..strokeWidth = 11 * scale;
    canvas.drawLine(_m(-10, 268), _m(400, 116), avenue);
    avenue
      ..color = MapGeometry.avenueSoft
      ..strokeWidth = 6 * scale;
    canvas.drawLine(_m(-10, 268), _m(400, 116), avenue);
    avenue
      ..color = MapGeometry.avenue
      ..strokeWidth = 9 * scale;
    canvas.drawLine(_m(-10, 580), _m(260, 430), avenue);

    // Roads grid.
    fill.color = MapGeometry.road;
    for (final r in MapGeometry.roads) {
      canvas.drawRect(_rect(r[0], r[1], r[2], r[3]), fill);
    }

    // Nile.
    final nile = Path()
      ..moveTo(_m(236, -10).dx, _m(236, -10).dy)
      ..cubicTo(_m(262, 120).dx, _m(262, 120).dy, _m(232, 210).dx,
          _m(232, 210).dy, _m(252, 330).dx, _m(252, 330).dy)
      ..cubicTo(_m(270, 446).dx, _m(270, 446).dy, _m(240, 560).dx,
          _m(240, 560).dy, _m(260, 710).dx, _m(260, 710).dy)
      ..lineTo(_m(400, 710).dx, _m(400, 710).dy)
      ..lineTo(_m(400, -10).dx, _m(400, -10).dy)
      ..close();
    canvas.drawPath(nile, fill..color = MapGeometry.water);

    final waterEdge = Path()
      ..moveTo(_m(236, -10).dx, _m(236, -10).dy)
      ..cubicTo(_m(262, 120).dx, _m(262, 120).dy, _m(232, 210).dx,
          _m(232, 210).dy, _m(252, 330).dx, _m(252, 330).dy)
      ..cubicTo(_m(270, 446).dx, _m(270, 446).dy, _m(240, 560).dx,
          _m(240, 560).dy, _m(260, 710).dx, _m(260, 710).dy);
    canvas.drawPath(
      waterEdge,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale
        ..color = MapGeometry.waterStroke,
    );

    // Bridges.
    fill.color = MapGeometry.bridge;
    canvas.drawRect(_rect(232, 294, 120, 11), fill);
    canvas.drawRect(_rect(244, 516, 116, 10), fill);

    // Vignette.
    final vignette = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.45, size.height * 0.42),
        size.longestSide * 0.8,
        [Colors.white.withOpacity(0.25), AppColors.shadow.withOpacity(0.06)],
      );
    canvas.drawRect(Offset.zero & size, vignette);

    if (showRoute) _paintRoute(canvas);
  }

  void _paintRoute(Canvas canvas) {
    final route = routePath();
    canvas.drawPath(
      route,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 7 * scale
        ..color = AppColors.primary.withOpacity(0.3),
    );

    // Marching-ant dashes for the active route line.
    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4 * scale
      ..color = AppColors.primaryDark;
    final dashLen = 2 * scale;
    final gapLen = 12 * scale;
    for (final metric in route.computeMetrics()) {
      double pos = -(dashPhase * (dashLen + gapLen));
      while (pos < metric.length) {
        final start = pos.clamp(0, metric.length).toDouble();
        final end = (pos + dashLen).clamp(0, metric.length).toDouble();
        if (end > start) {
          canvas.drawPath(metric.extractPath(start, end), dash);
        }
        pos += dashLen + gapLen;
      }
    }
  }

  /// The trip route as a [Path] in screen space (also used to drive the moving
  /// car marker on the tracking screen).
  Path routePath() => Path()
    ..moveTo(_m(96, 168).dx, _m(96, 168).dy)
    ..cubicTo(_m(150, 240).dx, _m(150, 240).dy, _m(120, 360).dx,
        _m(120, 360).dy, _m(186, 410).dx, _m(186, 410).dy)
    ..cubicTo(_m(250, 458).dx, _m(250, 458).dy, _m(250, 540).dx,
        _m(250, 540).dy, _m(300, 556).dx, _m(300, 556).dy);

  @override
  bool shouldRepaint(MapBasePainter oldDelegate) =>
      oldDelegate.scale != scale ||
      oldDelegate.dx != dx ||
      oldDelegate.dy != dy ||
      oldDelegate.showRoute != showRoute ||
      oldDelegate.dashPhase != dashPhase;
}
