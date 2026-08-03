import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import '../../../shared/models/page_response.dart';
import 'message_thread_page_state.dart';
import '../data/message_repository.dart';
import '../data/models/message_models.dart';

part 'message_thread_pager.g.dart';

enum MessageThreadType { group, private }

/// `otherUserId` is null for a group thread, required for a private one.
/// A record gives correct structural equality for free — same reasoning
/// CircleKey/ContributionsPagerKey already use elsewhere in this app.
typedef MessageThreadKey = ({
  String ledgerId,
  MessageThreadType type,
  String? otherUserId,
});

@riverpod
class MessageThreadPager extends _$MessageThreadPager {
  bool _isFetchingMore = false;

  @override
  Future<MessageThreadPageState> build(MessageThreadKey key) {
    return requireAuthenticated(ref, () => _fetchInitial(key));
  }

  Future<PageResponse<MessageResponse>> _fetchPage(
      MessageThreadKey key, int page) {
    final repository = ref.read(messageRepositoryProvider);
    return key.type == MessageThreadType.group
        ? repository.listGroupThread(key.ledgerId, page: page)
        : repository.listPrivateThread(key.ledgerId, key.otherUserId!,
            page: page);
  }

  /// The backend sorts sentAt ASCENDING — page 0 is the OLDEST messages,
  /// not the most recent. A chat's initial view needs the tail of the
  /// conversation, so this fetches page 0 purely to learn `totalPages`
  /// from its PageResponse metadata, then fetches the ACTUAL last page
  /// as the real initial content (skipped if there's only one page —
  /// the probe result already IS the last page then).
  Future<MessageThreadPageState> _fetchInitial(MessageThreadKey key) async {
    final probe = await _fetchPage(key, 0);
    final lastPageIndex = probe.totalPages == 0 ? 0 : probe.totalPages - 1;

    final response =
        lastPageIndex == 0 ? probe : await _fetchPage(key, lastPageIndex);

    return MessageThreadPageState(
      items: response.content.reversed.toList(),
      earliestPageFetched: lastPageIndex,
      hasMore: lastPageIndex > 0,
    );
  }

  /// "Load more" here means OLDER messages (scrolling toward the top of
  /// a reversed chat list) — the opposite direction from every other
  /// pager in this app. Fetches the chronologically PRECEDING backend
  /// page and appends its (reversed) content to the end of `items`,
  /// since `items` is newest-first and this batch is older than
  /// everything already loaded.
  Future<void> loadMoreOlder(MessageThreadKey key) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    state =
        AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    try {
      final olderPage = current.earliestPageFetched - 1;
      final response = await _fetchPage(key, olderPage);

      state = AsyncData(current.copyWith(
        items: [...current.items, ...response.content.reversed],
        earliestPageFetched: olderPage,
        hasMore: olderPage > 0,
        isLoadingMore: false,
      ));
    } on ApiException catch (e) {
      state = AsyncData(
          current.copyWith(isLoadingMore: false, loadMoreError: e.message));
    } finally {
      _isFetchingMore = false;
    }
  }

  /// Prepends a message that just arrived — either the sender's own
  /// optimistic update right after a successful send, or a live SSE
  /// push. Deduplicates by id, since a sender's own SSE echo arrives a
  /// moment after their own send already inserted it optimistically.
  void prependIncoming(MessageResponse message) {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.items.any((m) => m.id == message.id)) return;
    state = AsyncData(current.copyWith(items: [message, ...current.items]));
  }

  Future<void> refresh(MessageThreadKey key) async {
    state = const AsyncLoading<MessageThreadPageState>()
        .copyWithPrevious(state);
    state = await AsyncValue.guard(
        () => requireAuthenticated(ref, () => _fetchInitial(key)));
  }
}
