import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/bobbing.dart';
import '../../../../core/widgets/painters/car_mark_icon.dart';
import '../bloc/booking_bloc.dart';

/// "Finding your driver": a radar animation that automatically advances to the
/// assigned screen, matching the design's timed prototype.
class FindingDriverPage extends StatefulWidget {
  const FindingDriverPage({super.key});

  @override
  State<FindingDriverPage> createState() => _FindingDriverPageState();
}

class _FindingDriverPageState extends State<FindingDriverPage>
    with TickerProviderStateMixin {
  late final AnimationController _radar = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();
  StreamSubscription<BookingState>? _statusSub;

  @override
  void initState() {
    super.initState();
    // Advance to "Driver assigned" the moment a captain accepts the trip
    // (real status from Supabase Realtime; simulated in UI-only mode).
    _statusSub = context.read<BookingBloc>().stream.listen((state) {
      if (mounted && state.tripStatus.isNotEmpty && state.tripStatus != 'requested') {
        _statusSub?.cancel();
        Navigator.pushReplacementNamed(context, AppRoutes.assigned);
      }
    });
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _radar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -40, left: -40, child: _circle(200)),
            Positioned(bottom: -30, right: -30, child: _circle(160)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _radarRing(0),
                        _radarRing(0.5),
                        Bobbing(
                          distance: 6,
                          duration: const Duration(seconds: 3),
                          child: Container(
                            width: 106,
                            height: 106,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(34),
                            ),
                            alignment: Alignment.center,
                            child: const CarMarkIcon(
                              size: 58,
                              color: Colors.white,
                              wheels: true,
                              wheelColor: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(AppStrings.findingDriver,
                      style: AppTextStyles.h3.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.findingSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body
                        .copyWith(color: Colors.white.withOpacity(0.85)),
                  ),
                  const SizedBox(height: 22),
                  _PulsingDots(controller: _radar),
                ],
              ),
            ),
            Positioned(
              left: 30,
              right: 30,
              bottom: 40,
              child: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(AppStrings.cancel,
                        style: AppTextStyles.button
                            .copyWith(fontSize: 15, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
        ),
      );

  Widget _radarRing(double offset) {
    return AnimatedBuilder(
      animation: _radar,
      builder: (_, __) {
        final t = (_radar.value + offset) % 1.0;
        final scale = 0.3 + t * (2.4 - 0.3);
        final opacity = (0.6 * (1 - t)).clamp(0.0, 1.0);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.25 * opacity / 0.6),
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PulsingDots extends StatelessWidget {
  const _PulsingDots({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final t = (controller.value * 2 + i * 0.18) % 1.0;
            final wave = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: 0.3 + 0.7 * wave,
                child: Transform.scale(
                  scale: 0.8 + 0.2 * wave,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
