import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/busy_overlay.dart';
import '../../../account/application/account_controller.dart';
import '../../application/circle_controller.dart';
import '../../data/models/circle_models.dart';

/// PREMIUM feature — see PREMIUM-FEATURE-payout-slot-transfer.md. Every
/// mutation here (accept/decline/cancel) goes through a confirmation
/// dialog and a full-screen BusyOverlay while in flight — nothing stays
/// tappable mid-request, not just the triggering button.
class TransferOffersScreen extends ConsumerWidget {
  const TransferOffersScreen({
    super.key,
    required this.ledgerId,
    required this.circleId,
  });

  final String ledgerId;
  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (ledgerId: ledgerId, circleId: circleId);
    final transfersAsync = ref.watch(circleSlotTransfersProvider(key));

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer offers')),
      body: transfersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AjopayColors.error),
                const SizedBox(height: 12),
                const Text('Could not load transfer offers.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(circleSlotTransfersProvider(key)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (transfers) {
          if (transfers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swap_horiz,
                        size: 56, color: AjopayColors.primary),
                    const SizedBox(height: 16),
                    Text('No transfer offers yet',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'A participant can offer their upcoming turn to '
                      'someone else from the rotation queue.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }

          // Open offers first (the ones that actually need attention),
          // then resolved ones — the backend already returns newest-first
          // overall, so partitioning preserves that order within each group.
          final open = transfers.where((t) => t.status == 'OFFERED').toList();
          final resolved =
              transfers.where((t) => t.status != 'OFFERED').toList();

          return RefreshIndicator(
            onRefresh: () =>
                ref.refresh(circleSlotTransfersProvider(key).future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                if (open.isNotEmpty) ...[
                  const _SectionLabel(text: 'Open'),
                  ...open.map((t) => _TransferCard(
                        ledgerId: ledgerId,
                        circleId: circleId,
                        transfer: t,
                      )),
                  const SizedBox(height: 16),
                ],
                if (resolved.isNotEmpty) ...[
                  const _SectionLabel(text: 'Resolved'),
                  ...resolved.map((t) => _TransferCard(
                        ledgerId: ledgerId,
                        circleId: circleId,
                        transfer: t,
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AjopayColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _TransferCard extends ConsumerStatefulWidget {
  const _TransferCard({
    required this.ledgerId,
    required this.circleId,
    required this.transfer,
  });

  final String ledgerId;
  final String circleId;
  final PayoutSlotTransferResponse transfer;

  @override
  ConsumerState<_TransferCard> createState() => _TransferCardState();
}

class _TransferCardState extends ConsumerState<_TransferCard> {
  bool _busy = false;

  Color _statusColor(String status) => switch (status) {
        'OFFERED' => AjopayColors.gold,
        'ACCEPTED' => AjopayColors.primary,
        'EXPIRED' => AjopayColors.error,
        _ => AjopayColors.textMuted, // DECLINED, CANCELLED
      };

  Future<void> _confirmAndRun({
    required String title,
    required String content,
    required String confirmLabel,
    required Future<bool> Function() action,
    required String successMessage,
    required String fallbackErrorMessage,
    bool destructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: destructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: AjopayColors.error,
                    foregroundColor: Colors.white,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _busy = true);
    final ok = await action();
    if (!mounted) return;
    setState(() => _busy = false);

    if (ok) {
      AppFeedback.showSuccess(context, successMessage);
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? fallbackErrorMessage);
    }
  }

  Future<void> _accept() async {
    // The caller's own eligible PENDING slot in this circle — the
    // single-hand restriction (see backend) means there's at most one,
    // so this is resolvable without asking the person to pick.
    final key = (ledgerId: widget.ledgerId, circleId: widget.circleId);
    final rotation = ref.read(circleRotationProvider(key)).valueOrNull;
    final myUserId = ref.read(accountControllerProvider).valueOrNull?.id;

    RotationSlotResponse? mySlot;
    if (rotation != null) {
      for (final s in rotation) {
        if (s.userId == myUserId && s.status == 'PENDING') {
          mySlot = s;
          break;
        }
      }
    }

    if (mySlot == null) {
      AppFeedback.showError(
          context, 'You have no pending slot in this circle to swap in.');
      return;
    }
    final acceptingSlotId = mySlot.id;

    await _confirmAndRun(
      title: 'Accept this transfer?',
      content:
          "You'll take over ${widget.transfer.offeredByFullName}'s upcoming "
          "turn, and they'll take yours instead. This can't be undone.",
      confirmLabel: 'Accept',
      action: () =>
          ref.read(circleControllerProvider.notifier).acceptSlotTransfer(
                widget.ledgerId,
                widget.circleId,
                widget.transfer.id,
                acceptingSlotId,
              ),
      successMessage: 'Transfer accepted — positions swapped',
      fallbackErrorMessage: 'Could not accept this transfer.',
    );
  }

  Future<void> _decline() async {
    await _confirmAndRun(
      title: 'Decline this offer?',
      content: "You won't take over this turn. The offer stays open for "
          "anyone else it's available to, unless the offerer withdraws it.",
      confirmLabel: 'Decline',
      action: () =>
          ref.read(circleControllerProvider.notifier).declineSlotTransfer(
                widget.ledgerId,
                widget.circleId,
                widget.transfer.id,
              ),
      successMessage: 'Offer declined',
      fallbackErrorMessage: 'Could not decline this offer.',
    );
  }

  Future<void> _cancel() async {
    await _confirmAndRun(
      title: 'Withdraw this offer?',
      content: 'Nobody will be able to accept it anymore.',
      confirmLabel: 'Withdraw',
      destructive: true,
      action: () =>
          ref.read(circleControllerProvider.notifier).cancelSlotTransfer(
                widget.ledgerId,
                widget.circleId,
                widget.transfer.id,
              ),
      successMessage: 'Offer withdrawn',
      fallbackErrorMessage: 'Could not withdraw this offer.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final transfer = widget.transfer;
    final myUserId = ref.watch(accountControllerProvider).valueOrNull?.id;
    final isOfferer = myUserId != null && myUserId == transfer.offeredByUserId;
    final isEligibleToRespond = transfer.status == 'OFFERED' &&
        !isOfferer &&
        (transfer.targetUserId == null || transfer.targetUserId == myUserId);

    return BusyOverlay(
      busy: _busy,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _statusColor(transfer.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    transfer.status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _statusColor(transfer.status),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: transfer.targetUserId != null
                          ? AjopayColors.primaryTint
                          : AjopayColors.goldTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      transfer.targetUserId != null ? 'Targeted' : 'Open',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: transfer.targetUserId != null
                                ? AjopayColors.primaryDark
                                : AjopayColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${transfer.offeredByFullName} offered their turn'
                '${transfer.targetUserId != null ? ' to ${transfer.targetUserFullName}' : ''}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (transfer.status == 'ACCEPTED' &&
                  transfer.acceptedByFullName != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Accepted by ${transfer.acceptedByFullName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AjopayColors.textSecondary,
                      ),
                ),
              ],
              if (isOfferer && transfer.status == 'OFFERED') ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: _cancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AjopayColors.error,
                      side: const BorderSide(color: AjopayColors.error),
                    ),
                    child: const Text('Withdraw'),
                  ),
                ),
              ] else if (isEligibleToRespond) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _decline,
                      child: const Text('Decline'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _accept,
                      child: const Text('Accept'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}