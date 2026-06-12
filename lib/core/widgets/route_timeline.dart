import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// The pickup → drop-off indicator: a green origin dot, a connecting line, and
/// a square terracotta destination marker. Used on the search, confirm and
/// history screens. Expands to fill the available height.
class RouteTimeline extends StatelessWidget {
  const RouteTimeline({
    super.key,
    this.dotSize = 10,
    this.topPadding = 0,
  });

  final double dotSize;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dotSize,
            height: dotSize,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: AppColors.border,
            ),
          ),
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}
