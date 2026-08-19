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
          final rides = state.visibleRides;
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
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    20, 10, 20, AppDimens.bottomNavSafe),
                sliver: SliverList.separated(
                  itemCount: rides.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => RideHistoryCard(
                    ride: rides[i],
                    onRebook: () =>
                        Navigator.pushNamed(context, AppRoutes.search),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
