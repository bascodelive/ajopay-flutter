// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsPagerHash() =>
    r'fbf32ec4d30b6c1fee14ed7527bcdb9fa6b8aeab';

/// Loads and paginates the caller's own notification list. Only one of
/// these ever exists (no family/key needed — unlike Contributions,
/// there's no per-ledger scoping here), so a plain `@riverpod` class is
/// enough. The initial load uses the generated AsyncNotifier's own
/// AsyncValue (loading/error/data); `loadMore` mutates the inner
/// NotificationsPageState's own fields instead of the outer AsyncValue —
/// same reasoning as ContributionsPageState's own doc comment.
///
/// Copied from [NotificationsPager].
@ProviderFor(NotificationsPager)
final notificationsPagerProvider = AutoDisposeAsyncNotifierProvider<
    NotificationsPager, NotificationsPageState>.internal(
  NotificationsPager.new,
  name: r'notificationsPagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsPagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsPager = AutoDisposeAsyncNotifier<NotificationsPageState>;
String _$notificationActionControllerHash() =>
    r'05b289dc46cf0a9a086dbff0e55027886a1dc34f';

/// mark-read / mark-all-read. `keepAlive: true` from the start — same
/// Bug 5 reasoning as ContributionActionController: a mutation
/// controller's `_lastError` must survive between the write and a later
/// separate read.
///
/// Copied from [NotificationActionController].
@ProviderFor(NotificationActionController)
final notificationActionControllerProvider =
    NotifierProvider<NotificationActionController, void>.internal(
  NotificationActionController.new,
  name: r'notificationActionControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationActionControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationActionController = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
