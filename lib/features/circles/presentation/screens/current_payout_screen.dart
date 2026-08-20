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
          // "Yet to pay" combines pending (still might pay) and missed
          // (settled, won't pay) — the two-banner view is about the
          // simple paid-vs-not split every participant can act on; the
          // finer pending-vs-missed distinction only matters for WHY
          // the Confirm button is or isn't available, shown separately
          // below.
          final yetToPay = payout.pendingCount + payout.missedCount;

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
                  const SizedBox(height: 16),
                  // The two-banner transparency view — makes it visible
                  // to every participant (not just the Admin) exactly
                  // who's responsible for a payout not being confirmed
                  // yet: the participants who haven't paid, not the
                  // Admin sitting on it.
                  Row(
                    children: [
                      Expanded(
                        child: _CountBanner(
                          icon: Icons.check_circle_outline,
                          color: AjopayColors.success,
                          count: payout.paidCount,
                          label: 'Paid',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CountBanner(
                          icon: Icons.hourglass_top,
                          color: AjopayColors.gold,
                          count: yetToPay,
                          label: 'Yet to pay',
                        ),
                      ),
                    ],
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: 24),
                    if (!payout.canConfirmPayout)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                size: 18, color: AjopayColors.textMuted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${payout.pendingCount} participant${payout.pendingCount == 1 ? '' : 's'} '
                                'still ${payout.pendingCount == 1 ? 'hasn\'t' : 'haven\'t'} paid or reported '
                                'for this cycle — payout can\'t be confirmed until everyone has paid, '
                                'reported, or been marked missed.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AjopayColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ElevatedButton(
                      onPressed: payout.canConfirmPayout
                          ? () => _confirm(
                              context, ref, payout.slotId, payout.userFullName)
                          : null,
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

class _CountBanner extends StatelessWidget {
  const _CountBanner({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}