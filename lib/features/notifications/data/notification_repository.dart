import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/page_response.dart';
import 'models/notification_models.dart';

/// Wraps exactly the endpoints API.md's Notifications section documents.
class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  Future<PageResponse<NotificationResponse>> list({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/notifications',
        queryParameters: {'page': page, 'size': size},
      );
      return PageResponse<NotificationResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => NotificationResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// For a notification-bell badge.
  Future<int> unreadCount() async {
    try {
      final response = await _dio.get('/api/notifications/unread-count');
      return UnreadCountResponse.fromJson(
              response.data as Map<String, dynamic>)
          .unreadCount;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> markRead(String notificationId) async {
    try {
      await _dio.post('/api/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> markAllRead() async {
    try {
      await _dio.post('/api/notifications/read-all');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});