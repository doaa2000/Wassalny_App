import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/booking/data/datasources/booking_local_data_source.dart';
import '../../features/booking/data/datasources/trip_remote_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';
import '../services/supabase_service.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/rides/data/repositories/rides_repository_impl.dart';
import '../../features/rides/presentation/bloc/rides_bloc.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';

/// Lightweight composition root.
///
/// Builds the (dummy-data) repositories once and exposes the blocs via a
/// [MultiBlocProvider] so the whole widget tree can read them. Each bloc is
/// seeded with its initial "Requested/Started" event so the data loads up
/// front, mirroring the previous Cubit constructors. For a UI-only app this is
/// a clean stand-in for a full DI container like get_it.
class AppDependencies extends StatefulWidget {
  const AppDependencies({super.key, required this.child});

  final Widget child;

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  late final TripRemoteDataSource _tripRemote =
      SupabaseService.instance.isConfigured
          ? TripSupabaseDataSource(SupabaseService.instance)
          : const TripNoopDataSource();
  late final BookingRepository _bookingRepo =
      BookingRepositoryImpl(BookingLocalDataSource(), _tripRemote);
  late final _authRepo =
      AuthRepositoryImpl(AuthRemoteDataSource(SupabaseService.instance));
  late final _walletRepo = WalletRepositoryImpl();
  late final _ridesRepo = RidesRepositoryImpl();
  late final _notificationsRepo = NotificationsRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(_authRepo)),
        BlocProvider(
          create: (_) => BookingBloc(_bookingRepo)..add(const BookingStarted()),
        ),
        BlocProvider(
          create: (_) => WalletBloc(_walletRepo)..add(const WalletRequested()),
        ),
        BlocProvider(
          create: (_) => RidesBloc(_ridesRepo)..add(const RidesRequested()),
        ),
        BlocProvider(
          create: (_) => NotificationsBloc(_notificationsRepo)
            ..add(const NotificationsRequested()),
        ),
      ],
      child: widget.child,
    );
  }
}
