import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../application/ledger_controller.dart';
import '../../data/models/ledger_models.dart';

const _frequencies = ['DAILY', 'WEEKLY', 'MONTHLY'];

/// Router entry point for `/ledgers/:id/edit` — fetches the ledger first,
/// since EditLedgerScreen below needs the full LedgerResponse to prefill
/// the form, not just an ID. Keeps app_router.dart's route builder simple.
class EditLedgerRoute extends ConsumerWidget {
  const EditLedgerRoute({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(ledgerDetailProvider(ledgerId));

    return ledgerAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Edit ledger')),
        body: const AppBackdrop(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Edit ledger')),
        body: const AppBackdrop(
          child: Center(child: Text('Could not load this ledger.')),
        ),
      ),
      data: (ledger) => EditLedgerScreen(ledger: ledger),
    );
  }
}

class EditLedgerScreen extends ConsumerStatefulWidget {
  const EditLedgerScreen({super.key, required this.ledger});

  final LedgerResponse ledger;

  @override
  ConsumerState<EditLedgerScreen> createState() => _EditLedgerScreenState();
}

class _EditLedgerScreenState extends ConsumerState<EditLedgerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.ledger.name);
  late final _amountController = TextEditingController(
      text: widget.ledger.contributionAmount.toStringAsFixed(0));
  late String _frequency = widget.ledger.contributionFrequency;

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
    final ok = await ref.read(ledgerControllerProvider.notifier).update(
          ledgerId: widget.ledger.id,
          name: _nameController.text.trim(),
          contributionFrequency: _frequency,
          contributionAmount: double.parse(_amountController.text.trim()),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ok) {
      ref.invalidate(ledgerDetailProvider(widget.ledger.id));
      ref.invalidate(myLedgersProvider);
      if (!mounted) return;
      AppFeedback.showSuccess(context, 'Ledger updated');
      context.pop();
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not update ledger. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit ledger')),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: AjopayColors.primaryTint,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              size: 20, color: AjopayColors.primaryDark),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Changing the amount only affects contributions '
                              'scheduled after this change — nothing already '
                              'scheduled is retroactively affected.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AjopayColors.primaryDark,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Ledger name',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? 'Ledger name is required'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _frequency,
                            decoration: const InputDecoration(
                              labelText: 'Contribution frequency',
                              prefixIcon: Icon(Icons.repeat),
                            ),
                            items: _frequencies
                                .map((f) => DropdownMenuItem(
                                      value: f,
                                      child: Text(
                                          '${f[0]}${f.substring(1).toLowerCase()}'),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(
                                () => _frequency = value ?? _frequency),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Contribution amount',
                              prefixIcon: Icon(Icons.payments_outlined),
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppPrimaryButton(
                    label: 'Save changes',
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