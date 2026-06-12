import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/booking/data/datasources/booking_local_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/presentation/cubit/booking_cubit.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/rides/data/repositories/rides_repository_impl.dart';
import '../../features/rides/presentation/cubit/rides_cubit.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/presentation/cubit/wallet_cubit.dart';

/// Lightweight composition root.
///
/// Builds the (dummy-data) repositories once and exposes the cubits via a
/// [MultiBlocProvider] so the whole widget tree can read them. For a UI-only
/// app this is a clean stand-in for a full DI container like get_it.
class AppDependencies extends StatefulWidget {
  const AppDependencies({super.key, required this.child});

  final Widget child;

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  late final BookingRepository _bookingRepo =
      BookingRepositoryImpl(BookingLocalDataSource());
  late final _walletRepo = WalletRepositoryImpl();
  late final _ridesRepo = RidesRepositoryImpl();
  late final _notificationsRepo = NotificationsRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BookingCubit(_bookingRepo)),
        BlocProvider(create: (_) => WalletCubit(_walletRepo)),
        BlocProvider(create: (_) => RidesCubit(_ridesRepo)),
        BlocProvider(create: (_) => NotificationsCubit(_notificationsRepo)),
      ],
      child: widget.child,
    );
  }
}
