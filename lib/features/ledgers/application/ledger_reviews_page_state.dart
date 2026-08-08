import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/ledger_models.dart';

part 'ledger_reviews_page_state.freezed.dart';

/// Same shape as `LedgerDirectoryPageState`/`ContributionsPageState` —
/// `loadMoreError` lives inside the state itself, not a side-channel
/// field (Bug 5's lesson, applied from the start here rather than
/// discovered again).
@freezed
class LedgerReviewsPageState with _$LedgerReviewsPageState {
  const factory LedgerReviewsPageState({
    required List<LedgerReviewResponse> items,
    required int page,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
    String? loadMoreError,
  }) = _LedgerReviewsPageState;
}
