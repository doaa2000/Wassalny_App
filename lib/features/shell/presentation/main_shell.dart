import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/presentation/pages/home_page.dart';
import '../../notifications/presentation/pages/notifications_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../rides/presentation/pages/rides_page.dart';
import '../../wallet/presentation/pages/wallet_page.dart';
import 'cubit/nav_cubit.dart';
import 'widgets/app_bottom_nav.dart';

/// The authenticated home of the app: an [IndexedStack] of the five primary
/// tabs with a shared bottom navigation bar. A [NavCubit] tracks the active tab
/// so descendants (like the profile menu) can switch tabs.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = [
    HomePage(),
    RidesPage(),
    WalletPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavCubit(),
      child: BlocBuilder<NavCubit, int>(
        builder: (context, index) {
          return Scaffold(
            extendBody: true,
            body: IndexedStack(index: index, children: _pages),
            bottomNavigationBar: AppBottomNav(
              currentIndex: index,
              onTap: (i) => context.read<NavCubit>().go(i),
            ),
          );
        },
      ),
    );
  }
}
