import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../application/ledger_controller.dart';
import '../../data/models/ledger_models.dart';

class LedgerMembersScreen extends ConsumerStatefulWidget {
  const LedgerMembersScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  ConsumerState<LedgerMembersScreen> createState() =>
      _LedgerMembersScreenState();
}

class _LedgerMembersScreenState extends ConsumerState<LedgerMembersScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ledgerAsync = ref.watch(ledgerDetailProvider(widget.ledgerId));
    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';

    // Only Admins get a Pending tab at all — a plain member has no access
    // to that endpoint server-side (403), so there's nothing useful to
    // show them there. Tab count depends on role, same pattern as
    // ContributionsListScreen's Admin-only "All" tab.
    final tabCount = isAdmin ? 2 : 1;
    if (_tabController == null || _tabController!.length != tabCount) {
      _tabController?.dispose();
      _tabController = TabController(length: tabCount, vsync: this);
    }

    // Only fetch the pending list at all once we know the caller is
    // Admin — avoids firing a request server-side we already know will
    // 403 for anyone else.
    final pendingAsync = isAdmin
        ? ref.watch(ledgerPendingMembersProvider(widget.ledgerId))
        : null;
    final pendingCount = pendingAsync?.valueOrNull?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        bottom: tabCount > 1
            ? TabBar(
                controller: _tabController,
                tabs: [
                  const Tab(text: 'Active'),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Pending'),
                        if (pendingCount > 0) ...[
                          const SizedBox(width: 6),
                          _CountBadge(count: pendingCount),
                        ],
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
      body: tabCount > 1
          ? TabBarView(
              controller: _tabController,
              children: [
                _ActiveMembersView(ledgerId: widget.ledgerId),
                _PendingMembersView(ledgerId: widget.ledgerId),
              ],
            )
          : _ActiveMembersView(ledgerId: widget.ledgerId),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AjopayColors.gold,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _ActiveMembersView extends ConsumerWidget {
  const _ActiveMembersView({required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(ledgerMembersProvider(ledgerId));

    return membersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) {
        // Any active member can view the full list now (used to be
        // Admin-only) — a 403 here specifically means "you're not an
        // active member of this ledger at all."
        final message = error is ApiException && error.isForbidden
            ? 'You need to be a member of this ledger to view its members.'
            : 'Could not load members.';
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AjopayColors.error),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(ledgerMembersProvider(ledgerId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      data: (members) => RefreshIndicator(
        onRefresh: () => ref.refresh(ledgerMembersProvider(ledgerId).future),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          separatorBuilder: (context, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _MemberTile(member: members[index]),
        ),
      ),
    );
  }
}

class _PendingMembersView extends ConsumerWidget {
  const _PendingMembersView({required this.ledgerId});

  final String ledgerId;

  Future<void> _approve(
      BuildContext context, WidgetRef ref, LedgerMemberResponse member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve this request?'),
        content: Text(
            '${member.fullName} will get full access to this ledger.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    final ok = await ref
        .read(ledgerControllerProvider.notifier)
        .approveMember(ledgerId, member.userId);
    if (!context.mounted) return;

    if (ok) {
      AppFeedback.showSuccess(context, '${member.fullName} approved');
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not approve this request.');
    }
  }

  Future<void> _reject(
      BuildContext context, WidgetRef ref, LedgerMemberResponse member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline this request?'),
        content: Text(
            "${member.fullName}'s request to join will be declined."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Decline', style: TextStyle(color: AjopayColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    final ok = await ref
        .read(ledgerControllerProvider.notifier)
        .rejectMember(ledgerId, member.userId);
    if (!context.mounted) return;

    if (ok) {
      AppFeedback.showSuccess(context, "${member.fullName}'s request declined");
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not decline this request.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(ledgerPendingMembersProvider(ledgerId));

    return pendingAsync.when(
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
              const Text('Could not load pending requests.'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () =>
                    ref.invalidate(ledgerPendingMembersProvider(ledgerId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (pending) {
        if (pending.isEmpty) {
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
                        Icon(Icons.mark_email_read_outlined,
                            size: 56, color: AjopayColors.primary),
                        const SizedBox(height: 16),
                        Text(
                          'No pending requests',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "You're all caught up — new join requests will show up here.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.refresh(ledgerPendingMembersProvider(ledgerId).future),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: pending.length,
            separatorBuilder: (context, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final member = pending[index];
              return _PendingMemberTile(
                member: member,
                onApprove: () => _approve(context, ref, member),
                onReject: () => _reject(context, ref, member),
              );
            },
          ),
        );
      },
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final LedgerMemberResponse member;

  String get _initials {
    final parts = member.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = member.status == 'ACTIVE';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AjopayColors.primaryTint,
          child: Text(
            _initials,
            style: const TextStyle(
              color: AjopayColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(member.fullName),
        subtitle: Text(isActive ? 'Active member' : 'Removed'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AjopayColors.primaryTint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            member.role,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AjopayColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class _PendingMemberTile extends StatelessWidget {
  const _PendingMemberTile({
    required this.member,
    required this.onApprove,
    required this.onReject,
  });

  final LedgerMemberResponse member;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  String get _initials {
    final parts = member.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AjopayColors.gold.withValues(alpha: 0.18),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: AjopayColors.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.fullName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Wants to join',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AjopayColors.error,
                      side: BorderSide(color: AjopayColors.error),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
