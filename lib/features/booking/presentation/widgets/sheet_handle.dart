import 'package:flutter/material.dart';

/// The small rounded "grabber" centred at the top of bottom sheets.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 5,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE5DACB),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
