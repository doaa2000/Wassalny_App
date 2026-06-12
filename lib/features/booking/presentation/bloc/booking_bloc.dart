import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }

  final BookingRepository _repository;

  void _onStarted(BookingStarted event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      drivers: _repository.getNearbyDrivers(),
      paymentMethods: _repository.getPaymentMethods(),
      fareLines: _repository.getFareBreakdown(),
    ));
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
}
