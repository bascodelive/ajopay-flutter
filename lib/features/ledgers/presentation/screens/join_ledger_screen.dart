import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/brand_underline.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../application/ledger_controller.dart';
import '../../data/models/ledger_models.dart';

class JoinLedgerScreen extends ConsumerStatefulWidget {
  const JoinLedgerScreen({super.key});

  @override
  ConsumerState<JoinLedgerScreen> createState() => _JoinLedgerScreenState();
}

class _JoinLedgerScreenState extends ConsumerState<JoinLedgerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isSubmitting = false;

  /// Non-null once a join request has actually been sent. Holding the
  /// result here — rather than navigating away immediately — is the
  /// whole fix: a join is no longer instant access, so this screen must
  /// be able to show a "request sent, awaiting approval" state instead
  /// of just always pushing into LedgerDetailScreen (which a still-
  /// PENDING caller has no access to at all — that screen's provider is
  /// ACTIVE-membership-gated server-side and would just 403).
  LedgerResponse? _joinedLedger;

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

    if (ledger == null) {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(
        context,
        message ?? 'Could not join ledger. Check the code and try again.',
      );
      return;
    }

    if (ledger.membershipStatus == 'ACTIVE') {
      // Only reachable if the caller was already an active member of
      // this ledger before (server treats a repeat join as a no-op) —
      // safe to go straight in.
      ref.invalidate(myLedgersProvider);
      ref.invalidate(ledgerLimitProvider);
      if (!mounted) return;
      context.pushReplacement('/ledgers/${ledger.id}');
      return;
    }

    // membershipStatus is PENDING (the normal case for a brand-new
    // request) — show the "request sent" state below instead of
    // navigating anywhere the caller doesn't have access to yet.
    setState(() => _joinedLedger = ledger);
  }

  @override
  Widget build(BuildContext context) {
    if (_joinedLedger != null) {
      return _RequestSentView(ledger: _joinedLedger!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Join ledger')),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AjopayColors.primaryTint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.group_add_outlined,
                        color: AjopayColors.primaryDark, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter your invite code',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const BrandUnderline(width: 32),
                  const SizedBox(height: 16),
                  Text(
                    "Ask the ledger's Admin for the 8-character code they received "
                    'when they created it. Joining sends a request — the '
                    "Admin needs to approve it before you're in.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AjopayColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _codeController,
                        textCapitalization: TextCapitalization.characters,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  letterSpacing: 2,
                                ),
                        decoration: const InputDecoration(
                          labelText: 'Invite code',
                          hintText: 'e.g. A1B2C3D4',
                          prefixIcon: Icon(Icons.confirmation_number_outlined),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Invite code is required'
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: 'Send join request',
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

/// Shown after a successful join whose membershipStatus is PENDING — a
/// deliberately calm, reassuring state rather than a bare snackbar, since
/// this is a genuine wait ("the Admin might not be in the app yet") and
/// the person deserves more than a toast telling them nothing happened.
class _RequestSentView extends StatelessWidget {
  const _RequestSentView({required this.ledger});

  final LedgerResponse ledger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join ledger')),
      body: AppBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        color: AjopayColors.primaryTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hourglass_top_rounded,
                        size: 42,
                        color: AjopayColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Request sent',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 8),
                    const BrandUnderline(width: 32),
                    const SizedBox(height: 16),
                    Text(
                      "You've asked to join",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AjopayColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ledger.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                size: 20, color: AjopayColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "The ledger's Admin has been notified and needs "
                                "to approve your request. You'll be able to see "
                                "this ledger here as soon as that happens.",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppPrimaryButton(
                      label: 'Back to my ledgers',
                      onPressed: () => context.go('/'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
