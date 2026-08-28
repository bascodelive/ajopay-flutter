import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import '../data/notification_repository.dart';
import '../data/models/notification_models.dart';
import 'notifications_page_state.dart';

part 'notification_controller.g.dart';

/// Loads and paginates the caller's own notification list. Only one of
/// these ever exists (no family/key needed — unlike Contributions,
/// there's no per-ledger scoping here), so a plain `@riverpod` class is
/// enough. The initial load uses the generated AsyncNotifier's own
/// AsyncValue (loading/error/data); `loadMore` mutates the inner
/// NotificationsPageState's own fields instead of the outer AsyncValue —
/// same reasoning as ContributionsPageState's own doc comment.
@riverpod
class NotificationsPager extends _$NotificationsPager {
  static const _pageSize = 20;

  @override
  Future<NotificationsPageState> build() async {
    final repository = ref.read(notificationRepositoryProvider);
    final result = await repository.list(page: 0, size: _pageSize);
    return NotificationsPageState(
      items: result.content,
      page: 0,
      hasMore: !result.last,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));
    final repository = ref.read(notificationRepositoryProvider);
    try {
      final nextPage = current.page + 1;
      final result = await repository.list(page: nextPage, size: _pageSize);
      state = AsyncData(current.copyWith(
        items: [...current.items, ...result.content],
        page: nextPage,
        hasMore: !result.last,
        isLoadingMore: false,
      ));
    } on ApiException catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: e.message));
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// For a notification-bell badge — deliberately separate from the pager
/// above (a badge count shouldn't force the full list to load, same
/// "proportional complexity" reasoning used elsewhere: pure fetch, no
/// mutation, plain FutureProvider). `.autoDispose` + `requireAuthenticated`
/// — same pattern as every other read provider in this app, so this
/// never survives a logout or fires while unauthenticated.
final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) {
  return requireAuthenticated(
      ref, () => ref.read(notificationRepositoryProvider).unreadCount());
});

/// mark-read / mark-all-read. `keepAlive: true` from the start — same
/// Bug 5 reasoning as ContributionActionController: a mutation
/// controller's `_lastError` must survive between the write and a later
/// separate read.
@Riverpod(keepAlive: true)
class NotificationActionController extends _$NotificationActionController {
  String? _lastError;
  String? get lastError => _lastError;

  @override
  void build() {}

  Future<bool> markRead(String notificationId) async {
    final repository = ref.read(notificationRepositoryProvider);
    try {
      await repository.markRead(notificationId);
      ref.invalidate(notificationsPagerProvider);
      ref.invalidate(unreadNotificationCountProvider);
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  Future<bool> markAllRead() async {
    final repository = ref.read(notificationRepositoryProvider);
    try {
      await repository.markAllRead();
      ref.invalidate(notificationsPagerProvider);
      ref.invalidate(unreadNotificationCountProvider);
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }
}