import 'package:equatable/equatable.dart';

enum WalletCardType { visa, cash }

/// A saved payment method shown in the wallet.
class WalletCard extends Equatable {
  const WalletCard({
    required this.type,
    required this.title,
    required this.subtitle,
    this.isDefault = false,
  });

  final WalletCardType type;
  final String title;
  final String subtitle;
  final bool isDefault;

  @override
  List<Object?> get props => [type, title, subtitle, isDefault];
}

/// Aggregate wallet view-model: balance + cards.
class WalletData extends Equatable {
  const WalletData({
    required this.balance,
    required this.cards,
  });

  final String balance;
  final List<WalletCard> cards;

  @override
  List<Object?> get props => [balance, cards];
}
