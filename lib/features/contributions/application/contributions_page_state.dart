import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/contribution_models.dart';

part 'contributions_page_state.freezed.dart';

/// Holds one paginated list's accumulated state — used for both the
/// Admin "all contributions" view and the "my contributions" view (same
/// shape, different underlying endpoint, see ContributionsPager).
///
/// `loadMoreError` lives INSIDE this state deliberately, not as a
/// separate instance field on the notifier — that exact pattern (a
/// side-channel field read via a later, separate `ref.read()`) is what
/// caused Bug 5 (see BUILD_PHASES.md): the notifier could be disposed
/// and recreated between the write and the read, silently losing the
/// real error. Folding it into the AsyncValue-wrapped state itself makes
/// that failure mode structurally impossible here, not just unlikely.
@freezed
class ContributionsPageState with _$ContributionsPageState {
  const factory ContributionsPageState({
    @Default([]) List<ContributionResponse> items,
    @Default(0) int page,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    String? loadMoreError,
  }) = _ContributionsPageState;
}
