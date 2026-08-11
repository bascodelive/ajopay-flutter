import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../application/ledger_controller.dart';
import '../../data/models/ledger_models.dart';
import '../../../account/application/account_controller.dart';
import '../../../messages/application/message_read_tracker.dart';
import '../../../messages/application/message_thread_pager.dart';

class LedgerDetailScreen extends ConsumerWidget {
  const LedgerDetailScreen({super.key, required this.ledgerId});

  final String ledgerId;

  /// Same Group-thread-only unread count as MessagesHomeScreen's own —
  /// see that screen's doc comment for why this doesn't extend to an
  /// aggregate Direct-messages count. One extra fetch (the group
  /// thread) when opening Ledger Detail — acceptable, bounded to one
  /// thread per ledger, same "realistically bounded" reasoning already
  /// applied elsewhere in this app.
  int _groupUnreadCount(WidgetRef ref) {
    final myUserId = ref.watch(accountControllerProvider).valueOrNull?.id;
    ref.watch(messageReadTrackerProvider); // forces rebuild once init resolves
    final storageKey =
        messageThreadStorageKey(ledgerId: ledgerId, isGroup: true);
    final lastRead =
        ref.read(messageReadTrackerProvider.notifier).getLastRead(storageKey);

    final groupKey = (
      ledgerId: ledgerId,
      type: MessageThreadType.group,
      otherUserId: null,
    );
    final items =
        ref.watch(messageThreadPagerProvider(groupKey)).valueOrNull?.items;
    if (items == null) return 0;

    return items.where((m) {
      if (m.senderId == myUserId) return false;
      if (lastRead == null) return true;
      final sentAt = DateTime.tryParse(m.sentAt);
      return sentAt != null && sentAt.isAfter(lastRead);
    }).length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(ledgerDetailProvider(ledgerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        actions: [
          ledgerAsync.maybeWhen(
            data: (ledger) => ledger.callerRole == 'ADMIN'
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => context.push('/ledgers/$ledgerId/edit'),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: AppBackdrop(
        stops: const [0.0, 0.2],
        child: ledgerAsync.when(
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
                  const Text('Could not load this ledger.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        ref.invalidate(ledgerDetailProvider(ledgerId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (ledger) => RefreshIndicator(
            onRefresh: () => ref.refresh(ledgerDetailProvider(ledgerId).future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderCard(ledger: ledger),
                  const SizedBox(height: 16),
                  _InviteCodeCard(ledger: ledger),
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.groups_outlined),
                      title: const Text('Members'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/ledgers/$ledgerId/members'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.autorenew),
                      title: const Text('Circle'),
                      subtitle: const Text('Payout rotation for this ledger'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/ledgers/$ledgerId/circle'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: const Text('Contributions'),
                      subtitle: const Text('Track payments for this ledger'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push('/ledgers/$ledgerId/contributions'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.chat_bubble_outline_rounded),
                      title: const Text('Messages'),
                      subtitle: const Text('Group chat and direct messages'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_groupUnreadCount(ref) > 0) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AjopayColors.gold,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _groupUnreadCount(ref) > 99
                                    ? '99+'
                                    : '${_groupUnreadCount(ref)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => context.push('/ledgers/$ledgerId/messages'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.rate_review_outlined),
                      title: const Text('Reviews'),
                      subtitle: const Text(
                          'What people are saying about this ledger'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/ledgers/$ledgerId/reviews'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.ledger});

  final LedgerResponse ledger;

  @override
  Widget build(BuildContext context) {
    final isActive = ledger.status == 'ACTIVE';
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
                    ledger.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AjopayColors.primaryTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ledger.callerRole,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AjopayColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.repeat,
              label: 'Frequency',
              value:
                  '${ledger.contributionFrequency[0]}${ledger.contributionFrequency.substring(1).toLowerCase()}',
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.payments_outlined,
              label: 'Amount',
              value:
                  '₦${ledger.contributionAmount.toStringAsFixed(0)} per cycle',
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: isActive
                  ? Icons.check_circle_outline
                  : Icons.pause_circle_outline,
              label: 'Status',
              value: ledger.status,
              valueColor: isActive ? AjopayColors.primary : AjopayColors.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AjopayColors.textMuted),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({required this.ledger});

  final LedgerResponse ledger;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AjopayColors.primaryTint,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite code',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AjopayColors.primaryDark,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ledger.inviteCode,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AjopayColors.primaryDark,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy_outlined,
                  color: AjopayColors.primaryDark),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: ledger.inviteCode));
                AppFeedback.showSuccess(context, 'Invite code copied');
              },
            ),
          ],
        ),
      ),
    );
  }
}
