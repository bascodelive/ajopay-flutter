// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationResponse _$NotificationResponseFromJson(Map<String, dynamic> json) {
  return _NotificationResponse.fromJson(json);
}

/// @nodoc
mixin _$NotificationResponse {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // COMPLAINT_REPLY | CONTRIBUTION_DUE
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;

  /// e.g. the complaint id or contribution id, for deep-linking.
  String? get referenceId => throw _privateConstructorUsedError;

  /// Null for a notification type with no ledger (e.g.
  /// COMPLAINT_REPLY — its detail lookup, GET /api/complaints/{id},
  /// is global/non-nested). Set for CONTRIBUTION_DUE, needed to route
  /// into GET /ledgers/{ledgerId}/contributions/{referenceId}.
  String? get ledgerId => throw _privateConstructorUsedError;
  bool get read => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationResponseCopyWith<NotificationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationResponseCopyWith<$Res> {
  factory $NotificationResponseCopyWith(NotificationResponse value,
          $Res Function(NotificationResponse) then) =
      _$NotificationResponseCopyWithImpl<$Res, NotificationResponse>;
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String body,
      String? referenceId,
      String? ledgerId,
      bool read,
      String createdAt});
}

/// @nodoc
class _$NotificationResponseCopyWithImpl<$Res,
        $Val extends NotificationResponse>
    implements $NotificationResponseCopyWith<$Res> {
  _$NotificationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? referenceId = freezed,
    Object? ledgerId = freezed,
    Object? read = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      ledgerId: freezed == ledgerId
          ? _value.ledgerId
          : ledgerId // ignore: cast_nullable_to_non_nullable
              as String?,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationResponseImplCopyWith<$Res>
    implements $NotificationResponseCopyWith<$Res> {
  factory _$$NotificationResponseImplCopyWith(_$NotificationResponseImpl value,
          $Res Function(_$NotificationResponseImpl) then) =
      __$$NotificationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String body,
      String? referenceId,
      String? ledgerId,
      bool read,
      String createdAt});
}

/// @nodoc
class __$$NotificationResponseImplCopyWithImpl<$Res>
    extends _$NotificationResponseCopyWithImpl<$Res, _$NotificationResponseImpl>
    implements _$$NotificationResponseImplCopyWith<$Res> {
  __$$NotificationResponseImplCopyWithImpl(_$NotificationResponseImpl _value,
      $Res Function(_$NotificationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? referenceId = freezed,
    Object? ledgerId = freezed,
    Object? read = null,
    Object? createdAt = null,
  }) {
    return _then(_$NotificationResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      ledgerId: freezed == ledgerId
          ? _value.ledgerId
          : ledgerId // ignore: cast_nullable_to_non_nullable
              as String?,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationResponseImpl implements _NotificationResponse {
  const _$NotificationResponseImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.body,
      this.referenceId,
      this.ledgerId,
      required this.read,
      required this.createdAt});

  factory _$NotificationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// COMPLAINT_REPLY | CONTRIBUTION_DUE
  @override
  final String title;
  @override
  final String body;

  /// e.g. the complaint id or contribution id, for deep-linking.
  @override
  final String? referenceId;

  /// Null for a notification type with no ledger (e.g.
  /// COMPLAINT_REPLY — its detail lookup, GET /api/complaints/{id},
  /// is global/non-nested). Set for CONTRIBUTION_DUE, needed to route
  /// into GET /ledgers/{ledgerId}/contributions/{referenceId}.
  @override
  final String? ledgerId;
  @override
  final bool read;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'NotificationResponse(id: $id, type: $type, title: $title, body: $body, referenceId: $referenceId, ledgerId: $ledgerId, read: $read, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.ledgerId, ledgerId) ||
                other.ledgerId == ledgerId) &&
            (identical(other.read, read) || other.read == read) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, title, body,
      referenceId, ledgerId, read, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationResponseImplCopyWith<_$NotificationResponseImpl>
      get copyWith =>
          __$$NotificationResponseImplCopyWithImpl<_$NotificationResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationResponseImplToJson(
      this,
    );
  }
}

abstract class _NotificationResponse implements NotificationResponse {
  const factory _NotificationResponse(
      {required final String id,
      required final String type,
      required final String title,
      required final String body,
      final String? referenceId,
      final String? ledgerId,
      required final bool read,
      required final String createdAt}) = _$NotificationResponseImpl;

  factory _NotificationResponse.fromJson(Map<String, dynamic> json) =
      _$NotificationResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override // COMPLAINT_REPLY | CONTRIBUTION_DUE
  String get title;
  @override
  String get body;
  @override

  /// e.g. the complaint id or contribution id, for deep-linking.
  String? get referenceId;
  @override

  /// Null for a notification type with no ledger (e.g.
  /// COMPLAINT_REPLY — its detail lookup, GET /api/complaints/{id},
  /// is global/non-nested). Set for CONTRIBUTION_DUE, needed to route
  /// into GET /ledgers/{ledgerId}/contributions/{referenceId}.
  String? get ledgerId;
  @override
  bool get read;
  @override
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationResponseImplCopyWith<_$NotificationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UnreadCountResponse _$UnreadCountResponseFromJson(Map<String, dynamic> json) {
  return _UnreadCountResponse.fromJson(json);
}

/// @nodoc
mixin _$UnreadCountResponse {
  int get unreadCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnreadCountResponseCopyWith<UnreadCountResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnreadCountResponseCopyWith<$Res> {
  factory $UnreadCountResponseCopyWith(
          UnreadCountResponse value, $Res Function(UnreadCountResponse) then) =
      _$UnreadCountResponseCopyWithImpl<$Res, UnreadCountResponse>;
  @useResult
  $Res call({int unreadCount});
}

/// @nodoc
class _$UnreadCountResponseCopyWithImpl<$Res, $Val extends UnreadCountResponse>
    implements $UnreadCountResponseCopyWith<$Res> {
  _$UnreadCountResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unreadCount = null,
  }) {
    return _then(_value.copyWith(
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnreadCountResponseImplCopyWith<$Res>
    implements $UnreadCountResponseCopyWith<$Res> {
  factory _$$UnreadCountResponseImplCopyWith(_$UnreadCountResponseImpl value,
          $Res Function(_$UnreadCountResponseImpl) then) =
      __$$UnreadCountResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int unreadCount});
}

/// @nodoc
class __$$UnreadCountResponseImplCopyWithImpl<$Res>
    extends _$UnreadCountResponseCopyWithImpl<$Res, _$UnreadCountResponseImpl>
    implements _$$UnreadCountResponseImplCopyWith<$Res> {
  __$$UnreadCountResponseImplCopyWithImpl(_$UnreadCountResponseImpl _value,
      $Res Function(_$UnreadCountResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unreadCount = null,
  }) {
    return _then(_$UnreadCountResponseImpl(
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnreadCountResponseImpl implements _UnreadCountResponse {
  const _$UnreadCountResponseImpl({required this.unreadCount});

  factory _$UnreadCountResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnreadCountResponseImplFromJson(json);

  @override
  final int unreadCount;

  @override
  String toString() {
    return 'UnreadCountResponse(unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnreadCountResponseImpl &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, unreadCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnreadCountResponseImplCopyWith<_$UnreadCountResponseImpl> get copyWith =>
      __$$UnreadCountResponseImplCopyWithImpl<_$UnreadCountResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnreadCountResponseImplToJson(
      this,
    );
  }
}

abstract class _UnreadCountResponse implements UnreadCountResponse {
  const factory _UnreadCountResponse({required final int unreadCount}) =
      _$UnreadCountResponseImpl;

  factory _UnreadCountResponse.fromJson(Map<String, dynamic> json) =
      _$UnreadCountResponseImpl.fromJson;

  @override
  int get unreadCount;
  @override
  @JsonKey(ignore: true)
  _$$UnreadCountResponseImplCopyWith<_$UnreadCountResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
