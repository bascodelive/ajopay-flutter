import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import 'ledger_reviews_page_state.dart';
import '../data/ledger_repository.dart';

part 'ledger_reviews_pager.g.dart';

@riverpod
class LedgerReviewsPager extends _$LedgerReviewsPager {
  // Same reentrancy guard as every other pager in this app — fast
  // scrolling firing loadMore() twice before the first call's state
  // update lands would otherwise corrupt the accumulated list.
  bool _isFetchingMore = false;

  @override
  Future<LedgerReviewsPageState> build(String ledgerId) {
    return requireAuthenticated(ref, () => _fetchFirstPage(ledgerId));
  }

  Future<LedgerReviewsPageState> _fetchFirstPage(String ledgerId) async {
    final repository = ref.read(ledgerRepositoryProvider);
    final response = await repository.getReviews(ledgerId);

    return LedgerReviewsPageState(
      items: response.content,
      page: response.page,
      hasMore: !response.last,
    );
  }

  Future<void> loadMore(String ledgerId) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    state =
        AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    try {
      final repository = ref.read(ledgerRepositoryProvider);
      final nextPage = current.page + 1;
      final response = await repository.getReviews(ledgerId, page: nextPage);

      state = AsyncData(current.copyWith(
        items: [...current.items, ...response.content],
        page: response.page,
        hasMore: !response.last,
        isLoadingMore: false,
      ));
    } on ApiException catch (e) {
      state = AsyncData(
          current.copyWith(isLoadingMore: false, loadMoreError: e.message));
    } finally {
      _isFetchingMore = false;
    }
  }

  /// Re-fetches from page 0 — pull-to-refresh, and called by
  /// `LedgerController.rateLedger` on a successful submit so a freshly
  /// written review appears without a manual refresh.
  Future<void> refresh(String ledgerId) async {
    state =
        const AsyncLoading<LedgerReviewsPageState>().copyWithPrevious(state);
    state = await AsyncValue.guard(
        () => requireAuthenticated(ref, () => _fetchFirstPage(ledgerId)));
  }
}
