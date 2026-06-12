import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/fare_line.dart';

/// A single line in the fare breakdown. Discounts render in green; the total
/// renders larger with a top divider.
class FareRow extends StatelessWidget {
  const FareRow({super.key, required this.line});

  final FareLine line;

  @override
  Widget build(BuildContext context) {
    if (line.isTotal) {
      return Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.only(top: 13, bottom: 4),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total',
                style: AppTextStyles.bodyStrong.copyWith(fontSize: 15)),
            Text(line.amount,
                style: AppTextStyles.bodyStrong.copyWith(fontSize: 21)),
          ],
        ),
      );
    }

    final valueColor = line.isDiscount ? AppColors.success : AppColors.ink;
    final labelColor =
        line.isDiscount ? AppColors.success : AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(line.label,
              style: AppTextStyles.body.copyWith(
                color: labelColor,
                fontSize: 14,
                fontWeight: line.isDiscount ? FontWeight.w700 : FontWeight.w600,
              )),
          Text(line.amount,
              style: AppTextStyles.listTitle
                  .copyWith(color: valueColor, fontSize: 14)),
        ],
      ),
    );
  }
}
