import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../painters/car_mark_icon.dart';
import 'map_geometry.dart';
import 'map_painter.dart';

/// Display modes for [MapView], mirroring the design component variants.
enum MapVariant {
  /// Home screen: nearby taxis + the user's location.
  idle,

  /// Confirm / driver-assigned: the planned route with pickup & drop-off pins.
  route,

  /// Live tracking: the route plus a car driving along it.
  tracking,
}

/// The stylized Cairo map used across the booking flow. Combines a painted base
/// ([MapBasePainter]) with animated marker overlays positioned via the same
/// cover transform.
class MapView extends StatefulWidget {
  const MapView({super.key, this.variant = MapVariant.idle});

  final MapVariant variant;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  late final AnimationController _ambient; // dashes, taxi bob, pulse
  late final AnimationController _drive; // car along the route

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _drive = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ambient.dispose();
    _drive.dispose();
    super.dispose();
  }

  bool get _showRoute => widget.variant != MapVariant.idle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final scale = math.max(w / MapGeometry.viewBox.width,
            h / MapGeometry.viewBox.height);
        final dx = (w - MapGeometry.viewBox.width * scale) / 2;
        const dy = 0.0; // align the crop to the top so routes stay visible.

        Offset map(Offset p) => Offset(p.dx * scale + dx, p.dy * scale + dy);

        return ClipRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _ambient,
                  builder: (_, __) => CustomPaint(
                    painter: MapBasePainter(
                      scale: scale,
                      dx: dx,
                      dy: dy,
                      showRoute: _showRoute,
                      dashPhase: _ambient.value,
                    ),
                  ),
                ),
              ),
              if (widget.variant == MapVariant.idle) ...[
                ..._buildTaxis(map),
                _buildUserDot(map),
              ],
              if (_showRoute) ...[
                _buildPickupPin(map),
                _buildDropoffPin(map),
              ],
              if (widget.variant == MapVariant.tracking)
                _buildMovingCar(scale, dx, dy),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildTaxis(Offset Function(Offset) map) {
    return [
      for (final t in MapGeometry.taxis)
        AnimatedBuilder(
          animation: _ambient,
          builder: (_, child) {
            final bob = math.sin(_ambient.value * 2 * math.pi) * 3;
            final pos = map(Offset(t[0], t[1]));
            return Positioned(
              left: pos.dx - 15,
              top: pos.dy - 15 + bob,
              child: Transform.rotate(
                angle: t[2] * math.pi / 180,
                child: child,
              ),
            );
          },
          child: _TaxiMarker(),
        ),
    ];
  }

  Widget _buildUserDot(Offset Function(Offset) map) {
    final pos = map(MapGeometry.user);
    return AnimatedBuilder(
      animation: _ambient,
      builder: (_, __) {
        final p = _ambient.value;
        final haloScale = 0.6 + p * 2.0;
        final haloOpacity = (0.55 * (1 - p)).clamp(0.0, 1.0);
        return Positioned(
          left: pos.dx - 27,
          top: pos.dy - 27,
          child: SizedBox(
            width: 54,
            height: 54,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: haloScale,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(haloOpacity * 0.7),
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(color: MapGeometry.pinBorder, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickupPin(Offset Function(Offset) map) {
    final pos = map(MapGeometry.pickup);
    return Positioned(
      left: pos.dx - 9,
      top: pos.dy - 18,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MapGeometry.pinFill,
          border: Border.all(color: MapGeometry.pinBorder, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropoffPin(Offset Function(Offset) map) {
    final pos = map(MapGeometry.dropoff);
    return Positioned(
      left: pos.dx - 17,
      top: pos.dy - 41,
      child: const _DestinationPin(),
    );
  }

  Widget _buildMovingCar(double scale, double dx, double dy) {
    final route = MapBasePainter(
      scale: scale,
      dx: dx,
      dy: dy,
      showRoute: true,
      dashPhase: 0,
    ).routePath();
    final metric = route.computeMetrics().first;
    return AnimatedBuilder(
      animation: _drive,
      builder: (_, __) {
        final fraction = 0.08 + _drive.value * (0.86 - 0.08);
        final tangent = metric.getTangentForOffset(metric.length * fraction);
        final pos = tangent?.position ?? Offset.zero;
        return Positioned(
          left: pos.dx - 19,
          top: pos.dy - 19,
          child: const _MovingCarMarker(),
        );
      },
    );
  }
}

class _TaxiMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MapGeometry.taxiBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const CarMarkIcon(size: 18, color: MapGeometry.taxiIcon),
    );
  }
}

class _MovingCarMarker extends StatelessWidget {
  const _MovingCarMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: MapGeometry.pinBorder, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const CarMarkIcon(size: 20, color: MapGeometry.pinBorder),
    );
  }
}

class _DestinationPin extends StatelessWidget {
  const _DestinationPin();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 42,
      child: CustomPaint(painter: _DestinationPinPainter()),
    );
  }
}

class _DestinationPinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(17, 41)
      ..cubicTo(17, 41, 31, 26, 31, 16)
      ..arcToPoint(const Offset(3, 16),
          radius: const Radius.circular(14), largeArc: true, clockwise: true)
      ..cubicTo(3, 26, 17, 41, 17, 41)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.primary);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = MapGeometry.pinBorder,
    );
    canvas.drawCircle(const Offset(17, 16), 5, Paint()..color = MapGeometry.pinBorder);
  }

  @override
  bool shouldRepaint(_DestinationPinPainter old) => false;
}
