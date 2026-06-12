// Basic smoke test for the Wassalny app.
//
// Verifies the app boots to the welcome screen and shows the primary CTA.

import 'package:flutter_test/flutter_test.dart';

import 'package:wassalny/main.dart';

void main() {
  testWidgets('Welcome screen renders the get-started CTA',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WassalnyApp());
    await tester.pump();

    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });
}
