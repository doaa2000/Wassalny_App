part of 'booking_cubit.dart';

/// Ride sorting/filter options shown as chips on the driver-select screen.
enum RideFilter {
  recommended('Recommended'),
  cheapest('Cheapest'),
  fastest('Fastest'),
  topRated('Top rated');

  const RideFilter(this.label);
  final String label;
}

/// Immutable state for the whole booking flow (driver-select → confirm →
/// tracking → rate). A single cubit owns it so the selection persists as the
/// rider moves between screens.
class BookingState extends Equatable {
  const BookingState({
    this.drivers = const [],
    this.paymentMethods = const [],
    this.fareLines = const [],
    this.selectedDriverIndex = 0,
    this.filter = RideFilter.recommended,
    this.selectedPaymentId = 'wallet',
    this.tip = 0,
    this.rating = 0,
  });

  final List<Driver> drivers;
  final List<PaymentMethod> paymentMethods;
  final List<FareLine> fareLines;
  final int selectedDriverIndex;
  final RideFilter filter;
  final String selectedPaymentId;
  final int tip;
  final int rating;

  /// The currently chosen driver (safe even before data loads).
  Driver? get selectedDriver =>
      drivers.isEmpty ? null : drivers[selectedDriverIndex];

  BookingState copyWith({
    List<Driver>? drivers,
    List<PaymentMethod>? paymentMethods,
    List<FareLine>? fareLines,
    int? selectedDriverIndex,
    RideFilter? filter,
    String? selectedPaymentId,
    int? tip,
    int? rating,
  }) {
    return BookingState(
      drivers: drivers ?? this.drivers,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      fareLines: fareLines ?? this.fareLines,
      selectedDriverIndex: selectedDriverIndex ?? this.selectedDriverIndex,
      filter: filter ?? this.filter,
      selectedPaymentId: selectedPaymentId ?? this.selectedPaymentId,
      tip: tip ?? this.tip,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
        drivers,
        paymentMethods,
        fareLines,
        selectedDriverIndex,
        filter,
        selectedPaymentId,
        tip,
        rating,
      ];
}
