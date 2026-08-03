import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/message_models.dart';

part 'message_thread_page_state.freezed.dart';

/// `items` is NEWEST-FIRST (index 0 = most recent) — the opposite of the
/// backend's own ascending sort — because the chat UI uses a `reverse:
/// true` ListView (index 0 anchors at the bottom, matching how every
/// chat app reads). `earliestPageFetched` tracks which backend page
/// (ascending) the OLDEST item currently loaded came from, so
/// "load more" knows to fetch `earliestPageFetched - 1` next, not +1 —
/// see MessageThreadPager.
@freezed
class MessageThreadPageState with _$MessageThreadPageState {
  const factory MessageThreadPageState({
    @Default([]) List<MessageResponse> items,
    @Default(0) int earliestPageFetched,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    String? loadMoreError,
  }) = _MessageThreadPageState;
}
