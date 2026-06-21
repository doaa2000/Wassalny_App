import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/logging/logging.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/driver.dart';
import '../../domain/entities/fare_line.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

/// Drives the booking flow: loads the demo catalogue and tracks the rider's
/// selections (driver, filter, payment method, tip and rating).
///
/// Event-driven: the UI dispatches [BookingEvent]s and the bloc reduces them
/// into a new [BookingState].
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc(this._repository) : super(const BookingState()) {
    on<BookingStarted>(_onStarted);
    on<BookingDriverSelected>(_onDriverSelected);
    on<BookingFilterChanged>(_onFilterChanged);
    on<BookingPaymentChanged>(_onPaymentChanged);
    on<BookingTipChanged>(_onTipChanged);
    on<BookingRatingChanged>(_onRatingChanged);
    on<BookingTripReset>(_onTripReset);
    on<BookingPickupSet>(_onPickupSet);
    on<BookingDestinationSet>(_onDestinationSet);
    on<BookingPickupPicked>(_onPickupPicked);
    on<BookingCurrentPickupRequested>(_onCurrentPickupRequested);
    on<BookingRideRequested>(_onRideRequested);
    on<_BookingTripStatusChanged>(_onTripStatusChanged);
  }

  final BookingRepository _repository;
  final LocationService _location = LocationService.instance;
  StreamSubscription<String>? _tripSub;

  Future<void> _onStarted(BookingStarted event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
      paymentMethods: _repository.getPaymentMethods(),
      fareLines: _repository.getFareBreakdown(),
    ));
    final List<Driver> drivers = await _repository.fetchNearbyDrivers();
    emit(state.copyWith(drivers: drivers));
  }

  void _onDriverSelected(
      BookingDriverSelected event, Emitter<BookingState> emit) {
    emit(state.copyWith(selectedDriverIndex: event.index));
  }

  void _onFilterChanged(
      BookingFilterChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onPaymentChanged(
      BookingPaymentChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(selectedPaymentId: event.paymentId));
  }

  void _onTipChanged(BookingTipChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(tip: event.tip));
  }

  void _onRatingChanged(
      BookingRatingChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(rating: event.rating));
  }

  void _onTripReset(BookingTripReset event, Emitter<BookingState> emit) {
    emit(state.copyWith(tip: 0, rating: 0));
  }

  void _onPickupSet(BookingPickupSet event, Emitter<BookingState> emit) {
    emit(state.copyWith(pickup: event.latLng, pickupAddress: event.address));
  }

  void _onDestinationSet(
      BookingDestinationSet event, Emitter<BookingState> emit) {
    emit(state.copyWith(
        destination: event.latLng, destinationAddress: event.address));
  }

  Future<void> _onPickupPicked(
      BookingPickupPicked event, Emitter<BookingState> emit) async {
    // Move the pin immediately; resolve the address in the background.
    emit(state.copyWith(pickup: event.latLng, pickupAddress: 'Locating…'));
    final String address = await _location.addressOf(event.latLng);
    emit(state.copyWith(pickup: event.latLng, pickupAddress: address));
  }

  Future<void> _onCurrentPickupRequested(
      BookingCurrentPickupRequested event, Emitter<BookingState> emit) async {
    // Don't override a pickup the rider already chose — unless they explicitly
    // tapped "my location" (force).
    if (!event.force && state.pickup != null) return;
    final LatLng? here = await _location.currentLatLng();
    if (here == null) return;
    emit(state.copyWith(pickup: here, pickupAddress: 'Locating…'));
    final String address = await _location.addressOf(here);
    emit(state.copyWith(pickup: here, pickupAddress: address));
  }

  Future<void> _onRideRequested(
      BookingRideRequested event, Emitter<BookingState> emit) async {
    emit(state.copyWith(requesting: true, resetAssignedDriver: true));
    try {
      final String? id = await _repository.requestTrip(
        pickupAddress: event.pickupAddress,
        dropoffAddress: event.dropoffAddress,
        pickupLat: event.pickupLat,
        pickupLng: event.pickupLng,
        dropoffLat: event.dropoffLat,
        dropoffLng: event.dropoffLng,
        paymentMethod: event.paymentMethod,
        price: event.price,
        driverId: event.driverId,
      );
      emit(state.copyWith(requesting: false, tripId: id, tripStatus: 'requested'));

      // Follow the trip's status live so the rider's screens advance when the
      // captain accepts / starts / completes.
      if (id != null) {
        _tripSub?.cancel();
        _tripSub = _repository.watchTrip(id).listen(
          (status) => add(_BookingTripStatusChanged(status)),
          onError: (Object e, StackTrace s) =>
              appLogger.logError('watchTrip stream error',
                  feature: 'Booking', error: e, stackTrace: s),
        );
      }
    } catch (e, s) {
      // Keep the flow going even if the backend call fails (UI-only fallback).
      appLogger.logError('requestTrip failed',
          feature: 'Booking', error: e, stackTrace: s);
      emit(state.copyWith(requesting: false));
    }
  }

  static const Set<String> _assignedStatuses = {
    'accepted',
    'arrived',
    'in_progress',
    'completed',
  };

  Future<void> _onTripStatusChanged(
      _BookingTripStatusChanged event, Emitter<BookingState> emit) async {
    emit(state.copyWith(tripStatus: event.status));

    // Once a captain accepts the broadcast, load who actually took the trip so
    // the tracking screens show the real driver (not a previewed/demo one).
    if (state.assignedDriver == null &&
        state.tripId != null &&
        _assignedStatuses.contains(event.status)) {
      final Driver? driver = await _repository.fetchAssignedDriver(state.tripId!);
      if (driver != null) emit(state.copyWith(assignedDriver: driver));
    }
  }

  @override
  Future<void> close() {
    _tripSub?.cancel();
    return super.close();
  }
}
