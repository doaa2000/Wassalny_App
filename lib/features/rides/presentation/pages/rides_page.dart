import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/tags.dart';
import '../bloc/rides_bloc.dart';
import '../widgets/ride_history_card.dart';

/// Ride-history tab: filter tabs + the list of past trips.
class RidesPage extends StatelessWidget {
  const RidesPage({super.key});

  static Map<RidesFilter, String> get _filters => {
    RidesFilter.all: AppStrings.all,
    RidesFilter.completed: AppStrings.completed,
    RidesFilter.cancelled: AppStrings.cancelled,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<RidesBloc, RidesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                bottom: false,
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
                    child: Text(AppStrings.yourRides, style: AppTextStyles.h3),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        for (final entry in _filters.entries) ...[
                          SelectableChip(
                            label: entry.value,
                            selected: state.filter == entry.key,
                            restingColor: AppColors.surface,
                            onTap: () =>
                                context.read<RidesBloc>().add(RidesFilterChanged(entry.key)),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              ..._buildContentSlivers(context, state),
            ],
          );
        },
      ),
    );
  }

  /// Returns the sliver(s) for the current loading/error/empty/data state,
  /// so the filter tabs above stay visible no matter what's happening below.
  List<Widget> _buildContentSlivers(BuildContext context, RidesState state) {
    if (state.status == RidesStatus.loading || state.status == RidesStatus.initial) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (state.status == RidesStatus.failure) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage ?? 'حدث خطأ ما',
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        context.read<RidesBloc>().add(const RidesRequested()),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    final rides = state.visibleRides;

    if (rides.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text('لا توجد رحلات بعد', style: AppTextStyles.h3),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, AppDimens.bottomNavSafe),
        sliver: SliverList.separated(
          itemCount: rides.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => RideHistoryCard(
            ride: rides[i],
            onRebook: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
        ),
      ),
    ];
  }
}