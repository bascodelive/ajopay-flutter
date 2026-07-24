import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../application/ledger_controller.dart';

const _frequencies = ['DAILY', 'WEEKLY', 'MONTHLY'];

class CreateLedgerScreen extends ConsumerStatefulWidget {
  const CreateLedgerScreen({super.key});

  @override
  ConsumerState<CreateLedgerScreen> createState() => _CreateLedgerScreenState();
}

class _CreateLedgerScreenState extends ConsumerState<CreateLedgerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _frequency = 'MONTHLY';

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final ledger = await ref.read(ledgerControllerProvider.notifier).create(
          name: _nameController.text.trim(),
          contributionFrequency: _frequency,
          contributionAmount: double.parse(_amountController.text.trim()),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ledger != null) {
      ref.invalidate(myLedgersProvider);
      if (!mounted) return;
      context.pushReplacement('/ledgers/${ledger.id}');
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not create ledger. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create ledger')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Start a savings group',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "You'll automatically become this ledger's Admin. "
                  "Free-tier accounts can have one active ledger.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Ledger name',
                    hintText: 'e.g. Market Traders Circle',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Ledger name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: const InputDecoration(
                      labelText: 'Contribution frequency'),
                  items: _frequencies
                      .map((f) => DropdownMenuItem(
                            value: f,
                            child:
                                Text('${f[0]}${f.substring(1).toLowerCase()}'),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _frequency = value ?? _frequency),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Contribution amount',
                    prefixText: '₦ ',
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Amount is required';
                    final parsed = double.tryParse(v);
                    if (parsed == null || parsed <= 0) {
                      return 'Enter an amount greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
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
                      : const Text('Create ledger'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
