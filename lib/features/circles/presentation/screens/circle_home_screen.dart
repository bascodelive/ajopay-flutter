import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/brand_underline.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/circle_controller.dart';
import '../../data/models/circle_models.dart';

/// The routing hub for a ledger's circle. Branches on `currentCircleProvider`:
///  - 404 (ApiException.isNotFound) -> no circle yet -> empty state, Admin
///    gets a "Start a Circle" CTA
///  - PENDING -> setup flow (participants, rotation) — next screens
///  - ACTIVE -> live rotation/payout view — next screens
///  - COMPLETED -> summary/history — next screens
class CircleHomeScreen extends ConsumerWidget {
  const CircleHomeScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circleAsync = ref.watch(currentCircleProvider(ledgerId));
    // Reused for the "is caller Admin" check on the empty state's CTA —
    // already fetched by the time someone reaches this screen from Ledger
    // Detail, so this is a cache hit, not a new network call.
    final ledgerAsync = ref.watch(ledgerDetailProvider(ledgerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Circle')),
      body: circleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          if (error is ApiException && error.isNotFound) {
            final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';
            return _NoCircleYet(ledgerId: ledgerId, isAdmin: isAdmin);
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: AjopayColors.error),
                  const SizedBox(height: 12),
                  const Text('Could not load this ledger\'s circle.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        ref.invalidate(currentCircleProvider(ledgerId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (circle) => switch (circle.status) {
          'PENDING' => _PendingCircleView(ledgerId: ledgerId, circle: circle),
          'ACTIVE' => _ActiveCircleView(ledgerId: ledgerId, circle: circle),
          'COMPLETED' =>
            _CompletedCircleView(ledgerId: ledgerId, circle: circle),
          _ => Center(child: Text('Unknown circle status: ${circle.status}')),
        },
      ),
    );
  }
}

class _NoCircleYet extends StatelessWidget {
  const _NoCircleYet({required this.ledgerId, required this.isAdmin});

  final String ledgerId;
  final bool isAdmin;

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
                  Icon(Icons.autorenew, size: 64, color: AjopayColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'No circle yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const BrandUnderline(width: 32),
                  const SizedBox(height: 12),
                  Text(
                    isAdmin
                        ? 'Start a circle to schedule this rotation\'s payout order.'
                        : 'The ledger Admin hasn\'t started a payout circle yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.push('/ledgers/$ledgerId/circle/create'),
                      icon: const Icon(Icons.add),
                      label: const Text('Start a Circle'),
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

class _PendingCircleView extends ConsumerStatefulWidget {
  const _PendingCircleView({required this.ledgerId, required this.circle});

  final String ledgerId;
  final CircleResponse circle;

  @override
  ConsumerState<_PendingCircleView> createState() => _PendingCircleViewState();
}

class _PendingCircleViewState extends ConsumerState<_PendingCircleView> {
  bool _isStarting = false;

  Future<void> _start() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start this circle?'),
        content: const Text(
          'This locks participants and hand counts permanently — no more '
          'changes until the circle completes. Make sure the rotation '
          'order is right before continuing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Start'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _isStarting = true);
    final ok = await ref
        .read(circleControllerProvider.notifier)
        .start(widget.ledgerId, widget.circle.id);

    if (!mounted) return;
    setState(() => _isStarting = false);

    if (ok) {
      ref.invalidate(currentCircleProvider(widget.ledgerId));
      AppFeedback.showSuccess(context, 'Circle started');
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(
        context,
        message ??
            'Could not start circle. Make sure a rotation order is assigned.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ledgerId = widget.ledgerId;
    final circle = widget.circle;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: AjopayColors.primaryTint,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.hourglass_top, color: AjopayColors.primaryDark),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Setting up',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AjopayColors.primaryDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        Text(
                          'Starts ${circle.startDate}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AjopayColors.primaryDark,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.groups_outlined),
                  title: const Text('Participants & hand counts'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                      '/ledgers/$ledgerId/circle/${circle.id}/participants'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_list_numbered),
                  title: const Text('Assign rotation order'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                      '/ledgers/$ledgerId/circle/${circle.id}/rotation/assign'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('History'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context
                      .push('/ledgers/$ledgerId/circle/${circle.id}/history'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isStarting ? null : _start,
            icon: _isStarting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(_isStarting ? 'Starting...' : 'Start circle'),
          ),
        ],
      ),
    );
  }
}

class _ActiveCircleView extends StatelessWidget {
  const _ActiveCircleView({required this.ledgerId, required this.circle});

  final String ledgerId;
  final CircleResponse circle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline, color: AjopayColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Active — runs ${circle.startDate} to ${circle.endDate ?? '?'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Current payout'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                      '/ledgers/$ledgerId/circle/${circle.id}/current-payout'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_list_numbered),
                  title: const Text('Rotation queue'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context
                      .push('/ledgers/$ledgerId/circle/${circle.id}/rotation'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('History'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context
                      .push('/ledgers/$ledgerId/circle/${circle.id}/history'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedCircleView extends StatelessWidget {
  const _CompletedCircleView({required this.ledgerId, required this.circle});

  final String ledgerId;
  final CircleResponse circle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AjopayColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Completed — ${circle.startDate} to ${circle.endDate ?? '?'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context
                  .push('/ledgers/$ledgerId/circle/${circle.id}/history'),
            ),
          ),
        ],
      ),
    );
  }
}
