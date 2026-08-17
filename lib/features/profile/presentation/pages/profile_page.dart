import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/language_sheet.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/rate_app_sheet.dart';

/// Profile tab: rider header + grouped settings menu.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _ProfileHeader(),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(20, 18, 20, AppDimens.bottomNavSafe),
            child: Column(
              children: [
                _MenuGroup(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      label: AppStrings.personalInfo,
                    ),
                    ProfileMenuItem(
                      icon: Icons.location_on_outlined,
                      label: AppStrings.savedLocations,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.savedPlaces),
                    ),
                    ProfileMenuItem(
                      icon: Icons.language_rounded,
                      label: AppStrings.language,
                      trailingValue: AppStrings.languageValue,
                      showDivider: false,
                      onTap: () => showLanguageSheet(context),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _MenuGroup(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      label: AppStrings.helpSupport,
                      iconBg: AppColors.background,
                      iconColor: AppColors.textSecondary,
                    ),
                    ProfileMenuItem(
                      icon: Icons.star_outline_rounded,
                      label: AppStrings.rateApp,
                      onTap: () => showRateAppSheet(context),
                    ),
                    ProfileMenuItem(
                      icon: Icons.info_outline_rounded,
                      label: AppStrings.aboutUs,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.about),
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      label: AppStrings.logout,
                      iconBg: AppColors.dangerBg,
                      iconColor: AppColors.danger,
                      destructive: true,
                      showDivider: false,
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthLogoutRequested());
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.welcome, (route) => false);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(AppStrings.appVersion,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.disabled, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -22,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child:
                    Text('LM', style: AppTextStyles.h3.copyWith(fontSize: 24)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.riderName,
                        style: AppTextStyles.titleSm.copyWith(fontSize: 19)),
                    Text(AppStrings.riderPhone,
                        style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.textTertiary, fontSize: 13)),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 12, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(AppStrings.riderTag,
                              style:
                                  AppTextStyles.micro.copyWith(fontSize: 11.5)),
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

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Column(children: children),
    );
  }
}
