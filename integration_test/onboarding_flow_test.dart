import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:wassalny/core/constants/app_strings.dart';
import 'package:wassalny/core/widgets/primary_button.dart';

import 'test_app.dart' as app;

/// Walks the real, unauthenticated first-run flow: Welcome -> Onboarding ->
/// Location permission -> Login. No test account needed — this only checks
/// that the screens themselves render and the taps navigate correctly.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app launches, then walks welcome -> onboarding -> location -> login',
      (tester) async {
    await app.testMain();
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);

    // Welcome screen: primary CTA starts onboarding. Tap the whole button
    // (not just its Text) — a bigger, more reliable hit-test target.
    expect(find.text(AppStrings.welcomeTitle), findsOneWidget);
    await tester.tap(find.widgetWithText(PrimaryButton, AppStrings.getStarted));
    await tester.pumpAndSettle();

    // Onboarding intro: "Continue" advances to the location screen.
    final Finder continueButton =
        find.widgetWithText(PrimaryButton, AppStrings.continueLabel);
    expect(continueButton, findsOneWidget);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // Location permission screen — either button leads to login; we don't
    // need to grant a real OS permission for this navigation to work.
    final Finder locationCta =
        find.widgetWithText(PrimaryButton, AppStrings.allowLocation);
    expect(locationCta, findsOneWidget);
    await tester.tap(locationCta);
    await tester.pumpAndSettle();

    // Landed on the real login screen.
    expect(find.text('Email'), findsOneWidget);
    expect(find.text(AppStrings.password), findsOneWidget);
  });
}
