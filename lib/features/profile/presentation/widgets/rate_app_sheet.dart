import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

/// Shows the "Rate the app" bottom sheet.
Future<void> showRateAppSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (_) => const _RateAppSheet(),
  );
}

class _RateAppSheet extends StatefulWidget {
  const _RateAppSheet();

  @override
  State<_RateAppSheet> createState() => _RateAppSheetState();
}

class _RateAppSheetState extends State<_RateAppSheet> {
  int _rating = 0;

  void _submit() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppStrings.rateThanks)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 18, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE5DACB),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 22),
          Text(AppStrings.rateTitle, style: AppTextStyles.title),
          const SizedBox(height: 8),
          Text(
            AppStrings.ratePrompt,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 40,
                    color: filled ? AppColors.gold : AppColors.chevron,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 26),
          PrimaryButton(
            label: AppStrings.submit,
            onPressed: _rating == 0 ? null : _submit,
          ),
        ],
      ),
    );
  }
}
