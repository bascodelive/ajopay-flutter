import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/auth_hero_header.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/auth_primary_button.dart';
import '../../application/auth_controller.dart';

final _sixDigitRegex = RegExp(r'^\d{6}$');

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key, required this.initialEmail});

  final String initialEmail;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController =
      TextEditingController(text: widget.initialEmail);
  final _codeController = TextEditingController();

  bool _isSubmitting = false;
  bool _isResending = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final ok = await ref.read(authControllerProvider.notifier).verifyEmail(
          email: _emailController.text.trim(),
          code: _codeController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ok) {
      if (!mounted) return;
      AppFeedback.showSuccess(context, 'Email verified — you can log in now.');
      context.go('/login');
    } else {
      final message = ref.read(authControllerProvider).errorMessage;
      AppFeedback.showError(
          context, message ?? 'Verification failed. Please try again.');
    }
  }

  Future<void> _resend() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      AppFeedback.showInfo(context, 'Enter your email first');
      return;
    }

    setState(() => _isResending = true);
    await ref.read(authControllerProvider.notifier).resendVerification(email);
    if (!mounted) return;
    setState(() => _isResending = false);

    final state = ref.read(authControllerProvider);
    AppFeedback.showInfo(
      context,
      state.infoMessage ??
          state.errorMessage ??
          'If needed, a new code was sent.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AjopayColors.surface,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AjopayColors.surfaceAlt, AjopayColors.surface],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeroHeader(
                  title: 'Check your inbox',
                  subtitle:
                      'Enter the 6-digit code we sent. It expires after 24 '
                      'hours, and locks after 5 wrong attempts — resend if '
                      'that happens.',
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Email is required'
                                  : null,
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          controller: _codeController,
                          label: '6-digit code',
                          icon: Icons.pin_outlined,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Code is required';
                            if (!_sixDigitRegex.hasMatch(v)) {
                              return 'Enter all 6 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthPrimaryButton(
                          label: 'Verify',
                          isLoading: _isSubmitting,
                          onPressed: _isSubmitting ? null : _submit,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: AjopayColors.primaryDark,
                            ),
                            onPressed: _isResending ? null : _resend,
                            child: _isResending
                                ? const Text(
                                    'Sending...',
                                    style: TextStyle(
                                      color: AjopayColors.textMuted,
                                    ),
                                  )
                                : const Text('Resend code'),
                          ),
                        ),
                      ],
                    ),
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
