import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../booking/presentation/pages/location_picker_page.dart';
import '../bloc/places_bloc.dart';

/// Runs the full "add a saved place" flow: pick a spot on the map, name it,
/// then dispatch [PlaceAdded]. Shared by the Saved Places screen and the
/// Home quick-place cards so both stay in sync with one implementation.
///
/// [presetLabel] pre-fills the name field (e.g. "Home"/"Work" when the rider
/// tapped an empty quick-place slot) — they can still edit it before saving.
Future<void> runAddPlaceFlow(
  BuildContext context,
  PlacesBloc bloc, {
  String? presetLabel,
}) async {
  final PickedPlace? picked = await Navigator.push<PickedPlace>(
    context,
    MaterialPageRoute(
      builder: (_) => LocationPickerPage(title: AppStrings.savedPlaces),
    ),
  );
  if (picked == null || !context.mounted) return;

  final String? label =
      await _askLabel(context, picked.address, presetLabel: presetLabel);
  if (label == null || label.trim().isEmpty) return;

  bloc.add(PlaceAdded(
    label: label.trim(),
    address: picked.address,
    lat: picked.latLng.latitude,
    lng: picked.latLng.longitude,
  ));
}

Future<String?> _askLabel(
  BuildContext context,
  String address, {
  String? presetLabel,
}) {
  final TextEditingController label =
      TextEditingController(text: presetLabel ?? '');
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) => Padding(
      padding:
          EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.savedPlaces, style: AppTextStyles.h1),
          const SizedBox(height: 6),
          Text(address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textFaint)),
          const SizedBox(height: 16),
          AppTextField(
              label: AppStrings.placeHome,
              hintText: 'Home, Work…',
              controller: label),
          const SizedBox(height: 18),
          PrimaryButton(
            label: AppStrings.submit,
            onPressed: () => Navigator.pop(ctx, label.text),
          ),
        ],
      ),
    ),
  );
}
