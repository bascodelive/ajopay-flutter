import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/circle_controller.dart';

class CircleHistoryScreen extends ConsumerWidget {
  const CircleHistoryScreen({
    super.key,
    required this.ledgerId,
    required this.circleId,
  });

  final String ledgerId;
  final String circleId;

  static const _actionLabels = {
    'CIRCLE_SCHEDULED': 'Circle scheduled',
    'PARTICIPANT_ADDED': 'Participant added',
    'PARTICIPANT_REMOVED': 'Participant removed',
    'HAND_COUNT_CHANGED': 'Hand count changed',
    'ROTATION_ASSIGNED': 'Rotation assigned',
    'ROTATION_REORDERED': 'Rotation reordered',
    'CIRCLE_STARTED': 'Circle started',
    'PAYOUT_CONFIRMED': 'Payout confirmed',
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
    'PAYOUT_CONFIRMED': Icons.payments_outlined,
    'CIRCLE_COMPLETED': Icons.check_circle_outline,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (ledgerId: ledgerId, circleId: circleId);
    final historyAsync = ref.watch(circleHistoryProvider(key));

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
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
