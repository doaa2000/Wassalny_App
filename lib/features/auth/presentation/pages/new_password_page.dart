import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';

/// Final step of "Forgot password": set a new password. Only reachable
/// right after a successful [PasswordResetCodeVerified], which leaves an
/// active Supabase recovery session that [PasswordResetCompleted] uses.
class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final String pw = _password.text;
    final String confirm = _confirm.text;

    if (pw.length < 6) {
      setState(() => _localError = AppStrings.passwordTooShort);
      return;
    }
    if (pw != confirm) {
      setState(() => _localError = AppStrings.passwordsDoNotMatch);
      return;
    }
    setState(() => _localError = null);
    context.read<AuthBloc>().add(PasswordResetCompleted(pw));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.passwordResetStatus != c.passwordResetStatus,
        listener: (context, state) async {
          if (state.passwordResetStatus == PasswordResetStatus.done) {
            // The recovery flow leaves the rider signed in under a recovery
            // session — sign them out so they log in fresh with the new
            // password, which is the least surprising behaviour.
            context.read<AuthBloc>().add(const AuthLogoutRequested());
            context.read<AuthBloc>().add(const PasswordResetStateCleared());
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(AppStrings.passwordResetDone)));
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (route) => false);
          } else if (state.passwordResetStatus == PasswordResetStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(
                      state.passwordResetError ?? AppStrings.couldNotUpdateProfile)));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.peach,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.password_rounded,
                      color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.newPasswordTitle, style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(AppStrings.newPasswordSubtitle, style: AppTextStyles.body),
                const SizedBox(height: 26),
                AppTextField(
                  label: AppStrings.newPassword,
                  controller: _password,
                  obscure: true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.confirmNewPassword,
                  controller: _confirm,
                  obscure: true,
                ),
                if (_localError != null) ...[
                  const SizedBox(height: 10),
                  Text(_localError!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.danger)),
                ],
                const SizedBox(height: 26),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) =>
                      p.passwordResetStatus != c.passwordResetStatus,
                  builder: (context, state) => PrimaryButton(
                    label: state.passwordResetStatus == PasswordResetStatus.loading
                        ? 'Saving…'
                        : AppStrings.save,
                    onPressed: state.passwordResetStatus ==
                            PasswordResetStatus.loading
                        ? null
                        : _submit,
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
