import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/busy_overlay.dart';
import '../../../account/application/account_controller.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../../subscriptions/application/subscription_controller.dart';
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
    final profileAsync = ref.watch(accountControllerProvider);
    // PREMIUM feature — see PREMIUM-FEATURE-payout-slot-transfer.md.
    // Only needed for the offer-transfer action; reading/accepting an
    // open offer that's already visible is handled on TransferOffersScreen.
    final transfersAsync = ref.watch(circleSlotTransfersProvider(key));
	
	 // Fix: _offerTransfer previously did ref.read(circleParticipantsProvider(key))
    // with nothing on this screen ever watching it — an autoDispose
    // provider nobody watches is either unfetched or still in-flight at
    // read time, so valueOrNull was null almost every tap, not
    // occasionally. Watching it here, alongside everything else this
    // screen already loads in parallel, fixes that at the root.
    final participantsAsync = ref.watch(circleParticipantsProvider(key));

    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';
    final isActive = circleAsync.valueOrNull?.status == 'ACTIVE';
    final currentUserId = profileAsync.valueOrNull?.id;
    final isPremium =
        ref.watch(subscriptionControllerProvider).valueOrNull?.isPremium ??
            false;

    // Every offering slot that currently has an OPEN offer — used to
    // swap "Offer my turn" for "Offer pending" on that specific tile,
    // rather than letting someone create a second offer (the backend
    // would replace it silently; better the UI shows what's already true).
    final openOfferSlotIds = <String>{
      for (final t in transfersAsync.valueOrNull ?? const [])
        if (t.status == 'OFFERED') t.offeringSlotId,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotation queue'),
        actions: [
          IconButton(
            tooltip: 'Transfer offers',
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => context.push(
                '/ledgers/$ledgerId/circle/$circleId/transfer-offers'),
          ),
        ],
      ),
      body: rotationAsync.when(
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
		  
		  
		  // Who currently has something eligible to swap — used to keep
          // an already-paid-out participant out of the "offer to"
          // picker entirely, rather than showing them and letting the
          // request fail.
          final pendingSlotUserIds = slots
              .where((s) => s.status == 'PENDING')
              .map((s) => s.userId)
              .toSet();
		  
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
                final isOwnPaidSlot = slot.status == 'PAID' &&
                    currentUserId != null &&
                    slot.userId == currentUserId;
                final isOwnPendingSlot = slot.status == 'PENDING' &&
                    currentUserId != null &&
                    slot.userId == currentUserId;
                return _SlotTile(
                  ledgerId: ledgerId,
                  circleId: circleId,
                  slot: slot,
                  canConfirm: canConfirmThis,
                  canConfirmReceived:
                      isOwnPaidSlot && slot.recipientConfirmedAt == null,
                  canOfferTransfer: isOwnPendingSlot &&
                      isActive &&
                      !openOfferSlotIds.contains(slot.id),
                  hasOpenOfferOnThisSlot: isOwnPendingSlot &&
                      openOfferSlotIds.contains(slot.id),
                  isPremium: isPremium,
				  participants: participantsAsync.valueOrNull,
				  eligibleTargetUserIds: pendingSlotUserIds,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SlotTile extends ConsumerStatefulWidget {
  const _SlotTile({
    required this.ledgerId,
    required this.circleId,
    required this.slot,
    required this.canConfirm,
    required this.canConfirmReceived,
    required this.canOfferTransfer,
    required this.hasOpenOfferOnThisSlot,
    required this.isPremium,
	required this.participants,
	required this.eligibleTargetUserIds,
  });

  final String ledgerId;
  final String circleId;
  final RotationSlotResponse slot;
  final bool canConfirm;
  final bool canConfirmReceived;
  final bool canOfferTransfer;
  final bool hasOpenOfferOnThisSlot;
  final bool isPremium;
  final List<CircleParticipantResponse>? participants;
  final Set<String> eligibleTargetUserIds;

  @override
  ConsumerState<_SlotTile> createState() => _SlotTileState();
}

class _SlotTileState extends ConsumerState<_SlotTile> {
  bool _busy = false;

  Future<void> _confirm(BuildContext context) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm payout for ${widget.slot.userFullName}?'),
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

    setState(() => _busy = true);
    final ok = await ref.read(circleControllerProvider.notifier).confirmPayout(
          widget.ledgerId,
          widget.circleId,
          widget.slot.id,
          note: noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!context.mounted) return;
    if (ok) {
      AppFeedback.showSuccess(
          context, 'Payout confirmed for ${widget.slot.userFullName}');
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not confirm payout.');
    }
  }

  Future<void> _confirmReceived(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm you received this payout?'),
        content: const Text(
          'This just lets the group know the payout actually reached you '
          '— it doesn\'t change anything else about the rotation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, I received it'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    setState(() => _busy = true);
    final ok = await ref
        .read(circleControllerProvider.notifier)
        .confirmReceived(widget.ledgerId, widget.circleId, widget.slot.id);
    if (!mounted) return;
    setState(() => _busy = false);

    if (!context.mounted) return;
    if (ok) {
      AppFeedback.showSuccess(context, 'Thanks — receipt confirmed');
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not confirm receipt.');
    }
  }

  /// PREMIUM feature. Checked proactively BEFORE opening the target-
  /// picker sheet — same convention as the message composer's Premium
  /// gate (a proactive swap, not a tap-then-fail), so a Free-tier user
  /// never gets as far as picking a target only to have the request 400.
  Future<void> _offerTransfer(BuildContext context) async {
    if (!widget.isPremium) {
      final upgrade = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Offering a turn is a Premium feature'),
          content: const Text(
            'Upgrade to Premium to offer your upcoming turn to another '
            'participant.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Not now'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Upgrade'),
            ),
          ],
        ),
      );
      if (upgrade == true && context.mounted) {
        context.push('/subscription');
      }
      return;
    }

    final participants = widget.participants;
    if (participants == null) {
      AppFeedback.showError(
          context, 'Participants are still loading — try again in a moment.');
      return;
    }

    if (!context.mounted) return;
    final targetUserId = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Returned value: `''` means "open to anyone" (a real, chosen
      // selection — distinct from `null`, which means the sheet was
      // dismissed without a choice and nothing should happen next).
      builder: (context) => _OfferTargetSheet(
        currentUserId: widget.slot.userId,
        participants: participants,
		eligibleTargetUserIds: widget.eligibleTargetUserIds,
      ),
    );
    if (targetUserId == null) return; // sheet dismissed, no choice made
    if (!context.mounted) return;

    final targetName = targetUserId.isEmpty
        ? null
        : participants
            .firstWhere((p) => p.userId == targetUserId)
            .userFullName;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Offer your turn?'),
        content: Text(
          targetName != null
              ? 'This offers your upcoming turn to $targetName. They can '
                  'accept or decline; you can withdraw it anytime before '
                  'then.'
              : 'This offers your upcoming turn to any eligible participant. '
                  'Whoever accepts first gets it; you can withdraw it '
                  'anytime before then.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Offer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    setState(() => _busy = true);
    final transfer =
        await ref.read(circleControllerProvider.notifier).offerSlotTransfer(
              widget.ledgerId,
              widget.circleId,
              widget.slot.id,
              targetUserId: targetUserId.isEmpty ? null : targetUserId,
            );
    if (!mounted) return;
    setState(() => _busy = false);

    if (!context.mounted) return;
    if (transfer != null) {
      AppFeedback.showSuccess(context, 'Turn offered');
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not offer this turn.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.slot;
    final isPaid = slot.status == 'PAID';
    final receiptConfirmed = slot.recipientConfirmedAt != null;

    return BusyOverlay(
      busy: _busy,
      child: Card(
        child: Column(
          children: [
            ListTile(
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
              trailing: widget.canConfirm
                  ? ElevatedButton(
                      onPressed: () => _confirm(context),
                      child: const Text('Confirm'),
                    )
                  : Icon(
                      isPaid ? Icons.check_circle : Icons.schedule,
                      color: isPaid ? AjopayColors.primary : Colors.black38,
                    ),
            ),
            if (isPaid && receiptConfirmed) ...[
              const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.verified,
                        size: 16, color: AjopayColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Receipt confirmed by ${slot.userFullName}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AjopayColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ] else if (widget.canConfirmReceived) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Did you actually receive this payout?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _confirmReceived(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AjopayColors.primaryDark,
                        side: const BorderSide(color: AjopayColors.primaryDark),
                      ),
                      child: const Text('Confirm received'),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.canOfferTransfer) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Can\'t make this turn? Offer it to someone else.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _offerTransfer(context),
                      icon: const Icon(Icons.swap_horiz, size: 16),
                      label: const Text('Offer my turn'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AjopayColors.gold,
                        side: const BorderSide(color: AjopayColors.gold),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (widget.hasOpenOfferOnThisSlot) ...[
              const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.pending_outlined,
                        size: 16, color: AjopayColors.gold),
                    const SizedBox(width: 8),
                    Text(
                      'Offer pending on this turn',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AjopayColors.gold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Returns: `null` if dismissed without choosing, `''` for "open to
/// anyone," or a specific participant's userId.
class _OfferTargetSheet extends StatelessWidget {
  const _OfferTargetSheet({
    required this.currentUserId,
    required this.participants,
	required this.eligibleTargetUserIds,
  });

  final String currentUserId;
  final List<CircleParticipantResponse> participants;
  final Set<String> eligibleTargetUserIds;

   @override
  Widget build(BuildContext context) {
    final others = participants
        .where((p) =>
            p.userId != currentUserId && eligibleTargetUserIds.contains(p.userId))
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Offer your turn to',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.public, color: AjopayColors.gold),
              title: const Text('Anyone eligible'),
              subtitle:
                  const Text('First person who accepts it gets your turn'),
              onTap: () => Navigator.of(context).pop(''),
            ),
            if (others.isNotEmpty) ...[
              const Divider(height: 16),
              ...others.map((p) => ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(p.userFullName),
                    onTap: () => Navigator.of(context).pop(p.userId),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}