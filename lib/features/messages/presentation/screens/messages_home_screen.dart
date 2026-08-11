import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../account/application/account_controller.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/message_read_tracker.dart';
import '../../application/message_stream_controller.dart';
import '../../application/message_thread_pager.dart';
import 'message_thread_view.dart';

class MessagesHomeScreen extends ConsumerStatefulWidget {
  const MessagesHomeScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  ConsumerState<MessagesHomeScreen> createState() => _MessagesHomeScreenState();
}

class _MessagesHomeScreenState extends ConsumerState<MessagesHomeScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  String get _groupStorageKey =>
      messageThreadStorageKey(ledgerId: widget.ledgerId, isGroup: true);

  @override
  void initState() {
    super.initState();
    // One live connection per ledger, opened for as long as the caller
    // is anywhere inside this ledger's Messages section (both tabs
    // share it — see MessageStreamController's own Javadoc-equivalent
    // comment on why it's one-per-ledger, not one-per-thread).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messageStreamControllerProvider.notifier)
          .connect(widget.ledgerId);
      // Group is index 0 (the default tab) — opening Messages onto it
      // counts as "looked at it," same as WhatsApp marking a chat read
      // the moment it's opened, not on some separate timer.
      _markGroupReadIfOnGroupTab();
    });
    _tabController.addListener(_markGroupReadIfOnGroupTab);
  }

  @override
  void dispose() {
    _tabController.removeListener(_markGroupReadIfOnGroupTab);
    _tabController.dispose();
    ref.read(messageStreamControllerProvider.notifier).disconnect();
    super.dispose();
  }

  void _markGroupReadIfOnGroupTab() {
    if (_tabController.index == 0) {
      ref
          .read(messageReadTrackerProvider.notifier)
          .markReadNow(_groupStorageKey);
    }
  }

  /// Unread count for the Group thread only. Cheap and accurate: one
  /// thread per ledger, already fetched for the tab's own content —
  /// this is just counting what's already in memory, not an extra
  /// fetch.
  ///
  /// Deliberately NOT extended to an aggregate Direct-tab badge: there's
  /// no server-side "unread count per thread" endpoint, so an accurate
  /// Direct badge would mean fetching every OTHER member's private
  /// thread just to check for new messages — the same N+1 pattern this
  /// app has consistently avoided elsewhere (Ledger Ratings, Circle
  /// history). A fake/approximate badge would be worse than none; this
  /// stays honestly scoped to what's cheap and correct today.
  int _groupUnreadCount() {
    final myUserId = ref.watch(accountControllerProvider).valueOrNull?.id;
    // Forces a rebuild once MessageReadTracker's async init resolves —
    // see that provider's own doc comment on why a call before that
    // point would otherwise silently under-count.
    ref.watch(messageReadTrackerProvider);
    final lastRead = ref
        .read(messageReadTrackerProvider.notifier)
        .getLastRead(_groupStorageKey);

    final groupKey = (
      ledgerId: widget.ledgerId,
      type: MessageThreadType.group,
      otherUserId: null,
    );
    final items =
        ref.watch(messageThreadPagerProvider(groupKey)).valueOrNull?.items;
    if (items == null) return 0;

    return items.where((m) {
      if (m.senderId == myUserId) return false; // never counts own messages
      if (lastRead == null) return true; // never opened on this device
      final sentAt = DateTime.tryParse(m.sentAt);
      return sentAt != null && sentAt.isAfter(lastRead);
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final unread = _groupUnreadCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Group'),
                  if (unread > 0) ...[
                    const SizedBox(width: 6),
                    _UnreadBadge(count: unread),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Direct'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MessageThreadView(
            threadKey: (
              ledgerId: widget.ledgerId,
              type: MessageThreadType.group,
              otherUserId: null,
            ),
            showSenderNames: true,
          ),
          _DirectMessagesTab(ledgerId: widget.ledgerId),
        ],
      ),
    );
  }
}

/// Small gold count pill — same visual convention already established
/// for LedgerMembersScreen's Pending-tab badge, reused here rather than
/// inventing a second badge style.
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

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
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// Lists every other active member of the ledger — tap one to open (or
/// continue) a private thread. There's no "recent conversations" list
/// server-side (no endpoint for it), so this is deliberately just "every
/// person you COULD message," same honest scope as what the backend
/// actually offers rather than implying a feature that isn't there.
class _DirectMessagesTab extends ConsumerWidget {
  const _DirectMessagesTab({required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(ledgerMembersProvider(ledgerId));
    final myUserId = ref.watch(accountControllerProvider).valueOrNull?.id;

    return AppBackdrop(
      stops: const [0.0, 0.15],
      child: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: AjopayColors.error),
                SizedBox(height: 12),
                Text('Could not load members.'),
              ],
            ),
          ),
        ),
        data: (members) {
          final others = members.where((m) => m.userId != myUserId).toList();

          if (others.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline,
                        size: 48, color: AjopayColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      'No other members to message yet.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AjopayColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: others.length,
            separatorBuilder: (context, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final member = others[index];
              return Card(
                margin: EdgeInsets.zero,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push(
                    '/ledgers/$ledgerId/messages/private/${member.userId}',
                    extra: member.fullName,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AjopayColors.primaryTint,
                          child: Text(
                            _initialsOf(member.fullName),
                            style: const TextStyle(
                              color: AjopayColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AjopayColors.primaryTint,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  member.role,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AjopayColors.primaryDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AjopayColors.textMuted),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _initialsOf(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}
