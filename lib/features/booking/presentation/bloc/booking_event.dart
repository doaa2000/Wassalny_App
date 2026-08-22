part of 'booking_bloc.dart';

/// Base type for all booking-flow events.
sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

/// Load the demo catalogue (drivers, payment methods, fare lines).
final class BookingStarted extends BookingEvent {
  const BookingStarted();
}

/// The rider picked the driver at [index].
final class BookingDriverSelected extends BookingEvent {
  const BookingDriverSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

/// The rider changed the driver-list filter chip.
final class BookingFilterChanged extends BookingEvent {
  const BookingFilterChanged(this.filter);

  final RideFilter filter;

  @override
  List<Object?> get props => [filter];
}

/// The rider chose a payment method on the confirm screen.
final class BookingPaymentChanged extends BookingEvent {
  const BookingPaymentChanged(this.paymentId);

  final String paymentId;

  @override
  List<Object?> get props => [paymentId];
}

/// The rider set the post-trip star rating.
final class BookingRatingChanged extends BookingEvent {
  const BookingRatingChanged(this.rating);

  final int rating;

  @override
  List<Object?> get props => [rating];
}

/// Reset per-trip selections (tip / rating) when starting a fresh booking.
final class BookingTripReset extends BookingEvent {
  const BookingTripReset();
}

/// The rider confirmed their pickup point on the map.
final class BookingPickupSet extends BookingEvent {
  const BookingPickupSet(this.latLng, this.address);

  final LatLng latLng;
  final String address;

  @override
  List<Object?> get props => [latLng, address];
}

/// The rider dragged the pickup pin (or tapped the home map) to a new point;
/// the bloc reverse-geocodes it into an address.
final class BookingPickupPicked extends BookingEvent {
  const BookingPickupPicked(this.latLng);

  final LatLng latLng;

  @override
  List<Object?> get props => [latLng];
}

/// Request the device GPS and use it as the pickup (home screen). [force]
/// re-fetches even if a pickup is already set (the "my location" button).
final class BookingCurrentPickupRequested extends BookingEvent {
  const BookingCurrentPickupRequested({this.force = false});

  final bool force;

  @override
  List<Object?> get props => [force];
}

/// The rider confirmed their destination on the map.
final class BookingDestinationSet extends BookingEvent {
  const BookingDestinationSet(this.latLng, this.address);

  final LatLng latLng;
  final String address;

  @override
  List<Object?> get props => [latLng, address];
}

/// The rider confirmed the ride — create the trip request in the backend so the
/// Captain app receives it.
final class BookingRideRequested extends BookingEvent {
  const BookingRideRequested({
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.paymentMethod,
    this.price,
    this.driverId,
  });

  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String paymentMethod;
  final num? price;

  /// Assigned driver's backend id (null = broadcast to all nearby drivers).
  final String? driverId;

  @override
  List<Object?> get props =>
      [pickupAddress, dropoffAddress, pickupLat, pickupLng, dropoffLat, dropoffLng, paymentMethod, price, driverId];
}

/// The rider submitted their post-trip star rating (and optional review).
/// Persists to the backend, then resets local tip/rating state.
final class BookingRatingSubmitted extends BookingEvent {
  const BookingRatingSubmitted({this.comment});

  final String? comment;

  @override
  List<Object?> get props => [comment];
}

/// The rider cancelled while waiting for a captain to accept — either by
/// tapping "Cancel" or because the search timed out with no acceptance.
final class BookingTripCancelled extends BookingEvent {
  const BookingTripCancelled();
}

/// Internal: the tracked trip's status changed (from the Realtime stream).
final class _BookingTripStatusChanged extends BookingEvent {
  const _BookingTripStatusChanged(this.status);

  final String status;

  @override
  List<Object?> get props => [status];
}

/// Internal: the assigned captain's live location changed (Realtime stream).
final class _BookingDriverLocationChanged extends BookingEvent {
  const _BookingDriverLocationChanged(this.location);

  final LatLng? location;

  @override
  List<Object?> get props => [location];
}
