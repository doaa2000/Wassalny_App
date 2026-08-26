import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/secondary_buttons.dart';
import '../bloc/auth_bloc.dart';

/// Password reset request screen — sends a 6-digit recovery code to the
/// rider's email via Supabase Auth.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.passwordResetStatus != c.passwordResetStatus,
        listener: (context, state) {
          if (state.passwordResetStatus == PasswordResetStatus.codeSent) {
            Navigator.pushNamed(context, AppRoutes.otp,
                arguments: _email.text.trim());
          } else if (state.passwordResetStatus == PasswordResetStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(state.passwordResetError ?? 'Could not send code')));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundIconButton.back(onPressed: () => Navigator.pop(context)),
                const SizedBox(height: 24),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.peach,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.lock_reset_rounded,
                      color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.forgotTitle, style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(AppStrings.forgotSubtitle, style: AppTextStyles.body),
                const SizedBox(height: 26),
                AppTextField(
                  label: AppStrings.emailAddress,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'you@example.com',
                  icon: Icon(Icons.mail_outline_rounded,
                      size: 19, color: AppColors.textFaint),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) =>
                      p.passwordResetStatus != c.passwordResetStatus,
                  builder: (context, state) => PrimaryButton(
                    label: state.passwordResetStatus == PasswordResetStatus.loading
                        ? 'Sending…'
                        : AppStrings.sendResetCode,
                    onPressed: state.passwordResetStatus ==
                            PasswordResetStatus.loading
                        ? null
                        : () {
                            final String email = _email.text.trim();
                            if (email.isEmpty) return;
                            context
                                .read<AuthBloc>()
                                .add(PasswordResetRequested(email));
                          },
                  ),
                ),
                const SizedBox(height: 12),
                GhostButton(
                  label: AppStrings.backToLogin,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
