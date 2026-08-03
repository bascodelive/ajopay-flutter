import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/auth_hero_header.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/auth_primary_button.dart';
import '../../application/account_controller.dart';

final _strongPasswordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
final _sixDigitRegex = RegExp(r'^\d{6}$');

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.initialEmail});

  final String initialEmail;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController =
      TextEditingController(text: widget.initialEmail);
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final ok = await ref.read(accountControllerProvider.notifier).resetPassword(
          email: _emailController.text.trim(),
          code: _codeController.text.trim(),
          newPassword: _newPasswordController.text,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ok) {
      AppFeedback.showSuccess(
          context, 'Password reset — log in with your new password.');
      context.go('/login');
    } else {
      final message = ref.read(accountControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not reset password. Try again.');
    }
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
            stops: [0.0, 0.35],
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
                      'Enter the 6-digit code, then choose a new password.',
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
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Code is required';
                            if (!_sixDigitRegex.hasMatch(v)) {
                              return 'Enter all 6 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          controller: _newPasswordController,
                          label: 'New password',
                          icon: Icons.lock_outline,
                          obscureText: _obscureNew,
                          textInputAction: TextInputAction.next,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNew
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AjopayColors.textMuted,
                            ),
                            onPressed: () =>
                                setState(() => _obscureNew = !_obscureNew),
                          ),
                          validator: (value) {
                            final v = value ?? '';
                            if (v.isEmpty) return 'New password is required';
                            if (!_strongPasswordRegex.hasMatch(v)) {
                              return 'At least 8 characters, with upper, lower, and a digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm new password',
                          icon: Icons.lock_outline,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AjopayColors.textMuted,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        AuthPrimaryButton(
                          label: 'Reset password',
                          isLoading: _isSubmitting,
                          onPressed: _isSubmitting ? null : _submit,
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
