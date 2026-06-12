import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// An uppercase, letter-spaced muted label used to head list sections
/// ("RECENT", "SAVED PLACES", "TODAY").
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.sectionLabel);
  }
}
