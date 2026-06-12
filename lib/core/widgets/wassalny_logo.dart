import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'painters/car_mark_icon.dart';

/// The Wassalny logo mark: a rounded square in the brand colour containing the
/// white car glyph. [size] is the square side; the car scales with it.
class WassalnyLogo extends StatelessWidget {
  const WassalnyLogo({
    super.key,
    this.size = 26,
    this.background = AppColors.primary,
    this.carColor = AppColors.onPrimary,
    this.radius = 8,
    this.wheels = false,
    this.wheelColor,
  });

  final double size;
  final Color background;
  final Color carColor;
  final double radius;
  final bool wheels;
  final Color? wheelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: CarMarkIcon(
        size: size * 0.62,
        color: carColor,
        wheels: wheels,
        wheelColor: wheelColor,
      ),
    );
  }
}
