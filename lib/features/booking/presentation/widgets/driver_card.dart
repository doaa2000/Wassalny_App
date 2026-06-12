import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_avatar.dart';
import '../../../../core/widgets/painters/car_side_illustration.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/rating.dart';
import '../../../../core/widgets/tags.dart';
import '../../domain/entities/driver.dart';
import '../utils/driver_presentation.dart';

/// The full driver option card on the "Choose your driver" screen. Shows the
/// avatar + rating, vehicle, ETA / plate / fare and a select action. The border
/// highlights when this driver is the current selection.
class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.driver,
    required this.selected,
    required this.onSelect,
  });

  final Driver driver;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.surface,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.3),
              blurRadius: 26,
              offset: const Offset(0, 10),
              spreadRadius: -18,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarWithRating(driver: driver),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(driver.name,
                                style: AppTextStyles.bodyStrong),
                          ),
                          StatusTag(
                            label: driver.tag,
                            color: driver.tagColor,
                            background: driver.tagBackground,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('${driver.rides} rides · ${driver.car}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption),
                      const SizedBox(height: 9),
                      CarSideIllustration(bodyColor: driver.carColor),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _Stat(label: 'Arrives', value: '${driver.etaMinutes} min'),
                      const SizedBox(width: 16),
                      Flexible(child: _Stat(label: 'Plate', value: driver.plate)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Est. fare', style: AppTextStyles.caption),
                    Text(driver.price,
                        style: AppTextStyles.bodyStrong.copyWith(fontSize: 19)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 13),
            PrimaryButton(
              label: selected ? 'Select ${driver.firstName}' : 'Choose',
              onPressed: onSelect,
              height: 46,
              glow: false,
              color: selected ? AppColors.primary : AppColors.peach,
              foreground:
                  selected ? AppColors.onPrimary : AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarWithRating extends StatelessWidget {
  const _AvatarWithRating({required this.driver});

  final Driver driver;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GradientAvatar(
            initials: driver.initials,
            gradient: driver.avatarGradient,
            size: 58,
            radius: 18,
            fontSize: 20,
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: RatingPill(rating: driver.rating),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.micro.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
        Text(value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.listTitle.copyWith(fontSize: 14)),
      ],
    );
  }
}
