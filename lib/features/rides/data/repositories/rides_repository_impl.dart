import '../../domain/entities/ride_history.dart';
import '../../domain/repositories/rides_repository.dart';
import '../datasources/rides_remote_data_source.dart';

class RidesRepositoryImpl implements RidesRepository {
  RidesRepositoryImpl(this._remoteDataSource);

  final RidesRemoteDataSource _remoteDataSource;

  @override
  Future<List<RideHistory>> getRides() async {
    final rows = await _remoteDataSource.fetchRides();
    return rows
        .map(_mapRow)
        .whereType<RideHistory>() // drops active trips (requested/accepted/in_progress)
        .toList();
  }

  RideHistory? _mapRow(Map<String, dynamic> row) {
    final RideStatus? status = switch (row['status'] as String?) {
      'completed' => RideStatus.completed,
      'cancelled' => RideStatus.cancelled,
      _ => null, // ride history shows completed/cancelled only
    };
    if (status == null) return null;

    final String? tsRaw = (row['completed_at'] ?? row['cancelled_at'] ?? row['created_at']) as String?;
    final DateTime? dt = tsRaw != null ? DateTime.tryParse(tsRaw) : null;

    final num? price = row['trip_price'] as num?;
    final double? distanceKm = (row['estimated_distance'] as num?)?.toDouble();

    return RideHistory(
      dateTime: dt != null ? _formatDateTime(dt) : '—',
      status: status,
      from: (row['pickup_address'] as String?) ?? '—',
      to: (row['destination_address'] as String?) ?? '—',
      price: price != null ? 'EGP ${price.toStringAsFixed(0)}' : 'EGP 0',
      distance: distanceKm != null ? '${distanceKm.toStringAsFixed(1)} km' : '—',
    );
  }

  String _formatDateTime(DateTime utc) {
    final DateTime local = utc.toLocal();
    final DateTime now = DateTime.now();
    final String hh = local.hour.toString().padLeft(2, '0');
    final String mm = local.minute.toString().padLeft(2, '0');

    final bool isToday =
        local.year == now.year && local.month == now.month && local.day == now.day;
    if (isToday) return 'Today · $hh:$mm';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[local.month - 1]} ${local.day} · $hh:$mm';
  }
}