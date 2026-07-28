import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/circle_controller.dart';
import '../../data/models/circle_models.dart';

class CircleParticipantsScreen extends ConsumerWidget {
  const CircleParticipantsScreen({
    super.key,
    required this.ledgerId,
    required this.circleId,
  });

  final String ledgerId;
  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (ledgerId: ledgerId, circleId: circleId);
    final participantsAsync = ref.watch(circleParticipantsProvider(key));
    final ledgerAsync = ref.watch(ledgerDetailProvider(ledgerId));
    final circleAsync = ref.watch(currentCircleProvider(ledgerId));

    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';
    final isPending = circleAsync.valueOrNull?.status == 'PENDING';
    final canEdit = isAdmin && isPending;

    return Scaffold(
      appBar: AppBar(title: const Text('Participants')),
      body: participantsAsync.when(
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
                const Text('Could not load participants.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(circleParticipantsProvider(key)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (participants) => RefreshIndicator(
          onRefresh: () => ref.refresh(circleParticipantsProvider(key).future),
          child: participants.isEmpty
              ? _EmptyParticipants(canEdit: canEdit)
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: participants.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _ParticipantTile(
                    ledgerId: ledgerId,
                    circleId: circleId,
                    participant: participants[index],
                    canEdit: canEdit,
                  ),
                ),
        ),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () => _showAddParticipantSheet(context, ref),
              icon: const Icon(Icons.person_add_alt),
              label: const Text('Add'),
            )
          : null,
    );
  }

  void _showAddParticipantSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          _AddParticipantSheet(ledgerId: ledgerId, circleId: circleId),
    );
  }
}

class _EmptyParticipants extends StatelessWidget {
  const _EmptyParticipants({required this.canEdit});

  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.groups_outlined,
                      size: 56, color: AjopayColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'No participants yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (canEdit) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Tap Add to bring in ledger members and set their hand counts.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticipantTile extends ConsumerWidget {
  const _ParticipantTile({
    required this.ledgerId,
    required this.circleId,
    required this.participant,
    required this.canEdit,
  });

  final String ledgerId;
  final String circleId;
  final CircleParticipantResponse participant;
  final bool canEdit;

  Future<void> _editHandCount(BuildContext context, WidgetRef ref) async {
    final newCount = await showDialog<int>(
      context: context,
      builder: (context) => _HandCountDialog(
        userFullName: participant.userFullName,
        initialCount: participant.handCount,
      ),
    );
    if (newCount == null) return;

    final ok = await ref.read(circleControllerProvider.notifier).addParticipant(
          ledgerId,
          circleId,
          participant.userId,
          newCount,
        );
    if (!context.mounted) return;
    if (!ok) {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not update hand count.');
    }
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove participant?'),
        content: Text(
            '${participant.userFullName} will be removed from this circle.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove',
                style: TextStyle(color: AjopayColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final ok = await ref
        .read(circleControllerProvider.notifier)
        .removeParticipant(ledgerId, circleId, participant.userId);
    if (!context.mounted) return;
    if (!ok) {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not remove participant.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AjopayColors.primaryTint,
          child: Text(
            participant.handCount.toString(),
            style: const TextStyle(
              color: AjopayColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(participant.userFullName),
        subtitle: Text(
          participant.handCount == 1
              ? '1 hand'
              : '${participant.handCount} hands',
        ),
        trailing: canEdit
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _editHandCount(context, ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AjopayColors.error),
                    onPressed: () => _remove(context, ref),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

class _HandCountDialog extends StatefulWidget {
  const _HandCountDialog(
      {required this.userFullName, required this.initialCount});

  final String userFullName;
  final int initialCount;

  @override
  State<_HandCountDialog> createState() => _HandCountDialogState();
}

class _HandCountDialogState extends State<_HandCountDialog> {
  late int _count = widget.initialCount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.userFullName),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _count > 1 ? () => setState(() => _count--) : null,
          ),
          Text('$_count', style: Theme.of(context).textTheme.headlineSmall),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => setState(() => _count++),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_count),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _AddParticipantSheet extends ConsumerWidget {
  const _AddParticipantSheet({required this.ledgerId, required this.circleId});

  final String ledgerId;
  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (ledgerId: ledgerId, circleId: circleId);
    final membersAsync = ref.watch(ledgerMembersProvider(ledgerId));
    final participantsAsync = ref.watch(circleParticipantsProvider(key));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: membersAsync.when(
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SizedBox(
            height: 200,
            child: Center(child: Text('Could not load ledger members.')),
          ),
          data: (members) {
            final existingIds =
                participantsAsync.valueOrNull?.map((p) => p.userId).toSet() ??
                    {};
            final available =
                members.where((m) => !existingIds.contains(m.userId)).toList();

            if (available.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Text('Every active member is already in this circle.'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: available.length,
              itemBuilder: (context, index) {
                final member = available[index];
                return ListTile(
                  title: Text(member.fullName),
                  subtitle: Text(member.role),
                  onTap: () async {
                    final count = await showDialog<int>(
                      context: context,
                      builder: (context) => _HandCountDialog(
                        userFullName: member.fullName,
                        initialCount: 1,
                      ),
                    );
                    if (count == null) return;
                    if (!context.mounted) return;

                    // Captured as a plain object BEFORE popping — the
                    // sheet's own context is guaranteed unmounted by the
                    // time the async call below completes, but this
                    // messenger belongs to the parent screen's Scaffold
                    // and stays valid regardless.
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.of(context).pop(); // close the sheet

                    final ok = await ref
                        .read(circleControllerProvider.notifier)
                        .addParticipant(
                            ledgerId, circleId, member.userId, count);

                    if (!ok) {
                      final message =
                          ref.read(circleControllerProvider.notifier).lastError;
                      AppFeedback.showErrorVia(
                          messenger, message ?? 'Could not add participant.');
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
