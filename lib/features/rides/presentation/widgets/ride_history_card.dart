import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/route_timeline.dart';
import '../../../../core/widgets/secondary_buttons.dart';
import '../../../../core/widgets/tags.dart';
import '../../domain/entities/ride_history.dart';

/// A past trip card on the ride-history screen. Completed trips expose
/// "Rebook" / "Get receipt" actions; cancelled trips do not.
class RideHistoryCard extends StatelessWidget {
  const RideHistoryCard({super.key, required this.ride, this.onRebook});

  final RideHistory ride;
  final VoidCallback? onRebook;

  bool get _completed => ride.status == RideStatus.completed;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ride.dateTime,
                  style: AppTextStyles.caption.copyWith(fontSize: 12)),
              _completed
                  ? const StatusTag.completed(AppStrings.completed)
                  : const StatusTag.cancelled(AppStrings.cancelled),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: RouteTimeline(dotSize: 9),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ride.from, style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      Text(ride.to, style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ride.price,
                        style: AppTextStyles.bodyStrong.copyWith(
                          fontSize: 16,
                          color: _completed ? AppColors.ink : AppColors.textFaint,
                        )),
                    Text(ride.distance,
                        style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
                  ],
                ),
              ],
            ),
          ),
          if (_completed) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SoftButton(
                    label: AppStrings.rebook,
                    onPressed: onRebook,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: OutlineActionButton(
                    label: AppStrings.getReceipt,
                    height: 42,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
