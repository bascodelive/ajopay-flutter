import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/auth_hero_header.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/auth_primary_button.dart';
import '../../application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final ok = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // On success, app_router's redirect (blueprint Section 5.3) reacts to
    // the AuthController status change on its own — no explicit
    // navigation needed here.
    if (!ok) {
      final controllerState = ref.read(authControllerProvider);
      final message = controllerState.errorMessage;
      final email = _emailController.text.trim();

      // Reverted from the errorCode-based check — that version depended
      // on AuthState growing an `errorCode` field (String?) that was
      // never actually added to auth_controller.dart, so it didn't
      // compile. Back to the substring match alone until that field
      // exists. Matches the fuller phrase the backend actually sends
      // for this case ("...verify your email address before logging
      // in"), not a bare 'verif' substring — that used to also match
      // unrelated text (e.g. Dio's own default exception message says
      // "...you typically have either to verify and fix your request
      // code", which contains 'verif' too).
      final isUnverified =
          message?.toLowerCase().contains('verify your email') ?? false;

      AppFeedback.showError(
        context,
        message ?? 'Login failed. Please try again.',
        action: isUnverified
            ? SnackBarAction(
                label: 'Verify',
                textColor: Colors.white,
                onPressed: () => context.go(
                  '/verify-email?email=${Uri.encodeComponent(email)}',
                ),
              )
            : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Full-bleed soft brand wash behind the hero + card, instead of a
      // flat scaffold background — see AjopayColors.surfaceAlt.
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
                  title: 'Welcome back',
                  subtitle: 'Log in to keep your circles moving.',
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
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Email is required'
                                  : null,
                        ),
                        const SizedBox(height: 18),
                        AuthTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
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
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Password is required'
                              : null,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: AjopayColors.primaryDark,
                            ),
                            onPressed: _isSubmitting
                                ? null
                                : () => context.push('/forgot-password'),
                            child: const Text('Forgot password?'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AuthPrimaryButton(
                          label: 'Log in',
                          isLoading: _isSubmitting,
                          onPressed: _isSubmitting ? null : _submit,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
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
                                  : () => context.go('/register'),
                              child: const Text('Create one'),
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
