import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/tags.dart';
import '../cubit/booking_cubit.dart';
import '../widgets/driver_card.dart';

/// "Choose your driver": filter chips + the list of available drivers.
class DriverSelectPage extends StatelessWidget {
  const DriverSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Header(onBack: () => Navigator.pop(context)),
          Expanded(
            child: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                  itemCount: state.drivers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 13),
                  itemBuilder: (context, i) {
                    final driver = state.drivers[i];
                    return DriverCard(
                      driver: driver,
                      selected: i == state.selectedDriverIndex,
                      onSelect: () {
                        context.read<BookingCubit>().selectDriver(i);
                        Navigator.pushNamed(context, AppRoutes.confirm);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RoundIconButton.back(onPressed: onBack),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.chooseDriver,
                            style: AppTextStyles.titleSm),
                        Text(AppStrings.tripRoute,
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 34,
                child: BlocBuilder<BookingCubit, BookingState>(
                  buildWhen: (a, b) => a.filter != b.filter,
                  builder: (context, state) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: RideFilter.values.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final filter = RideFilter.values[i];
                        return SelectableChip(
                          label: filter.label,
                          selected: state.filter == filter,
                          onTap: () =>
                              context.read<BookingCubit>().setFilter(filter),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
