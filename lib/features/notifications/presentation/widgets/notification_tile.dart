import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/painters/car_mark_icon.dart';
import '../../domain/entities/app_notification.dart';

/// A single notification row: a coloured icon chip, title + body, and an
/// optional unread dot. The icon and colour are derived from the [kind].
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    this.showDivider = true,
  });

  final AppNotification notification;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _icon(),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: AppTextStyles.listTitle),
                const SizedBox(height: 2),
                Text(notification.body,
                    style: AppTextStyles.caption.copyWith(
                        fontSize: 12.5, height: 1.4)),
              ],
            ),
          ),
          if (notification.unread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, left: 8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _icon() {
    late final Color bg;
    late final Widget child;
    switch (notification.kind) {
      case NotificationKind.rideComplete:
        bg = AppColors.peach;
        child = const CarMarkIcon(size: 20, color: AppColors.primary);
        break;
      case NotificationKind.promo:
        bg = AppColors.peachAmber;
        child = const Icon(Icons.card_giftcard_rounded,
            size: 20, color: AppColors.gold);
        break;
      case NotificationKind.topUp:
        bg = AppColors.successBg;
        child = const Icon(Icons.account_balance_wallet_outlined,
            size: 20, color: AppColors.success);
        break;
      case NotificationKind.onTime:
        bg = AppColors.peach;
        child = const Icon(Icons.schedule_rounded,
            size: 20, color: AppColors.primary);
        break;
    }
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(13),
      ),
      child: child,
    );
  }
}
