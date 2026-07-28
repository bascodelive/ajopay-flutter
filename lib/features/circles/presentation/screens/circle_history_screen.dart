import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/csv_share.dart';
import '../../application/circle_controller.dart';
import '../../data/circle_repository.dart';

class CircleHistoryScreen extends ConsumerStatefulWidget {
  const CircleHistoryScreen({
    super.key,
    required this.ledgerId,
    required this.circleId,
  });

  final String ledgerId;
  final String circleId;

  @override
  ConsumerState<CircleHistoryScreen> createState() =>
      _CircleHistoryScreenState();
}

class _CircleHistoryScreenState extends ConsumerState<CircleHistoryScreen> {
  bool _isExporting = false;

  static const _actionLabels = {
    'CIRCLE_SCHEDULED': 'Circle scheduled',
    'PARTICIPANT_ADDED': 'Participant added',
    'PARTICIPANT_REMOVED': 'Participant removed',
    'HAND_COUNT_CHANGED': 'Hand count changed',
    'ROTATION_ASSIGNED': 'Rotation assigned',
    'ROTATION_REORDERED': 'Rotation reordered',
    'CIRCLE_STARTED': 'Circle started',
    'CONTRIBUTIONS_GENERATED': 'Contributions generated',
    'PAYOUT_CONFIRMED': 'Payout confirmed',
    'PAYOUT_RECEIPT_CONFIRMED': 'Receipt confirmed',
    'CIRCLE_COMPLETED': 'Circle completed',
  };

  static const _actionIcons = {
    'CIRCLE_SCHEDULED': Icons.event_note,
    'PARTICIPANT_ADDED': Icons.person_add_alt,
    'PARTICIPANT_REMOVED': Icons.person_remove_alt_1,
    'HAND_COUNT_CHANGED': Icons.tune,
    'ROTATION_ASSIGNED': Icons.format_list_numbered,
    'ROTATION_REORDERED': Icons.swap_vert,
    'CIRCLE_STARTED': Icons.play_circle_outline,
    'CONTRIBUTIONS_GENERATED': Icons.receipt_long_outlined,
    'PAYOUT_CONFIRMED': Icons.payments_outlined,
    'PAYOUT_RECEIPT_CONFIRMED': Icons.verified_outlined,
    'CIRCLE_COMPLETED': Icons.check_circle_outline,
  };

  /// Only reachable once the circle is COMPLETED — the button that
  /// calls this is itself gated the same way, and the backend enforces
  /// the same gate server-side (400 otherwise).
  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final csv = await ref
          .read(circleRepositoryProvider)
          .exportHistoryCsv(widget.ledgerId, widget.circleId);
      if (!mounted) return;
      await shareCsv(
        csv: csv,
        fileName: 'circle-${widget.circleId}-history.csv',
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
    final key = (ledgerId: widget.ledgerId, circleId: widget.circleId);
    final historyAsync = ref.watch(circleHistoryProvider(key));
    final circleAsync = ref.watch(currentCircleProvider(widget.ledgerId));
    final canExport = circleAsync.valueOrNull?.status == 'COMPLETED';

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
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
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: AjopayColors.error),
                const SizedBox(height: 12),
                const Text('Could not load history.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(circleHistoryProvider(key)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('No activity yet.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(circleHistoryProvider(key).future),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (context, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AjopayColors.primaryTint,
                    child: Icon(
                      _actionIcons[entry.action] ?? Icons.circle_outlined,
                      size: 18,
                      color: AjopayColors.primaryDark,
                    ),
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
              },
            ),
          );
        },
      ),
    );
  }
}
