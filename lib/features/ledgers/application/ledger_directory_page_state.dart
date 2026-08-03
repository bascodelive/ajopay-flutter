import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/ledger_models.dart';

part 'ledger_directory_page_state.freezed.dart';

/// Mirrors ContributionsPageState's exact shape — same reasoning: the
/// `loadMoreError` lives INSIDE this state, not as a separate notifier
/// field, so a disposed/recreated notifier between the write and a
/// later read can never silently lose the real error (see
/// contributions_page_state.dart's own doc comment, BUILD_PHASES.md
/// Bug 5).
@freezed
class LedgerDirectoryPageState with _$LedgerDirectoryPageState {
  const factory LedgerDirectoryPageState({
    @Default([]) List<LedgerDirectoryEntryResponse> items,
    @Default(0) int page,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    String? loadMoreError,
  }) = _LedgerDirectoryPageState;
}
