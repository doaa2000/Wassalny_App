import 'package:equatable/equatable.dart';

enum PaymentType { wallet, card, cash }

/// A selectable payment option on the confirm-ride screen.
class PaymentMethod extends Equatable {
  const PaymentMethod({
    required this.id,
    required this.label,
    required this.sub,
    required this.type,
  });

  final String id;
  final String label;
  final String sub;
  final PaymentType type;

  @override
  List<Object?> get props => [id];
}
