import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../application/account_controller.dart';

final _strongPasswordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change password?'),
        content: const Text(
          'This will sign you out of every device, including this one — '
          "you'll need to log in again with your new password.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (proceed != true) return;

    setState(() => _isSubmitting = true);
    final ok =
        await ref.read(accountControllerProvider.notifier).changePassword(
              currentPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
            );

    if (!mounted) return;

    if (!ok) {
      setState(() => _isSubmitting = false);
      final message = ref.read(accountControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not change password. Try again.');
    }
    // On success, AccountController already called AuthController.forceLogout()
    // — app_router's redirect (blueprint Section 5.3) handles navigation
    // back to /login on its own, no explicit nav needed here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change password')),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_reset_rounded,
                      size: 40, color: AjopayColors.primary),
                  const SizedBox(height: 12),
                  Text(
                    'Choose a new password',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "You'll be signed out of every device once this is done.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AjopayColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 28),
                  AuthTextField(
                    controller: _currentPasswordController,
                    label: 'Current password',
                    icon: Icons.lock_outline,
                    obscureText: _obscureCurrent,
                    textInputAction: TextInputAction.next,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrent
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AjopayColors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Current password is required'
                        : null,
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
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
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
                  const SizedBox(height: 32),
                  AppPrimaryButton(
                    label: 'Change password',
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
