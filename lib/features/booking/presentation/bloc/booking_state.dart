part of 'booking_bloc.dart';

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
/// tracking → rate). A single bloc owns it so the selection persists as the
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
    this.requesting = false,
    this.tripId,
    this.tripStatus = '',
    this.pickup,
    this.pickupAddress,
    this.destination,
    this.destinationAddress,
    this.assignedDriver,
    this.driverLocation,
  });

  final List<Driver> drivers;
  final List<PaymentMethod> paymentMethods;
  final List<FareLine> fareLines;
  final int selectedDriverIndex;
  final RideFilter filter;
  final String selectedPaymentId;
  final int tip;
  final int rating;

  /// True while a ride request is being sent to the backend.
  final bool requesting;

  /// Id of the trip created in the backend (null until requested).
  final String? tripId;

  /// Live status of the tracked trip: requested → accepted → arrived →
  /// in_progress → completed.
  final String tripStatus;

  /// Rider-chosen pickup point and its readable address (null until picked).
  final LatLng? pickup;
  final String? pickupAddress;

  /// Rider-chosen destination and its readable address (null until picked).
  final LatLng? destination;
  final String? destinationAddress;

  /// True once both ends of the trip have been chosen on the map.
  bool get hasRoute => pickup != null && destination != null;

  /// The real driver who accepted the broadcast request (null until accepted).
  final Driver? assignedDriver;

  /// The assigned captain's live GPS position (null until they start sharing).
  final LatLng? driverLocation;

  /// The currently chosen driver from the demo/preview list.
  Driver? get selectedDriver =>
      drivers.isEmpty ? null : drivers[selectedDriverIndex];

  /// The driver to show on the tracking screens: the captain who actually
  /// accepted, falling back to the previewed/demo driver.
  Driver? get activeDriver => assignedDriver ?? selectedDriver;

  BookingState copyWith({
    List<Driver>? drivers,
    List<PaymentMethod>? paymentMethods,
    List<FareLine>? fareLines,
    int? selectedDriverIndex,
    RideFilter? filter,
    String? selectedPaymentId,
    int? tip,
    int? rating,
    bool? requesting,
    String? tripId,
    String? tripStatus,
    LatLng? pickup,
    String? pickupAddress,
    LatLng? destination,
    String? destinationAddress,
    Driver? assignedDriver,
    bool resetAssignedDriver = false,
    LatLng? driverLocation,
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
      requesting: requesting ?? this.requesting,
      tripId: tripId ?? this.tripId,
      tripStatus: tripStatus ?? this.tripStatus,
      pickup: pickup ?? this.pickup,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destination: destination ?? this.destination,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      assignedDriver:
          resetAssignedDriver ? null : (assignedDriver ?? this.assignedDriver),
      driverLocation:
          resetAssignedDriver ? null : (driverLocation ?? this.driverLocation),
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
        requesting,
        tripId,
        tripStatus,
        pickup,
        pickupAddress,
        destination,
        destinationAddress,
        assignedDriver,
        driverLocation,
      ];
}
