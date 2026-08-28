import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';

import 'package:wassalny/core/constants/app_strings.dart';
import 'package:wassalny/core/navigation/app_navigator.dart';
import 'package:wassalny/core/router/app_routes.dart';
import 'package:wassalny/features/booking/presentation/bloc/booking_bloc.dart';

import 'test_app.dart' as app;

/// Drives the real booking flow end to end, using the app's own anonymous
/// "guest checkout" session (the same one a real guest gets automatically —
/// no test account or password needed).
///
/// Trade-off, stated honestly: picking pickup/destination normally happens
/// by dragging a pin on a real Google Map, which is unreliable to drive
/// precisely inside an automated test (real network, real map tiles, no
/// deterministic pin position). So this test sets the route by dispatching
/// [BookingPickupSet]/[BookingDestinationSet] directly on the real
/// [BookingBloc] — the same events the map picker itself would dispatch —
/// then drives every screen after that point purely through real taps.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('guest session reaches main shell and all tabs render',
      (tester) async {
    await app.testMain();
    await tester.pumpAndSettle();

    // Jump straight to the main shell — legitimate because the app already
    // established an anonymous session during bootstrap (the same one that
    // lets a real guest book a ride before logging in).
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.navHome), findsOneWidget);

    for (final String label in [
      AppStrings.navRides,
      AppStrings.navAlerts,
      AppStrings.navProfile,
      AppStrings.navHome,
    ]) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('search -> confirm -> request ride -> finding driver',
      (tester) async {
    await app.testMain();
    await tester.pumpAndSettle();

    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
    await tester.pumpAndSettle();

    // Home -> tap the search entry to open the Search page.
    expect(find.text(AppStrings.whereToShort), findsOneWidget);
    await tester.tap(find.text(AppStrings.whereToShort));
    await tester.pumpAndSettle();

    // Set a real route (see file-level doc comment for why this bypasses
    // the map drag gesture specifically).
    final BuildContext searchContext = tester.element(find.byType(Scaffold).last);
    final BookingBloc bookingBloc = searchContext.read<BookingBloc>();
    bookingBloc
      ..add(const BookingPickupSet(LatLng(26.1063, 34.2797), 'El Qusair Port'))
      ..add(const BookingDestinationSet(LatLng(26.1161, 34.3736), 'Sirena Beach'));
    await tester.pumpAndSettle();

    // "Find driver" is only enabled once a route exists.
    expect(find.text(AppStrings.findDriver), findsOneWidget);
    await tester.tap(find.text(AppStrings.findDriver));
    await tester.pumpAndSettle();

    // Confirm screen: price field is pre-filled with a suggested fare.
    expect(find.text(AppStrings.requestRide), findsOneWidget);
    await tester.tap(find.text(AppStrings.requestRide));
    await tester.pumpAndSettle();

    // Real network call to Supabase happens here (insert into `trips`).
    // Whether or not it succeeds (e.g. no configured backend in this run),
    // the app must land on the Finding Driver screen either way — that's
    // what this assertion is really checking.
    expect(find.text(AppStrings.findingDriver), findsOneWidget);
  });
}
