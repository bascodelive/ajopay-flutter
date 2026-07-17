import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified — you can log in now.')),
      );
      context.go('/login');
    } else {
      final message = ref.read(authControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message ?? 'Verification failed. Please try again.')),
      );
    }
  }

  Future<void> _resend() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first')),
      );
      return;
    }

    setState(() => _isResending = true);
    await ref.read(authControllerProvider.notifier).resendVerification(email);
    if (!mounted) return;
    setState(() => _isResending = false);

    final state = ref.read(authControllerProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.infoMessage ??
              state.errorMessage ??
              'If needed, a new code was sent.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Check your inbox',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code we sent. It expires after 24 hours, '
                  'and locks after 5 wrong attempts — resend if that happens.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Email is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: '6-digit code',
                    counterText: '',
                  ),
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
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Verify'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isResending ? null : _resend,
                  child: _isResending
                      ? const Text('Sending...')
                      : const Text('Resend code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
