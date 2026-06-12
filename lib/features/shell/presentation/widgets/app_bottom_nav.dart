import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single bottom-nav destination.
class NavDestination {
  const NavDestination(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// The app's custom bottom navigation bar: a white bar with five icon+label
/// items, the active one tinted terracotta.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    NavDestination(AppStrings.navHome, Icons.home_outlined),
    NavDestination(AppStrings.navRides, Icons.receipt_long_outlined),
    NavDestination(AppStrings.navWallet, Icons.account_balance_wallet_outlined),
    NavDestination(AppStrings.navAlerts, Icons.notifications_none_rounded),
    NavDestination(AppStrings.navProfile, Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderSoft)),
        boxShadow: [
          BoxShadow(
            color: Color(0x140F1A24),
            blurRadius: 30,
            offset: Offset(0, -8),
            spreadRadius: -12,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < _items.length; i++)
                _NavButton(
                  item: _items[i],
                  active: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NavDestination item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textFaint;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 23, color: color),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(
                  fontSize: 10.5,
                  color: color,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
