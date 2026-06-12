import 'package:flutter/widgets.dart';

/// Tiny spacing helpers to keep column/row layouts readable.
///
/// `Gap(16)` adds vertical space (clearer than `SizedBox(height: 16)` inside a
/// [Column]); `Gap.w(16)` adds horizontal space inside a [Row].
class Gap extends StatelessWidget {
  /// Vertical gap.
  const Gap(this.size, {super.key}) : _horizontal = false;

  /// Horizontal gap.
  const Gap.w(this.size, {super.key}) : _horizontal = true;

  final double size;
  final bool _horizontal;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: _horizontal ? size : 0, height: _horizontal ? 0 : size);
}
