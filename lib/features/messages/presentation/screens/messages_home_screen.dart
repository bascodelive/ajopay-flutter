import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../account/application/account_controller.dart';
import '../../../ledgers/application/ledger_controller.dart';
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
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    ref.read(messageStreamControllerProvider.notifier).disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Group'),
            Tab(text: 'Direct'),
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
