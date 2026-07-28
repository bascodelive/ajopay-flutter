import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import 'contributions_page_state.dart';
import '../data/contribution_repository.dart';
import '../data/models/contribution_models.dart';

part 'contributions_pager.g.dart';

/// ADMIN sees every member's contributions; any active member (including
/// that same Admin) can also see just their own — two genuinely different
/// endpoints/visibility rules (API.md), not a client-side filter over one
/// dataset. One notifier implementation serves both, switched by `scope`,
/// rather than duplicating near-identical pagination logic twice.
enum ContributionScope { all, own }

typedef ContributionsPagerKey = ({String ledgerId, ContributionScope scope});

@riverpod
class ContributionsPager extends _$ContributionsPager {
  // Reentrancy guard against a real, common bug class in infinite-scroll
  // UIs: fast scrolling firing loadMore() twice concurrently before the
  // first call's state update lands, corrupting the accumulated list
  // (duplicate items, or two competing appends racing each other). This
  // flag is purely a synchronous guard checked at the very start of
  // loadMore() — not persisted state, doesn't need to survive rebuilds.
  bool _isFetchingMore = false;

  @override
  Future<ContributionsPageState> build(ContributionsPagerKey key) {
    return requireAuthenticated(ref, () => _fetchFirstPage(key));
  }

  Future<ContributionsPageState> _fetchFirstPage(
      ContributionsPagerKey key) async {
    final repository = ref.read(contributionRepositoryProvider);
    final response = key.scope == ContributionScope.all
        ? await repository.listAllForLedger(key.ledgerId)
        : await repository.listOwnForLedger(key.ledgerId);

    return ContributionsPageState(
      items: response.content,
      page: response.page,
      hasMore: !response.last,
    );
  }

  Future<void> loadMore(ContributionsPagerKey key) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || _isFetchingMore) return;

    _isFetchingMore = true;
    state =
        AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    try {
      final repository = ref.read(contributionRepositoryProvider);
      final nextPage = current.page + 1;
      final response = key.scope == ContributionScope.all
          ? await repository.listAllForLedger(key.ledgerId, page: nextPage)
          : await repository.listOwnForLedger(key.ledgerId, page: nextPage);

      state = AsyncData(current.copyWith(
        items: [...current.items, ...response.content],
        page: response.page,
        hasMore: !response.last,
        isLoadingMore: false,
      ));
    } on ApiException catch (e) {
      // Keep the already-loaded items visible — a failed "load more"
      // shouldn't blank out what's already on screen. Error surfaces
      // through the state itself (see contributions_page_state.dart's
      // doc comment for why this matters, not a side-channel field).
      state = AsyncData(
          current.copyWith(isLoadingMore: false, loadMoreError: e.message));
    } finally {
      _isFetchingMore = false;
    }
  }

  /// Re-fetches from page 0 — for pull-to-refresh, and for after a
  /// mutation (schedule/report/confirm/etc.) changes what this list
  /// should show.
  Future<void> refresh(ContributionsPagerKey key) async {
    state =
        const AsyncLoading<ContributionsPageState>().copyWithPrevious(state);
    state = await AsyncValue.guard(
        () => requireAuthenticated(ref, () => _fetchFirstPage(key)));
  }
}

/// The contribution-detail screen's history — pure fetch, keyed by
/// (ledgerId, contributionId) since the endpoint needs both.
final contributionHistoryProvider = FutureProvider.autoDispose.family<
    List<ContributionActivityLogEntry>,
    ({String ledgerId, String contributionId})>((ref, key) {
  return requireAuthenticated(
    ref,
    () => ref
        .read(contributionRepositoryProvider)
        .getHistory(key.ledgerId, key.contributionId),
  );
});
