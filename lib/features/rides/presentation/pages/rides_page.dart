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
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<RidesBloc, RidesState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(AppStrings.yourRides, style: AppTextStyles.h3),
                  ),
                ),
                Padding(
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
                Expanded(child: _buildContent(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Returns the widget for the current loading/error/empty/data state. The
  /// title and filter chips above are outside this scrollable area entirely,
  /// so they stay put no matter how far the list scrolls.
  Widget _buildContent(BuildContext context, RidesState state) {
    if (state.status == RidesStatus.loading || state.status == RidesStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == RidesStatus.failure) {
      return Center(
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
      );
    }

    final rides = state.visibleRides;

    if (rides.isEmpty) {
      return Center(
        child: Text('لا توجد رحلات بعد', style: AppTextStyles.h3),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, AppDimens.bottomNavSafe),
      itemCount: rides.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => RideHistoryCard(
        ride: rides[i],
        onRebook: () => Navigator.pushNamed(context, AppRoutes.search),
      ),
    );
  }
}