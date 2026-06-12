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

/// The rider selected a tip amount.
final class BookingTipChanged extends BookingEvent {
  const BookingTipChanged(this.tip);

  final int tip;

  @override
  List<Object?> get props => [tip];
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
