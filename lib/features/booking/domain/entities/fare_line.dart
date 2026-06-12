import 'package:equatable/equatable.dart';

/// A single line in the fare breakdown (label + amount), optionally a discount
/// or the bold total row.
class FareLine extends Equatable {
  const FareLine({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    this.isTotal = false,
  });

  final String label;
  final String amount;
  final bool isDiscount;
  final bool isTotal;

  @override
  List<Object?> get props => [label, amount, isDiscount, isTotal];
}
