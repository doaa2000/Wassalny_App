import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
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
                  Text('Saved places', style: AppTextStyles.h1),
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
    final TextEditingController label = TextEditingController();
    final TextEditingController address = TextEditingController();
    final PlacesBloc bloc = context.read<PlacesBloc>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New place', style: AppTextStyles.h1),
            const SizedBox(height: 16),
            AppTextField(label: 'Label', hintText: 'Home, Work…', controller: label),
            const SizedBox(height: 12),
            AppTextField(label: 'Address', hintText: 'Street, area, city', controller: address),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Save',
              onPressed: () {
                if (label.text.trim().isEmpty || address.text.trim().isEmpty) return;
                bloc.add(PlaceAdded(label: label.text.trim(), address: address.text.trim()));
                Navigator.pop(ctx);
              },
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
