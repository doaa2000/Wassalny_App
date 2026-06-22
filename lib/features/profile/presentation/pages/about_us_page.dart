import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/round_icon_button.dart';

/// "About us": a short description of Wassalny and contact details.
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Row(
              children: [
                RoundIconButton.back(onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 12),
                Text(AppStrings.aboutUs, style: AppTextStyles.titleSm),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(Icons.local_taxi_rounded,
                    color: Colors.white, size: 42),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(AppStrings.appName,
                  style: AppTextStyles.title.copyWith(fontSize: 22)),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(AppStrings.appVersion,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textTertiary)),
            ),
            const SizedBox(height: 26),
            _Card(
              child: Text(
                AppStrings.aboutDescription,
                style: AppTextStyles.body.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: 14),
            const _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(icon: Icons.email_outlined, label: 'support@wassalny.app'),
                  SizedBox(height: 14),
                  _InfoRow(icon: Icons.public_rounded, label: 'www.wassalny.app'),
                  SizedBox(height: 14),
                  _InfoRow(icon: Icons.place_outlined, label: 'Cairo, Egypt'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: Text(AppStrings.aboutRights,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.disabled, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.peach,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 19, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
