import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/notification_models.dart';

part 'notifications_page_state.freezed.dart';

/// Same shape as ContributionsPageState, same reasoning — loadMoreError
/// lives INSIDE this state, not as a separate notifier field, so a
/// disposed-and-recreated notifier can never silently lose it between
/// the write and a later read (BUILD_PHASES.md Bug 5).
@freezed
class NotificationsPageState with _$NotificationsPageState {
  const factory NotificationsPageState({
    @Default([]) List<NotificationResponse> items,
    @Default(0) int page,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    String? loadMoreError,
  }) = _NotificationsPageState;
}