import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/auth_hero_header.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/auth_primary_button.dart';

import '../../application/auth_controller.dart';

/// API.md's documented Strong Password rule, applied client-side so the
/// person finds out before submitting, not just from the server's 400.
final _strongPasswordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

/// E.164 — leading '+', country code, no spaces/dashes.
final _e164Regex = RegExp(r'^\+[1-9]\d{6,14}$');

/// Accepts what people actually type for a Nigerian number — a leading
/// '0' local format (e.g. 08012345678) — and normalizes it to E.164
/// (+2348012345678) before it ever hits validation or the request body.
/// Anything already in +<country code> form passes through unchanged.
String _normalizePhone(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;
  if (trimmed.startsWith('0') && trimmed.length == 11) {
    return '+234${trimmed.substring(1)}';
  }
  return trimmed;
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final email = _emailController.text.trim();
    final response = await ref.read(authControllerProvider.notifier).register(
          email: email,
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          phone: _normalizePhone(_phoneController.text),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (response != null) {
      context.go('/verify-email?email=${Uri.encodeComponent(email)}');
    } else {
      final message = ref.read(authControllerProvider).errorMessage;
      AppFeedback.showError(
          context, message ?? 'Registration failed. Please try again.');
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
                  title: 'Join Ajopay',
                  subtitle: 'Save together with people you trust.',
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          controller: _fullNameController,
                          label: 'Full name',
                          icon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Full name is required'
                                  : null,
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Email is required';
                            if (!v.contains('@') || !v.contains('.')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          controller: _phoneController,
                          label: 'Phone',
                          hintText: '08012345678',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final v = _normalizePhone(value ?? '');
                            if (v.isEmpty) return 'Phone number is required';
                            if (!_e164Regex.hasMatch(v)) {
                              return 'Enter a valid phone number, e.g. 08012345678';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AjopayColors.textMuted,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (value) {
                            final v = value ?? '';
                            if (v.isEmpty) return 'Password is required';
                            if (!_strongPasswordRegex.hasMatch(v)) {
                              return 'At least 8 characters, with upper, lower, and a digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'Use 8+ characters with upper, lower, and a digit.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AjopayColors.textMuted,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm password',
                          icon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AjopayColors.textMuted,
                            ),
                            onPressed: () => setState(() =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        AuthPrimaryButton(
                          label: 'Create account',
                          isLoading: _isSubmitting,
                          onPressed: _isSubmitting ? null : _submit,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AjopayColors.textSecondary),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AjopayColors.primaryDark,
                              ),
                              onPressed: _isSubmitting
                                  ? null
                                  : () => context.go('/login'),
                              child: const Text('Log in'),
                            ),
                          ],
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
