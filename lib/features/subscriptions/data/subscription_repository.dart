import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import 'models/subscription_models.dart';

/// Wraps exactly the two client-facing endpoints API.md's Subscriptions
/// section documents. Activation itself never happens through either of
/// these — that's `POST /api/webhooks/paystack`, server-to-server only,
/// nothing this app ever calls directly (SubscriptionWebhookController).
class SubscriptionRepository {
  SubscriptionRepository(this._dio);

  final Dio _dio;

  /// Starts a Premium upgrade attempt. The user is NOT Premium after
  /// this call returns — it only creates a PENDING subscription record
  /// and gets back Paystack's checkout URL. Real activation happens
  /// later, asynchronously, via the webhook once payment completes.
  ///
  /// Note: the backend's `SubscriptionService.initiateUpgrade` doesn't
  /// pass a `callback_url` to Paystack — so there's no deep-link/redirect
  /// back into the app to rely on. Whatever opens `checkoutUrl` (see
  /// SubscriptionController's `upgrade()`) needs its own way of finding
  /// out payment finished — polling `getStatus()`, not a redirect.
  Future<UpgradeResponse> upgrade() async {
    try {
      final response = await _dio.post('/api/subscriptions/upgrade');
      return UpgradeResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<SubscriptionStatusResponse> getStatus() async {
    try {
      final response = await _dio.get('/api/subscriptions/status');
      return SubscriptionStatusResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(dioProvider));
});
