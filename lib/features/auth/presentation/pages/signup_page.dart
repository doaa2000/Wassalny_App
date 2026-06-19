import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_footer_prompt.dart';

/// Account creation screen, wired to [AuthBloc] / Supabase (email + password).
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signUp() {
    context.read<AuthBloc>().add(
          AuthSignUpRequested(
            email: _email.text.trim(),
            password: _password.text,
            fullName: _name.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? 'Sign up failed')));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundIconButton.back(onPressed: () => Navigator.pop(context)),
                const SizedBox(height: 22),
                Text(AppStrings.createAccount, style: AppTextStyles.h1),
                const SizedBox(height: 6),
                Text(AppStrings.signupSubtitle, style: AppTextStyles.body),
                const SizedBox(height: 24),
                AppTextField(label: AppStrings.fullName, controller: _name),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  controller: _email,
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.password,
                  controller: _password,
                  obscure: true,
                ),
                const SizedBox(height: 18),
                const _TermsRow(),
                const SizedBox(height: 22),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => PrimaryButton(
                    label: state.isLoading ? 'Creating…' : AppStrings.createAccount,
                    onPressed: _signUp,
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: AuthFooterPrompt(
                    prompt: AppStrings.alreadyHaveAccount,
                    action: AppStrings.login,
                    onTap: () => Navigator.pop(context),
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

class _TermsRow extends StatelessWidget {
  const _TermsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: AppStrings.agreePrefix,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.5,
              ),
              children: [
                _link(AppStrings.termsOfService),
                const TextSpan(text: AppStrings.and),
                _link(AppStrings.privacyPolicy),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _link(String text) => TextSpan(
        text: text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      );
}
