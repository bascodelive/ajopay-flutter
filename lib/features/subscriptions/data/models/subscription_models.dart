import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_models.freezed.dart';
part 'subscription_models.g.dart';

/// Mirrors the backend's `UpgradeResponse` record exactly
/// (SubscriptionController.initiateUpgrade / SubscriptionService's
/// UpgradeResponse DTO). `checkoutUrl` is Paystack's own hosted
/// checkout page — open it in a browser/webview, don't try to render
/// it as in-app content.
@freezed
class UpgradeResponse with _$UpgradeResponse {
  const factory UpgradeResponse({
    required String checkoutUrl,
    required String reference,
  }) = _UpgradeResponse;

  factory UpgradeResponse.fromJson(Map<String, dynamic> json) =>
      _$UpgradeResponseFromJson(json);
}

/// Mirrors `SubscriptionStatusResponse` exactly. `status` and
/// `expiresAt` are both null when `isPremium` is false — the backend's
/// own `SubscriptionService.getStatus` only ever populates them
/// together, never partially.
///
/// `status` deliberately kept as a plain `String?` here, not a Dart
/// enum — same convention every other status field in this app already
/// uses (LedgerResponse.status, ContributionResponse.status,
/// CircleResponse.status), even though the backend's own
/// `SubscriptionStatus` IS a real Java enum internally. Introducing the
/// one enum-typed status field in the whole app would be inconsistent
/// with everything else, for no real benefit — every existing screen
/// compares status with a plain `==` string check.
@freezed
class SubscriptionStatusResponse with _$SubscriptionStatusResponse {
  const factory SubscriptionStatusResponse({
    required bool isPremium,
    String? status,
    DateTime? expiresAt,
  }) = _SubscriptionStatusResponse;

  factory SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusResponseFromJson(json);
}
