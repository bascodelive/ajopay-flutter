import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../account/application/account_controller.dart';
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
  bool _isLeaving = false;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _leave(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave this ledger?'),
        content: const Text(
          "You'll lose access to its circle, contributions, and messages. "
          "You can request to rejoin later, but the ledger's Admin will "
          "need to approve it again.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AjopayColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    setState(() => _isLeaving = true);
    final ok = await ref
        .read(ledgerControllerProvider.notifier)
        .leaveLedger(widget.ledgerId);

    if (!context.mounted) return;
    setState(() => _isLeaving = false);

    if (ok) {
      AppFeedback.showSuccess(context, "You've left this ledger");
      // Nothing left to show for this ledger from this account's
      // perspective — go back further than just this screen.
      context.go('/');
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not leave this ledger.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ledgerAsync = ref.watch(ledgerDetailProvider(widget.ledgerId));
    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';
    final myUserId = ref.watch(accountControllerProvider).valueOrNull?.id;

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
        // The Admin never gets this — leaving would orphan the ledger
        // (backend rejects it outright; this hides the dead-end action
        // rather than showing a button that always fails).
        actions: [
          if (ledgerAsync.hasValue && !isAdmin)
            IconButton(
              tooltip: 'Leave ledger',
              icon: _isLeaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.exit_to_app),
              onPressed: _isLeaving ? null : () => _leave(context),
            ),
        ],
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
      body: AppBackdrop(
        stops: const [0.0, 0.2],
        child: tabCount > 1
            ? TabBarView(
                controller: _tabController,
                children: [
                  _ActiveMembersView(
                    ledgerId: widget.ledgerId,
                    isAdmin: isAdmin,
                    myUserId: myUserId,
                  ),
                  _PendingMembersView(ledgerId: widget.ledgerId),
                ],
              )
            : _ActiveMembersView(
                ledgerId: widget.ledgerId,
                isAdmin: isAdmin,
                myUserId: myUserId,
              ),
      ),
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
  const _ActiveMembersView({
    required this.ledgerId,
    required this.isAdmin,
    required this.myUserId,
  });

  final String ledgerId;
  final bool isAdmin;
  final String? myUserId;

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    LedgerMemberResponse member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove this member?'),
        content: Text(
          '${member.fullName} will lose access to this ledger. They can '
          'request to rejoin later, and you\'ll need to approve it again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AjopayColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    final ok = await ref
        .read(ledgerControllerProvider.notifier)
        .removeMember(ledgerId, member.userId);
    if (!context.mounted) return;

    if (ok) {
      AppFeedback.showSuccess(context, '${member.fullName} removed');
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not remove this member.');
    }
  }

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
          itemBuilder: (context, index) {
            final member = members[index];
            final isSelf = myUserId != null && member.userId == myUserId;
            // Can remove when: caller is Admin, this row isn't the
            // caller's own (use Leave for that — the AppBar action
            // above), and this row isn't itself the Admin (backend
            // rejects that anyway; hidden here rather than shown as a
            // dead-end button).
            final canRemove = isAdmin && !isSelf && member.role != 'ADMIN';
            return _MemberTile(
              member: member,
              canRemove: canRemove,
              onRemove: canRemove ? () => _remove(context, ref, member) : null,
            );
          },
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
        content:
            Text('${member.fullName} will get full access to this ledger.'),
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
        content: Text("${member.fullName}'s request to join will be declined."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Decline',
                style: TextStyle(color: AjopayColors.error)),
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
                        const Icon(Icons.mark_email_read_outlined,
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
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AjopayColors.textMuted,
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
  const _MemberTile({
    required this.member,
    required this.canRemove,
    this.onRemove,
  });

  final LedgerMemberResponse member;
  final bool canRemove;
  final VoidCallback? onRemove;

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
            if (canRemove) ...[
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.person_remove_outlined,
                    color: AjopayColors.error, size: 20),
                onPressed: onRemove,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PendingMemberTile extends StatefulWidget {
  const _PendingMemberTile({
    required this.member,
    required this.onApprove,
    required this.onReject,
  });

  final LedgerMemberResponse member;

  final Future<void> Function() onApprove;
  final Future<void> Function() onReject;

  @override
  State<_PendingMemberTile> createState() => _PendingMemberTileState();
}

class _PendingMemberTileState extends State<_PendingMemberTile> {
  bool _isActing = false;

  String get _initials {
    final parts = widget.member.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Future<void> _handle(Future<void> Function() action) async {
    if (_isActing) return;
    setState(() => _isActing = true);
    await action();
    if (mounted) setState(() => _isActing = false);
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
                        widget.member.fullName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Wants to join',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AjopayColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _isActing ? null : () => _handle(widget.onReject),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AjopayColors.error,
                      side: const BorderSide(color: AjopayColors.error),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Approve',
                    height: 44,
                    isLoading: _isActing,
                    onPressed:
                        _isActing ? null : () => _handle(widget.onApprove),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}