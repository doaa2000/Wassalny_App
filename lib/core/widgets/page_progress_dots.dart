import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// The small progress indicator on the welcome / onboarding screens: the active
/// step is a wide terracotta bar, the others are short neutral pills.
class PageProgressDots extends StatelessWidget {
  const PageProgressDots({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return Padding(
          padding: const EdgeInsets.only(right: 7),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: active ? 24 : 7,
            height: 5,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : const Color(0xFFE5DACB),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
