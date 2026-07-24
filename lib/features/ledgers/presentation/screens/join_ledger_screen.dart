import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../application/ledger_controller.dart';

class JoinLedgerScreen extends ConsumerStatefulWidget {
  const JoinLedgerScreen({super.key});

  @override
  ConsumerState<JoinLedgerScreen> createState() => _JoinLedgerScreenState();
}

class _JoinLedgerScreenState extends ConsumerState<JoinLedgerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final ledger = await ref
        .read(ledgerControllerProvider.notifier)
        .join(_codeController.text.trim());

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ledger != null) {
      ref.invalidate(myLedgersProvider);
      if (!mounted) return;
      context.pushReplacement('/ledgers/${ledger.id}');
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(
        context,
        message ?? 'Could not join ledger. Check the code and try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join ledger')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter your invite code',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ask the ledger's Admin for the 8-character code they received "
                  'when they created it.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Invite code',
                    hintText: 'e.g. A1B2C3D4',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Invite code is required'
                      : null,
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
                      : const Text('Join'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
