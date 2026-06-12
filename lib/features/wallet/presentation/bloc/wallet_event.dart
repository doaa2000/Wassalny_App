part of 'wallet_bloc.dart';

/// Base type for all wallet events.
sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Load the wallet (balance, cards, transactions).
final class WalletRequested extends WalletEvent {
  const WalletRequested();
}
