import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/driver.dart';
import '../../domain/entities/fare_line.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/booking_repository.dart';

part 'booking_state.dart';

/// Drives the booking flow: loads the demo catalogue and tracks the rider's
/// selections (driver, filter, payment method, tip and rating).
class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._repository) : super(const BookingState()) {
    _load();
  }

  final BookingRepository _repository;

  void _load() {
    emit(state.copyWith(
      drivers: _repository.getNearbyDrivers(),
      paymentMethods: _repository.getPaymentMethods(),
      fareLines: _repository.getFareBreakdown(),
    ));
  }

  void selectDriver(int index) =>
      emit(state.copyWith(selectedDriverIndex: index));

  void setFilter(RideFilter filter) => emit(state.copyWith(filter: filter));

  void setPayment(String id) => emit(state.copyWith(selectedPaymentId: id));

  void setTip(int tip) => emit(state.copyWith(tip: tip));

  void setRating(int rating) => emit(state.copyWith(rating: rating));

  /// Reset the rating/tip when starting a fresh booking from home.
  void resetTrip() => emit(state.copyWith(tip: 0, rating: 0));
}
