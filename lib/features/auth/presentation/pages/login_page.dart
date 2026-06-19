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
import '../widgets/social_button.dart';

/// Email login screen, wired to [AuthBloc] / Supabase.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthBloc>().add(
          AuthLoginRequested(email: _email.text.trim(), password: _password.text),
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
              ..showSnackBar(SnackBar(content: Text(state.error ?? 'Login failed')));
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
                Text(AppStrings.welcomeBack, style: AppTextStyles.h1),
                const SizedBox(height: 6),
                Text(AppStrings.loginSubtitle, style: AppTextStyles.body),
                const SizedBox(height: 26),
                AppTextField(
                  label: 'Email',
                  controller: _email,
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  icon: const Icon(Icons.mail_outline_rounded,
                      size: 19, color: AppColors.textFaint),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.password,
                  controller: _password,
                  obscure: true,
                  icon: const Icon(Icons.lock_outline_rounded,
                      size: 19, color: AppColors.textFaint),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.forgot),
                    child: Text(
                      AppStrings.forgotPassword,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => PrimaryButton(
                    label: state.isLoading ? 'Signing in…' : AppStrings.login,
                    onPressed: _login,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(AppStrings.orContinueWith,
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textFaint)),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 22),
                const Row(
                  children: [
                    Expanded(
                      child: SocialButton(
                        label: AppStrings.google,
                        glyph: BrandGlyph(
                            icon: Icons.g_mobiledata_rounded,
                            color: Color(0xFF4285F4)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SocialButton(
                        label: AppStrings.apple,
                        glyph: BrandGlyph(icon: Icons.apple, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: AuthFooterPrompt(
                    prompt: AppStrings.newToWassalny,
                    action: AppStrings.createAccount,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
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
