import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import 'ledger_directory_page_state.dart';
import '../data/ledger_repository.dart';
import '../data/models/ledger_models.dart';

part 'ledger_directory_pager.g.dart';

/// Keyed by (search, orderBy) — was search alone, extended for the Top
/// Rated feature. A NEWEST search and a TOP_RATED search for the same
/// term are genuinely different result sets now, so they need to be
/// genuinely different cache entries, not collide under one key. New
/// search still resets to a fresh page-0 fetch under its own key, same
/// as ContributionsPager is keyed by (ledgerId, scope). Riverpod's
/// family caching means switching between two (search, orderBy)
/// combinations and back reuses whatever was already fetched, rather
/// than re-fetching every time (paired with the screen's own debounce
/// before it ever updates the search half of this key — see
/// LedgerDirectoryScreen).
typedef LedgerDirectoryPagerKey = ({String search, DirectorySort orderBy});

@riverpod
class LedgerDirectoryPager extends _$LedgerDirectoryPager {
  // Same reentrancy guard as ContributionsPager — fast scrolling firing
  // loadMore() twice before the first call's state update lands would
  // otherwise corrupt the accumulated list (duplicate items, or two
  // competing appends racing each other).
  bool _isFetchingMore = false;

  @override
  Future<LedgerDirectoryPageState> build(LedgerDirectoryPagerKey key) {
    return requireAuthenticated(ref, () => _fetchFirstPage(key));
  }

  Future<LedgerDirectoryPageState> _fetchFirstPage(
      LedgerDirectoryPagerKey key) async {
    final repository = ref.read(ledgerRepositoryProvider);
    final response = await repository.getDirectory(
      search: key.search,
      orderBy: key.orderBy,
    );

    return LedgerDirectoryPageState(
      items: response.content,
      page: response.page,
      hasMore: !response.last,
    );
  }

  Future<void> loadMore(LedgerDirectoryPagerKey key) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    state =
        AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    try {
      final repository = ref.read(ledgerRepositoryProvider);
      final nextPage = current.page + 1;
      final response = await repository.getDirectory(
        search: key.search,
        orderBy: key.orderBy,
        page: nextPage,
      );

      state = AsyncData(current.copyWith(
        items: [...current.items, ...response.content],
        page: response.page,
        hasMore: !response.last,
        isLoadingMore: false,
      ));
    } on ApiException catch (e) {
      // Keep the already-loaded items visible — a failed "load more"
      // shouldn't blank out what's already on screen.
      state = AsyncData(
          current.copyWith(isLoadingMore: false, loadMoreError: e.message));
    } finally {
      _isFetchingMore = false;
    }
  }

  /// Re-fetches from page 0 — for pull-to-refresh, and for a fresh
  /// search term or sort mode landing on an already-built key (rare,
  /// since the family key itself changes per (search, orderBy), but
  /// harmless either way).
  Future<void> refresh(LedgerDirectoryPagerKey key) async {
    state =
        const AsyncLoading<LedgerDirectoryPageState>().copyWithPrevious(state);
    state = await AsyncValue.guard(
        () => requireAuthenticated(ref, () => _fetchFirstPage(key)));
  }
}
