import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/circle_controller.dart';
import '../../data/models/circle_models.dart';

class RotationQueueScreen extends ConsumerWidget {
  const RotationQueueScreen({
    super.key,
    required this.ledgerId,
    required this.circleId,
  });

  final String ledgerId;
  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (ledgerId: ledgerId, circleId: circleId);
    final rotationAsync = ref.watch(circleRotationProvider(key));
    final ledgerAsync = ref.watch(ledgerDetailProvider(ledgerId));
    final circleAsync = ref.watch(currentCircleProvider(ledgerId));

    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';
    final isActive = circleAsync.valueOrNull?.status == 'ACTIVE';

    return Scaffold(
      appBar: AppBar(title: const Text('Rotation queue')),
      body: rotationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: AjopayColors.error),
                const SizedBox(height: 12),
                const Text('Could not load the rotation queue.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(circleRotationProvider(key)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (slots) {
          if (slots.isEmpty) {
            return const Center(child: Text('No rotation order assigned yet.'));
          }

          // Strictly sequential per the backend — only the FIRST PENDING
          // slot in position order is ever confirmable. Find it once,
          // not per-item, so exactly one row ever shows the action.
          final nextPendingId = slots
              .where((s) => s.status == 'PENDING')
              .fold<RotationSlotResponse?>(null, (earliest, s) {
            if (earliest == null || s.position < earliest.position) return s;
            return earliest;
          })?.id;

          return RefreshIndicator(
            onRefresh: () => ref.refresh(circleRotationProvider(key).future),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: slots.length,
              separatorBuilder: (context, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final slot = slots[index];
                final canConfirmThis =
                    isAdmin && isActive && slot.id == nextPendingId;
                return _SlotTile(
                  ledgerId: ledgerId,
                  circleId: circleId,
                  slot: slot,
                  canConfirm: canConfirmThis,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SlotTile extends ConsumerWidget {
  const _SlotTile({
    required this.ledgerId,
    required this.circleId,
    required this.slot,
    required this.canConfirm,
  });

  final String ledgerId;
  final String circleId;
  final RotationSlotResponse slot;
  final bool canConfirm;

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm payout for ${slot.userFullName}?'),
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

    final ok = await ref.read(circleControllerProvider.notifier).confirmPayout(
          ledgerId,
          circleId,
          slot.id,
          note: noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
        );

    if (!context.mounted) return;
    if (ok) {
      AppFeedback.showSuccess(
          context, 'Payout confirmed for ${slot.userFullName}');
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not confirm payout.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = slot.status == 'PAID';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isPaid ? AjopayColors.primaryTint : Colors.grey.shade200,
          child: Text(
            '${slot.position + 1}',
            style: TextStyle(
              color: isPaid ? AjopayColors.primaryDark : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(slot.userFullName),
        subtitle: Text(
          [
            'Hand ${slot.handNumber}',
            if (slot.scheduledDate != null) slot.scheduledDate!,
            if (isPaid && slot.amount != null)
              '₦${slot.amount!.toStringAsFixed(0)} paid',
          ].join(' · '),
        ),
        trailing: canConfirm
            ? ElevatedButton(
                onPressed: () => _confirm(context, ref),
                child: const Text('Confirm'),
              )
            : Icon(
                isPaid ? Icons.check_circle : Icons.schedule,
                color: isPaid ? AjopayColors.primary : Colors.black38,
              ),
      ),
    );
  }
}
