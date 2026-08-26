import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../bloc/auth_bloc.dart';

/// Password-reset code entry screen — 6 real digit fields, verified against
/// Supabase via [PasswordResetCodeVerified].
class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.email});

  final String email;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? _localError;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verify() {
    if (_code.length != 6) {
      setState(() => _localError = AppStrings.invalidCode);
      return;
    }
    setState(() => _localError = null);
    context.read<AuthBloc>().add(
          PasswordResetCodeVerified(email: widget.email, code: _code),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.passwordResetStatus != c.passwordResetStatus,
        listener: (context, state) {
          if (state.passwordResetStatus == PasswordResetStatus.codeVerified) {
            Navigator.pushReplacementNamed(context, AppRoutes.newPassword);
          } else if (state.passwordResetStatus == PasswordResetStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(state.passwordResetError ?? 'Invalid code')));
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
                  child: const Icon(Icons.dialpad_rounded,
                      color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.verifyNumberTitle, style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    text: '${AppStrings.verifyNumberSubtitle}\n',
                    style: AppTextStyles.body,
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    for (var i = 0; i < 6; i++) ...[
                      _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        onChanged: (v) => _onDigitChanged(i, v),
                      ),
                      if (i != 5) const SizedBox(width: 8),
                    ],
                  ],
                ),
                if (_localError != null) ...[
                  const SizedBox(height: 10),
                  Text(_localError!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.danger)),
                ],
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) =>
                      p.passwordResetStatus != c.passwordResetStatus,
                  builder: (context, state) => TextButton(
                    onPressed: state.passwordResetStatus ==
                            PasswordResetStatus.loading
                        ? null
                        : () => context
                            .read<AuthBloc>()
                            .add(PasswordResetRequested(widget.email)),
                    child: Text(AppStrings.didntGetCode + AppStrings.resendCodeAction,
                        style: AppTextStyles.bodySm),
                  ),
                ),
                const Spacer(),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (p, c) =>
                      p.passwordResetStatus != c.passwordResetStatus,
                  builder: (context, state) => PrimaryButton(
                    label: state.passwordResetStatus == PasswordResetStatus.loading
                        ? 'Verifying…'
                        : AppStrings.verify,
                    onPressed: state.passwordResetStatus ==
                            PasswordResetStatus.loading
                        ? null
                        : _verify,
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

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 44 / 56,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1.6),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTextStyles.h2.copyWith(fontSize: 22),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
