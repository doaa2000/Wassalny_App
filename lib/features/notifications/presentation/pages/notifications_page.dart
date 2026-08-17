import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/section_label.dart';
import '../../domain/entities/app_notification.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_tile.dart';

/// Notifications tab: items grouped into "Today" and "Earlier".
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          final items = state.items;
          final today = items
              .where((n) => n.section == NotificationSection.today)
              .toList();
          final earlier = items
              .where((n) => n.section == NotificationSection.earlier)
              .toList();

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(AppStrings.notifications,
                            style: AppTextStyles.h3),
                      ),
                      Text(AppStrings.markAllRead,
                          style: AppTextStyles.bodySm.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 10, 20, AppDimens.bottomNavSafe),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionLabel(AppStrings.today),
                    const SizedBox(height: 8),
                    _GroupCard(items: today),
                    const SizedBox(height: 20),
                    SectionLabel(AppStrings.earlier),
                    const SizedBox(height: 8),
                    _GroupCard(items: earlier),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.items});

  final List<AppNotification> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.3),
            blurRadius: 26,
            offset: const Offset(0, 10),
            spreadRadius: -20,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            NotificationTile(
              notification: items[i],
              showDivider: i != items.length - 1,
            ),
        ],
      ),
    );
  }
}
