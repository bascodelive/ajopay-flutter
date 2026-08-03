import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../application/circle_controller.dart';
import '../../data/models/circle_models.dart';

/// Every circle this ledger has ever had — PENDING, ACTIVE, and
/// COMPLETED. Exists specifically so a completed circle's History (and
/// CSV export) stays reachable after `currentCircleProvider` stops
/// returning it — see CircleHistoryScreen's own doc comment on
/// `circleStatus` for the other half of this fix.
class PastCirclesScreen extends ConsumerWidget {
  const PastCirclesScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circlesAsync = ref.watch(circlesListProvider(ledgerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Past circles')),
      body: AppBackdrop(
        child: circlesAsync.when(
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
                  const Text('Could not load past circles.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        ref.invalidate(circlesListProvider(ledgerId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (circles) {
            if (circles.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_repeat_outlined,
                          size: 56, color: AjopayColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        'No circles yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(circlesListProvider(ledgerId).future),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: circles.length,
                separatorBuilder: (context, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _CircleRow(
                  ledgerId: ledgerId,
                  circle: circles[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircleRow extends StatelessWidget {
  const _CircleRow({required this.ledgerId, required this.circle});

  final String ledgerId;
  final CircleResponse circle;

  Color get _statusColor {
    switch (circle.status) {
      case 'ACTIVE':
        return AjopayColors.primary;
      case 'COMPLETED':
        return AjopayColors.success;
      default: // PENDING
        return AjopayColors.gold;
    }
  }

  IconData get _statusIcon {
    switch (circle.status) {
      case 'ACTIVE':
        return Icons.play_circle_outline;
      case 'COMPLETED':
        return Icons.check_circle_outline;
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _statusColor.withValues(alpha: 0.12),
          child: Icon(_statusIcon, color: _statusColor, size: 20),
        ),
        title: Text(
          '${circle.startDate} → ${circle.endDate ?? 'ongoing'}',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          circle.status,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: _statusColor, fontWeight: FontWeight.w700),
        ),
        trailing: const Icon(Icons.chevron_right),
        // circle.status passed directly via `extra` — the whole point
        // of this screen existing is to give CircleHistoryScreen the
        // status it needs without ever going back through
        // currentCircleProvider.
        onTap: () => context.push(
          '/ledgers/$ledgerId/circle/${circle.id}/history',
          extra: circle.status,
        ),
      ),
    );
  }
}
