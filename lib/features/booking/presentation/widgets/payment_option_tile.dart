import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/payment_method.dart';

/// A selectable payment-method row on the confirm screen, with an icon chip,
/// label/sub and a radio indicator that fills when active.
class PaymentOptionTile extends StatelessWidget {
  const PaymentOptionTile({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (method.type) {
      case PaymentType.wallet:
        return Icons.account_balance_wallet_outlined;
      case PaymentType.card:
        return Icons.credit_card_rounded;
      case PaymentType.cash:
        return Icons.payments_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? AppColors.primaryLight : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryDark : AppColors.peach,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon,
                  size: 20,
                  color: selected ? Colors.white : AppColors.primaryDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.label, style: AppTextStyles.listTitle),
                  Text(method.sub, style: AppTextStyles.caption),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryDark
                      : const Color(0xFFE5DACB),
                  width: 2,
                ),
              ),
              child: selected
                  ? Container(
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryDark,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
