import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../domain/entities/saved_place.dart';
import '../bloc/places_bloc.dart';
import '../utils/add_place_flow.dart';

/// Full CRUD screen for the rider's saved places (Supabase `saved_places`).
class SavedPlacesPage extends StatelessWidget {
  const SavedPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocListener<PlacesBloc, PlacesState>(
          listenWhen: (prev, curr) =>
              curr.status == PlacesStatus.failure && curr.error != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error!)));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RoundIconButton.back(
                        onPressed: () => Navigator.pop(context)),
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
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.textFaint)),
                        );
                      }
                      return ListView.separated(
                        itemCount: state.places.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) =>
                            _PlaceCard(place: state.places[i]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                  label: 'Add place',
                  onPressed: () =>
                      runAddPlaceFlow(context, context.read<PlacesBloc>()),
                ),
              ],
            ),
          ),
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
                Text(place.label,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(place.address,
                    style: AppTextStyles.bodySm
                        .copyWith(color: AppColors.textFaint)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textFaint),
            onPressed: () => _showRenameDialog(context, place),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.textFaint),
            onPressed: () =>
                context.read<PlacesBloc>().add(PlaceRemoved(place.id)),
          ),
        ],
      ),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, SavedPlace place) async {
    final PlacesBloc bloc = context.read<PlacesBloc>();
    final TextEditingController controller =
        TextEditingController(text: place.label);

    final String? newLabel = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppStrings.renamePlace,
            style: AppTextStyles.h1.copyWith(fontSize: 18)),
        content: AppTextField(controller: controller, hintText: 'Home, Work…'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.primaryDark)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(AppStrings.save,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.primaryDark)),
          ),
        ],
      ),
    );

    final String trimmed = newLabel?.trim() ?? '';
    if (trimmed.isEmpty || trimmed == place.label) return;
    bloc.add(PlaceRenamed(id: place.id, label: trimmed));
  }
}
