import 'package:equatable/equatable.dart';

enum RideStatus { completed, cancelled }

/// A past trip shown on the ride-history screen.
class RideHistory extends Equatable {
  const RideHistory({
    required this.dateTime,
    required this.status,
    required this.from,
    required this.to,
    required this.price,
    required this.distance,
  });

  final String dateTime;
  final RideStatus status;
  final String from;
  final String to;
  final String price;
  final String distance;

  @override
  List<Object?> get props => [dateTime, status, from, to, price, distance];
}
