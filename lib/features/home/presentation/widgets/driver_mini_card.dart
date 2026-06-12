import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_avatar.dart';
import '../../../booking/domain/entities/driver.dart';
import '../../../booking/presentation/utils/driver_presentation.dart';

/// The small "Drivers near you" card on the home sheet — a horizontal carousel
/// item showing the driver's avatar, first name, rating, ETA and price.
class DriverMiniCard extends StatelessWidget {
  const DriverMiniCard({super.key, required this.driver, this.onTap});

  final Driver driver;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 172,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -14,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GradientAvatar(
                  initials: driver.initials,
                  gradient: driver.avatarGradient,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(driver.firstName,
                          style: AppTextStyles.bodySm
                              .copyWith(color: AppColors.ink, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 12, color: AppColors.gold),
                          const SizedBox(width: 3),
                          Text(driver.rating,
                              style: AppTextStyles.micro.copyWith(fontSize: 11.5)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('${driver.etaMinutes} min',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary, fontSize: 11.5)),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(driver.price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 15)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
