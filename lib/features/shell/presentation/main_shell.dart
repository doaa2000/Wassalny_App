import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/presentation/pages/home_page.dart';
import '../../notifications/presentation/pages/notifications_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../rides/presentation/pages/rides_page.dart';
import 'bloc/nav_bloc.dart';
import 'widgets/app_bottom_nav.dart';

/// The authenticated home of the app: an [IndexedStack] of the primary tabs
/// with a shared bottom navigation bar. A [NavBloc] tracks the active tab so
/// descendants (like the profile menu) can switch tabs.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = [
    HomePage(),
    RidesPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavBloc(),
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          final int index = state.index;

          return PopScope(
            // The shell is the root of the authenticated app — there should
            // be nothing behind it to pop back into (login/onboarding are
            // cleared from the stack on sign-in). This guards against ever
            // landing back on a pre-auth screen from here regardless of how
            // the shell was reached: back first returns to the Home tab if
            // the rider is elsewhere, then exits the app on a second press.
            canPop: false,
            onPopInvokedWithPop: (didPop, result) {
              if (didPop) return;
              if (index != 0) {
                context.read<NavBloc>().add(const NavTabSelected(0));
              } else {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              extendBody: true,
              body: IndexedStack(
                index: index,
                children: _pages,
              ),
              bottomNavigationBar: AppBottomNav(
                currentIndex: index,
                onTap: (i) => context.read<NavBloc>().add(NavTabSelected(i)),
              ),
            ),
          );
        },
      ),
    );
  }
}
