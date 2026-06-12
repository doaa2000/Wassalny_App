import 'package:equatable/equatable.dart';

enum WalletCardType { visa, cash }

enum WalletTxnType { trip, topUp }

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

/// A single wallet transaction row.
class WalletTransaction extends Equatable {
  const WalletTransaction({
    required this.type,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });

  final WalletTxnType type;
  final String title;
  final String date;
  final String amount;
  final bool isCredit;

  @override
  List<Object?> get props => [type, title, date, amount, isCredit];
}

/// Aggregate wallet view-model: balance + cards + recent transactions.
class WalletData extends Equatable {
  const WalletData({
    required this.balance,
    required this.cards,
    required this.transactions,
  });

  final String balance;
  final List<WalletCard> cards;
  final List<WalletTransaction> transactions;

  @override
  List<Object?> get props => [balance, cards, transactions];
}
