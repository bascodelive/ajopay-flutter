import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/circle_controller.dart';

class CurrentPayoutScreen extends ConsumerWidget {
  const CurrentPayoutScreen({
    super.key,
    required this.ledgerId,
    required this.circleId,
  });

  final String ledgerId;
  final String circleId;

  Future<void> _confirm(BuildContext context, WidgetRef ref, String slotId,
      String userFullName) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm payout for $userFullName?'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Note (optional)',
            hintText: 'e.g. paid via bank transfer',
          ),
          maxLength: 500,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    final key = (ledgerId: ledgerId, circleId: circleId);
    final ok = await ref.read(circleControllerProvider.notifier).confirmPayout(
          ledgerId,
          circleId,
          slotId,
          note: noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
        );

    if (!context.mounted) return;
    if (ok) {
      ref.invalidate(currentPayoutProvider(key));
      AppFeedback.showSuccess(context, 'Payout confirmed for $userFullName');
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not confirm payout.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (ledgerId: ledgerId, circleId: circleId);
    final payoutAsync = ref.watch(currentPayoutProvider(key));
    final ledgerAsync = ref.watch(ledgerDetailProvider(ledgerId));
    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';

    return Scaffold(
      appBar: AppBar(title: const Text('Current payout')),
      body: payoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          // API.md: 404 means no pending slot remains — circle may
          // already be complete. A real, expected outcome, not a failure.
          if (error is ApiException && error.isNotFound) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 56, color: AjopayColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'No pending payout',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Every hand in this circle has been paid.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AjopayColors.error),
                  const SizedBox(height: 12),
                  const Text('Could not load the current payout.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(currentPayoutProvider(key)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (payout) {
          final progress = payout.targetAmount > 0
              ? (payout.confirmedSoFar / payout.targetAmount)
                  .clamp(0.0, 1.0)
                  .toDouble()
              : 0.0;

          return RefreshIndicator(
            onRefresh: () => ref.refresh(currentPayoutProvider(key).future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "It's ${payout.userFullName}'s turn",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hand ${payout.handNumber} · Scheduled ${payout.scheduledDate}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: AjopayColors.surface,
                              color: AjopayColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confirmed so far',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  Text(
                                    '₦${payout.confirmedSoFar.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AjopayColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Target (full participation)',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  Text(
                                    '₦${payout.targetAmount.toStringAsFixed(0)}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Target is informational only — the confirmed figure '
                              'is what\'s actually been received.',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _confirm(
                          context, ref, payout.slotId, payout.userFullName),
                      child: const Text('Confirm payout'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
