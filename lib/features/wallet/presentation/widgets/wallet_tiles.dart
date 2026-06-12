import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/painters/car_mark_icon.dart';
import '../../domain/entities/wallet_data.dart';

/// A saved payment method row inside the wallet (card / cash) with its brand
/// chip, label, sub-label and an optional "Default" tag.
class WalletCardTile extends StatelessWidget {
  const WalletCardTile({super.key, required this.card, this.showDivider = true});

  final WalletCard card;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          _leading(card.type),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card.title, style: AppTextStyles.listTitle),
                Text(card.subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (card.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.peach,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Default',
                  style: AppTextStyles.micro.copyWith(
                      color: AppColors.primaryDark, fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _leading(WalletCardType type) {
    if (type == WalletCardType.visa) {
      return Container(
        width: 42,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1F71), Color(0xFF3B4DAE)],
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Text('VISA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              fontFamily: AppTextStyles.fontFamily,
            )),
      );
    }
    return Container(
      width: 42,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Icon(Icons.attach_money_rounded,
          size: 18, color: Colors.white),
    );
  }
}

/// "Add a new card" row.
class AddCardTile extends StatelessWidget {
  const AddCardTile({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.peach,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.add_rounded,
                  size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 13),
            Text('Add a new card',
                style: AppTextStyles.listTitle
                    .copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

/// A wallet transaction row (trip debit or top-up credit).
class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({
    super.key,
    required this.txn,
    this.showDivider = true,
  });

  final WalletTransaction txn;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isTopUp = txn.type == WalletTxnType.topUp;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isTopUp ? AppColors.successBg : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: isTopUp
                ? const Icon(Icons.add_rounded,
                    size: 18, color: AppColors.success)
                : const CarMarkIcon(size: 18, color: AppColors.textFaint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.title,
                    style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.ink, fontWeight: FontWeight.w700)),
                Text(txn.date,
                    style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
              ],
            ),
          ),
          Text(txn.amount,
              style: AppTextStyles.bodyStrong.copyWith(
                fontSize: 14,
                color: txn.isCredit ? AppColors.success : AppColors.ink,
              )),
        ],
      ),
    );
  }
}
