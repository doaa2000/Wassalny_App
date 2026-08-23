import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Lets the rider edit their name and phone. Email is shown read-only —
/// changing it would need a re-verification flow this app doesn't implement
/// yet, so we're honest about that limit instead of pretending it works.
class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    context.read<AuthBloc>().add(
          AuthProfileUpdateRequested(
            fullName: _nameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final String email = context.select<AuthBloc, String>(
        (bloc) => bloc.state.user?.email ?? '');

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            prev.profileUpdateStatus != curr.profileUpdateStatus,
        listener: (context, state) {
          if (state.profileUpdateStatus == ProfileUpdateStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(AppStrings.profileUpdated)));
            Navigator.pop(context);
          } else if (state.profileUpdateStatus == ProfileUpdateStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(
                      state.profileError ?? AppStrings.couldNotUpdateProfile)));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RoundIconButton.back(onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 12),
                    Text(AppStrings.personalInfo, style: AppTextStyles.h1),
                  ],
                ),
                const SizedBox(height: 26),
                AppTextField(label: AppStrings.fullName, controller: _nameController),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.phoneNumber,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: '+20 1xx xxx xxxx',
                ),
                const SizedBox(height: 16),
                _ReadOnlyField(label: 'Email', value: email),
                const SizedBox(height: 6),
                Text(AppStrings.emailCannotBeChanged,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 26),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) => p.profileUpdateStatus != c.profileUpdateStatus,
                  builder: (context, state) => PrimaryButton(
                    label: AppStrings.save,
                    onPressed: state.profileUpdateStatus ==
                            ProfileUpdateStatus.loading
                        ? null
                        : _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A field styled like [AppTextField] but not editable — used for email,
/// which this screen intentionally doesn't allow changing.
class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Container(
          height: AppDimens.inputHeight,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.disabled.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimens.rMd),
          ),
          child: Text(value,
              style: AppTextStyles.input.copyWith(color: AppColors.textTertiary)),
        ),
      ],
    );
  }
}
