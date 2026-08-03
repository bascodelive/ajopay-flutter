import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/page_response.dart';
import 'models/message_models.dart';

/// Wraps exactly the endpoints API.md's Messages section documents —
/// the three REST endpoints only. The live SSE stream is a separate
/// concern, deliberately NOT routed through Dio (it's a raw long-lived
/// HTTP connection, not a request/response call) — see
/// MessageStreamController for that half.
class MessageRepository {
  MessageRepository(this._dio);

  final Dio _dio;

  /// Premium-gated server-side (and behind a global feature flag) —
  /// expect 403 for a FREE caller or when messaging is disabled
  /// platform-wide. `recipientUserId` null = group thread post.
  Future<MessageResponse> sendMessage(
    String ledgerId, {
    String? recipientUserId,
    required String body,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/messages',
        data: SendMessageRequest(recipientUserId: recipientUserId, body: body)
            .toJson(),
      );
      return MessageResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// The shared group thread — any active member can read, regardless
  /// of subscription tier. Default sort server-side: sentAt ASCENDING,
  /// page size 30 — meaning page 0 is the OLDEST messages, not the most
  /// recent. See MessageThreadPager for why the initial fetch doesn't
  /// naively use page 0.
  Future<PageResponse<MessageResponse>> listGroupThread(
    String ledgerId, {
    int page = 0,
    int size = 30,
  }) async {
    try {
      final response = await _dio.get(
        '/api/ledgers/$ledgerId/messages/group',
        queryParameters: {'page': page, 'size': size},
      );
      return PageResponse<MessageResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MessageResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// The caller's private thread with one other member — `otherUserId`
  /// is the OTHER participant, never the caller. Not visible to the
  /// Group Admin unless the Admin is themselves one of the two people.
  /// Same ascending-sort/page-0-is-oldest caveat as the group thread.
  Future<PageResponse<MessageResponse>> listPrivateThread(
    String ledgerId,
    String otherUserId, {
    int page = 0,
    int size = 30,
  }) async {
    try {
      final response = await _dio.get(
        '/api/ledgers/$ledgerId/messages/private/$otherUserId',
        queryParameters: {'page': page, 'size': size},
      );
      return PageResponse<MessageResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MessageResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref.watch(dioProvider));
});
