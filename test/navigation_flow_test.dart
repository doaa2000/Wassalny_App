// Navigation smoke test: walks the main user journeys to confirm every screen
// builds and renders without throwing (including the animated map view).
//
// Pages with looping animations (map, "finding driver") are advanced with
// explicit `pump(duration)` calls rather than `pumpAndSettle`, which would
// never settle. A phone-sized surface is used so the mobile layouts fit and
// controls remain on-screen / tappable.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wassalny/main.dart';

Future<void> _settleish(WidgetTester tester) async {
  await tester.pump(); // process the navigation / state change
  await tester.pump(const Duration(milliseconds: 500)); // advance transitions
}

void _usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('onboarding → auth → main shell tabs', (tester) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(const WassalnyApp());
    await tester.pump();

    await tester.tap(find.text('Get started'));
    await _settleish(tester);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await _settleish(tester);
    expect(find.text('Enable your location'), findsOneWidget);

    await tester.tap(find.text('Allow location access'));
    await _settleish(tester);
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.tap(find.text('Log in'));
    await _settleish(tester);
    expect(find.text('Good evening, Layla'), findsOneWidget);

    // Cycle through every bottom-nav tab.
    await tester.tap(find.text('Rides'));
    await _settleish(tester);
    expect(find.text('Your rides'), findsOneWidget);

    await tester.tap(find.text('Wallet'));
    await _settleish(tester);
    expect(find.text('Available balance'), findsOneWidget);

    await tester.tap(find.text('Alerts'));
    await _settleish(tester);
    expect(find.text('Mark all read'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await _settleish(tester);
    expect(find.text('Layla Mansour'), findsOneWidget);
  });

  testWidgets('booking flow: home → drivers → confirm', (tester) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(const WassalnyApp());
    await tester.pump();

    // Enter the app through the onboarding path.
    await tester.tap(find.text('Get started'));
    await _settleish(tester);
    await tester.tap(find.text('Continue'));
    await _settleish(tester);
    await tester.tap(find.text('Allow location access'));
    await _settleish(tester);
    await tester.tap(find.text('Log in'));
    await _settleish(tester);
    expect(find.text('Good evening, Layla'), findsOneWidget);

    await tester.tap(find.text('Compare all'));
    await _settleish(tester);
    expect(find.text('Choose your driver'), findsOneWidget);

    await tester.tap(find.text('Choose').first);
    await _settleish(tester);
    expect(find.text('Confirm your ride'), findsOneWidget);
    expect(find.text('Fare breakdown'), findsOneWidget);
  });
}
