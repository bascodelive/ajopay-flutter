import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/csv_share.dart';
import '../../../account/application/account_controller.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/contribution_action_controller.dart';
import '../../application/contributions_pager.dart';
import '../../data/contribution_repository.dart';
import '../../data/models/contribution_models.dart';

class ContributionDetailScreen extends ConsumerStatefulWidget {
  const ContributionDetailScreen({
    super.key,
    required this.ledgerId,
    required this.initialContribution,
  });

  final String ledgerId;

  /// There is no "get contribution by ID" endpoint in API.md (confirmed
  /// against the real ContributionController source) — only list-all,
  /// list-own, and the six action endpoints. So this screen is reached
  /// with the full object already in hand (passed via go_router's
  /// `extra` from the list tile that was just tapped), not by
  /// re-fetching from a cache. See _contribution below for why this
  /// matters after a mutation.
  final ContributionResponse initialContribution;

  @override
  ConsumerState<ContributionDetailScreen> createState() =>
      _ContributionDetailScreenState();
}

class _ContributionDetailScreenState
    extends ConsumerState<ContributionDetailScreen> {
  // Bug avoided here, not just fixed: an earlier version of this screen
  // tried to re-derive the current contribution by searching whatever
  // pages ContributionsPager happened to have loaded. That breaks in
  // completely ordinary use — every mutation invalidates the WHOLE pager
  // (see ContributionActionController._invalidateAfterMutation), which
  // resets it back to page 0 on next fetch, collapsing any accumulated
  // scroll history. Acting on anything past page 0 would make this
  // screen go blank immediately after its own action succeeded. Instead:
  // hold a local copy, update it directly from each action's own return
  // value (every action method already returns the updated
  // ContributionResponse) — zero dependency on pager cache state.
  late ContributionResponse _contribution = widget.initialContribution;
  bool _isActing = false;
  bool _isExporting = false;

  Future<void> _runAction(
    String title,
    Future<ContributionResponse?> Function(String? note) action,
  ) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
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
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _isActing = true);
    final note =
        noteController.text.trim().isEmpty ? null : noteController.text.trim();
    final result = await action(note);
    if (!mounted) return;

    setState(() {
      _isActing = false;
      // The critical line — update from the action's OWN return value,
      // never from a re-derived pager lookup.
      if (result != null) _contribution = result;
    });

    if (result != null) {
      AppFeedback.showSuccess(context, 'Done');
    } else {
      final message =
          ref.read(contributionActionControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not complete this action.');
    }
  }

  /// Only reachable once `_contribution.status == 'PAID'` — the button
  /// that calls this is itself gated the same way, and the backend
  /// enforces the same gate server-side (400 otherwise), matching the
  /// deliberate "export only once settled" product decision.
  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final csv = await ref
          .read(contributionRepositoryProvider)
          .exportHistoryCsv(widget.ledgerId, _contribution.id);
      if (!mounted) return;
      await shareCsv(
        csv: csv,
        fileName: 'contribution-${_contribution.id}-history.csv',
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      AppFeedback.showError(context, e.message ?? 'Could not export history.');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ledgerAsync = ref.watch(ledgerDetailProvider(widget.ledgerId));
    final profileAsync = ref.watch(accountControllerProvider);
    final historyAsync = ref.watch(contributionHistoryProvider(
      (ledgerId: widget.ledgerId, contributionId: _contribution.id),
    ));

    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';
    final currentUserId = profileAsync.valueOrNull?.id;
    final isOwner = currentUserId == _contribution.userId;
    final canExport = _contribution.status == 'PAID';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribution'),
        actions: [
          if (canExport)
            IconButton(
              tooltip: 'Export history (CSV)',
              icon: _isExporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.ios_share),
              onPressed: _isExporting ? null : _exportCsv,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailCard(contribution: _contribution),
            const SizedBox(height: 16),
            if (isAdmin || isOwner) ...[
              _ActionsSection(
                contribution: _contribution,
                isAdmin: isAdmin,
                isOwner: isOwner,
                isActing: _isActing,
                onReport: () => _runAction(
                  'Report payment',
                  (note) => ref
                      .read(contributionActionControllerProvider.notifier)
                      .reportPayment(widget.ledgerId, _contribution.id,
                          note: note),
                ),
                onMarkMissed: () => _runAction(
                  'Mark missed',
                  (note) => ref
                      .read(contributionActionControllerProvider.notifier)
                      .markMissed(widget.ledgerId, _contribution.id,
                          note: note),
                ),
                onConfirm: () => _runAction(
                  'Confirm payment',
                  (note) => ref
                      .read(contributionActionControllerProvider.notifier)
                      .confirmPayment(widget.ledgerId, _contribution.id,
                          note: note),
                ),
                onReject: () => _runAction(
                  'Reject report',
                  (note) => ref
                      .read(contributionActionControllerProvider.notifier)
                      .rejectReport(widget.ledgerId, _contribution.id,
                          note: note),
                ),
                onReopen: () => _runAction(
                  'Reopen for late payment',
                  (note) => ref
                      .read(contributionActionControllerProvider.notifier)
                      .reopenForLatePayment(widget.ledgerId, _contribution.id,
                          note: note),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text('History', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Could not load history.'),
              data: (entries) => entries.isEmpty
                  ? const Text('No activity yet.')
                  : Column(
                      children:
                          entries.map((e) => _HistoryTile(entry: e)).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.contribution});

  final ContributionResponse contribution;

  Color get _statusColor {
    switch (contribution.status) {
      case 'PAID':
        return AjopayColors.primary;
      case 'MISSED':
        return AjopayColors.error;
      case 'REPORTED':
        return AjopayColors.gold;
      default:
        return Colors.black45;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    contribution.memberFullName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                // Only shown for a multi-hand (circle-generated)
                // contribution — a plain handNumber of 1 (the vast
                // majority: every manually-scheduled contribution, and
                // every single-hand circle participant) adds nothing a
                // reader needs to see.
                if (contribution.handNumber > 1) ...[
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AjopayColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Hand ${contribution.handNumber}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AjopayColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    contribution.status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Row(label: 'Cycle date', value: contribution.cycleDate),
            const SizedBox(height: 8),
            _Row(
                label: 'Amount',
                value: '₦${contribution.amount.toStringAsFixed(0)}'),
            if (contribution.recordedByFullName != null) ...[
              const SizedBox(height: 8),
              _Row(
                  label: 'Recorded by',
                  value: contribution.recordedByFullName!),
            ],
            if (contribution.memberNote != null &&
                contribution.memberNote!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _Row(label: 'Member note', value: contribution.memberNote!),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Mirrors ContributionService's exact transition rules — every button
/// shown here corresponds exactly to a transition the backend actually
/// allows from the contribution's current status, for the caller's
/// actual role/ownership. The backend is still the real enforcer
/// (a client-side mismatch would just mean a 403/400 rather than a
/// security hole), but showing an impossible action is bad UX regardless.
class _ActionsSection extends StatelessWidget {
  const _ActionsSection({
    required this.contribution,
    required this.isAdmin,
    required this.isOwner,
    required this.isActing,
    required this.onReport,
    required this.onMarkMissed,
    required this.onConfirm,
    required this.onReject,
    required this.onReopen,
  });

  final ContributionResponse contribution;
  final bool isAdmin;
  final bool isOwner;
  final bool isActing;
  final VoidCallback onReport;
  final VoidCallback onMarkMissed;
  final VoidCallback onConfirm;
  final VoidCallback onReject;
  final VoidCallback onReopen;

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    switch (contribution.status) {
      case 'PENDING':
        if (isOwner) {
          buttons.add(ElevatedButton(
            onPressed: isActing ? null : onReport,
            child: const Text('Report payment'),
          ));
        }
        if (isAdmin) {
          buttons.add(OutlinedButton(
            onPressed: isActing ? null : onMarkMissed,
            child: const Text('Mark missed'),
          ));
        }
        break;
      case 'REPORTED':
        if (isAdmin) {
          buttons.add(ElevatedButton(
            onPressed: isActing ? null : onConfirm,
            child: const Text('Confirm payment'),
          ));
          buttons.add(OutlinedButton(
            onPressed: isActing ? null : onReject,
            child: Text('Reject report',
                style: TextStyle(color: AjopayColors.error)),
          ));
        }
        break;
      case 'MISSED':
        if (isAdmin) {
          buttons.add(ElevatedButton(
            onPressed: isActing ? null : onConfirm,
            child: const Text('Confirm (late payment)'),
          ));
          buttons.add(OutlinedButton(
            onPressed: isActing ? null : onReopen,
            child: const Text('Reopen for late payment'),
          ));
        }
        break;
      default: // PAID — terminal, no actions
        break;
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final button in buttons) ...[
          button,
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final ContributionActivityLogEntry entry;

  static const _actionLabels = {
    'SCHEDULED': 'Scheduled',
    'PAYMENT_REPORTED': 'Payment reported',
    'PAYMENT_CONFIRMED': 'Payment confirmed',
    'REPORT_REJECTED': 'Report rejected',
    'REOPENED_FOR_LATE_PAYMENT': 'Reopened for late payment',
    'MARKED_MISSED': 'Marked missed',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: AjopayColors.primaryTint,
        child: Icon(Icons.circle, size: 8, color: AjopayColors.primaryDark),
      ),
      title: Text(_actionLabels[entry.action] ?? entry.action),
      subtitle: Text(
        entry.note != null && entry.note!.isNotEmpty
            ? '${entry.actorFullName} · ${entry.note}'
            : entry.actorFullName,
      ),
      trailing: Text(
        entry.createdAt.split('T').first,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
