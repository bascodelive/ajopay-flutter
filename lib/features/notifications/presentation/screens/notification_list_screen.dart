import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../contributions/data/contribution_repository.dart';
import '../../application/notification_controller.dart';
import '../../data/models/notification_models.dart';

class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState extends ConsumerState<NotificationListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationsPagerProvider.notifier).loadMore();
    }
  }

  Future<void> _markAllRead() async {
    final ok =
        await ref.read(notificationActionControllerProvider.notifier).markAllRead();
    if (!mounted) return;
    if (ok) {
      AppFeedback.showSuccess(context, 'All notifications marked read');
    } else {
      final message =
          ref.read(notificationActionControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not mark all as read.');
    }
  }

  Future<void> _markRead(NotificationResponse notification) async {
    if (notification.read) return;
    await ref
        .read(notificationActionControllerProvider.notifier)
        .markRead(notification.id);
  }

  /// CONTRIBUTION_DUE is the only deep-linkable type today —
  /// COMPLAINT_REPLY has no thread screen in this app yet (queued as
  /// part of the deferred Complaints/Feedback work), so it only marks
  /// read; the reply's own title/body already show inline on the tile.
  Future<void> _handleTap(NotificationResponse notification) async {
    await _markRead(notification);
    if (!mounted) return;

    if (notification.type != 'CONTRIBUTION_DUE' ||
        notification.referenceId == null ||
        notification.ledgerId == null) {
      return;
    }

    final ledgerId = notification.ledgerId!;
    final contributionId = notification.referenceId!;

    try {
      final contribution = await ref
          .read(contributionRepositoryProvider)
          .getById(ledgerId, contributionId);
      if (!mounted) return;
      context.push('/ledgers/$ledgerId/contributions/$contributionId',
          extra: contribution);
    } on ApiException catch (e) {
      if (!mounted) return;
      AppFeedback.showError(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagerAsync = ref.watch(notificationsPagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          pagerAsync.maybeWhen(
            data: (state) => state.items.any((n) => !n.read)
                ? TextButton(
                    onPressed: _markAllRead,
                    child: const Text('Mark all read',
                        style: TextStyle(color: Colors.white)),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: AppBackdrop(
        child: pagerAsync.when(
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
                  const Text('Could not load notifications.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        ref.invalidate(notificationsPagerProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (state) {
            if (state.items.isEmpty) {
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
                            const Icon(Icons.notifications_none_rounded,
                                size: 56, color: AjopayColors.primary),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: Theme.of(context).textTheme.titleMedium,
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
              onRefresh: () => ref.read(notificationsPagerProvider.notifier).refresh(),
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length +
                    (state.hasMore || state.loadMoreError != null ? 1 : 0),
                separatorBuilder: (context, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    if (state.loadMoreError != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Text(
                              state.loadMoreError!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextButton(
                              onPressed: () => ref
                                  .read(notificationsPagerProvider.notifier)
                                  .loadMore(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _NotificationTile(
                    notification: state.items[index],
                    onTap: () => _handleTap(state.items[index]),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final NotificationResponse notification;
  final VoidCallback onTap;

  IconData get _icon => switch (notification.type) {
        'CONTRIBUTION_DUE' => Icons.payments_outlined,
        'COMPLAINT_REPLY' => Icons.support_agent_outlined,
        _ => Icons.notifications_none_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final unread = !notification.read;

    return Card(
      color: unread ? AjopayColors.primaryTint : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: AjopayColors.primaryDark, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight:
                                      unread ? FontWeight.w700 : FontWeight.w500,
                                ),
                          ),
                        ),
                        if (unread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8, top: 4),
                            decoration: const BoxDecoration(
                              color: AjopayColors.gold,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.createdAt.split('T').first,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AjopayColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}