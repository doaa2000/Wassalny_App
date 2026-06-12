part of 'wallet_bloc.dart';

/// Wallet screen state. [wallet] is null until the data has loaded.
class WalletState extends Equatable {
  const WalletState({this.wallet});

  final WalletData? wallet;

  @override
  List<Object?> get props => [wallet];
}
