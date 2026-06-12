import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_shadows.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/route_timeline.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../home/presentation/widgets/quick_place_card.dart';
import '../widgets/place_list_tile.dart';

/// "Plan your ride": choose pickup and destination from saved/recent places.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  void _goDrivers(BuildContext context) =>
      Navigator.pushReplacementNamed(context, AppRoutes.drivers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _Header(onBack: () => Navigator.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: QuickPlaceCard(
                          icon: Icons.home_rounded,
                          title: 'Home',
                          subtitle: 'Maadi, Rd 9',
                          onTap: () => _goDrivers(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: QuickPlaceCard(
                          icon: Icons.work_outline_rounded,
                          title: 'Work',
                          subtitle: 'Smart Village',
                          onTap: () => _goDrivers(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 4),
                  child: SectionLabel(AppStrings.recent),
                ),
                PlaceListTile(
                  icon: Icons.access_time_rounded,
                  title: 'Cairo Festival City',
                  subtitle: 'New Cairo · 14.2 km',
                  onTap: () => _goDrivers(context),
                ),
                PlaceListTile(
                  icon: Icons.access_time_rounded,
                  title: 'Cairo University',
                  subtitle: 'Giza · 6.8 km',
                  onTap: () => _goDrivers(context),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 18, bottom: 4),
                  child: SectionLabel(AppStrings.savedPlaces),
                ),
                PlaceListTile(
                  icon: Icons.star_rounded,
                  iconColor: AppColors.primary,
                  iconBg: AppColors.peach,
                  title: 'The Gym — Zamalek',
                  subtitle: '26 July St · 9.1 km',
                  onTap: () => _goDrivers(context),
                ),
                PlaceListTile(
                  icon: Icons.star_rounded,
                  iconColor: AppColors.primary,
                  iconBg: AppColors.peach,
                  title: "Mom's House — Heliopolis",
                  subtitle: 'El-Higaz St · 11.7 km',
                  showDivider: false,
                  onTap: () => _goDrivers(context),
                ),
              ],
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.floating,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
          child: Column(
            children: [
              Row(
                children: [
                  RoundIconButton.back(onPressed: onBack),
                  const SizedBox(width: 12),
                  Text(AppStrings.planYourRide, style: AppTextStyles.titleSm),
                ],
              ),
              const SizedBox(height: 16),
              const IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      child: RouteTimeline(dotSize: 11),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _FieldBox(
                            value: 'Tahrir Square, Cairo',
                            highlighted: false,
                          ),
                          SizedBox(height: 10),
                          _FieldBox(
                            value: 'Cairo Festival City',
                            highlighted: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({required this.value, required this.highlighted});

  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: highlighted ? AppColors.peach : AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: highlighted
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
      ),
      child: Text(
        value,
        style: AppTextStyles.input.copyWith(
          fontSize: 14.5,
          fontWeight: highlighted ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}
