import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wallet_data.dart';
import '../../domain/repositories/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

/// Loads and exposes the wallet view-model to the wallet page.
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(this._repository) : super(const WalletState()) {
    on<WalletRequested>(_onRequested);
  }

  final WalletRepository _repository;

  void _onRequested(WalletRequested event, Emitter<WalletState> emit) {
    emit(WalletState(wallet: _repository.getWallet()));
  }
}
