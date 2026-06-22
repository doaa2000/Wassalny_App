import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../booking/presentation/pages/location_picker_page.dart';
import '../../domain/entities/saved_place.dart';
import '../bloc/places_bloc.dart';

/// Full CRUD screen for the rider's saved places (Supabase `saved_places`).
class SavedPlacesPage extends StatelessWidget {
  const SavedPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RoundIconButton.back(onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Text(AppStrings.savedPlaces, style: AppTextStyles.h1),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: BlocBuilder<PlacesBloc, PlacesState>(
                  builder: (context, state) {
                    if (state.status == PlacesStatus.loading ||
                        state.status == PlacesStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.places.isEmpty) {
                      return Center(
                        child: Text('No saved places yet.',
                            style: AppTextStyles.body.copyWith(color: AppColors.textFaint)),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.places.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _PlaceCard(place: state.places[i]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Add place',
                onPressed: () => _showAddSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddSheet(BuildContext context) async {
    final PlacesBloc bloc = context.read<PlacesBloc>();

    // 1. Pick the exact spot on the map (captures coordinates + address).
    final PickedPlace? picked = await Navigator.push<PickedPlace>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(title: AppStrings.savedPlaces),
      ),
    );
    if (picked == null || !context.mounted) return;

    // 2. Name it (Home, Work, …).
    final String? label = await _askLabel(context, picked.address);
    if (label == null || label.trim().isEmpty) return;

    bloc.add(PlaceAdded(
      label: label.trim(),
      address: picked.address,
      lat: picked.latLng.latitude,
      lng: picked.latLng.longitude,
    ));
  }

  Future<String?> _askLabel(BuildContext context, String address) {
    final TextEditingController label = TextEditingController();
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
                style: AppTextStyles.bodySm
                    .copyWith(color: AppColors.textFaint)),
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
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place});

  final SavedPlace place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.place_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(place.address,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.textFaint)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textFaint),
            onPressed: () => context.read<PlacesBloc>().add(PlaceRemoved(place.id)),
          ),
        ],
      ),
    );
  }
}
