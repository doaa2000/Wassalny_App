import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The Egypt flag + "+20" dialing-code prefix shown inside the phone field.
class PhonePrefix extends StatelessWidget {
  const PhonePrefix({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE5DACB))),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: const SizedBox(
              width: 20,
              height: 14,
              child: Column(
                children: [
                  Expanded(child: ColoredBox(color: AppColors.flagRed)),
                  Expanded(child: ColoredBox(color: Colors.white)),
                  Expanded(child: ColoredBox(color: Colors.black)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text('+20', style: AppTextStyles.listTitle.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
