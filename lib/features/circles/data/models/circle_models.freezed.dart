// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CircleResponse _$CircleResponseFromJson(Map<String, dynamic> json) {
  return _CircleResponse.fromJson(json);
}

/// @nodoc
mixin _$CircleResponse {
  String get id => throw _privateConstructorUsedError;
  String get ledgerId => throw _privateConstructorUsedError;
  String get startDate =>
      throw _privateConstructorUsedError; // ISO-8601 date (YYYY-MM-DD)
  String? get endDate =>
      throw _privateConstructorUsedError; // null until the circle is started
  String get status =>
      throw _privateConstructorUsedError; // PENDING | ACTIVE | COMPLETED
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CircleResponseCopyWith<CircleResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CircleResponseCopyWith<$Res> {
  factory $CircleResponseCopyWith(
          CircleResponse value, $Res Function(CircleResponse) then) =
      _$CircleResponseCopyWithImpl<$Res, CircleResponse>;
  @useResult
  $Res call(
      {String id,
      String ledgerId,
      String startDate,
      String? endDate,
      String status,
      String createdAt});
}

/// @nodoc
class _$CircleResponseCopyWithImpl<$Res, $Val extends CircleResponse>
    implements $CircleResponseCopyWith<$Res> {
  _$CircleResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ledgerId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ledgerId: null == ledgerId
          ? _value.ledgerId
          : ledgerId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CircleResponseImplCopyWith<$Res>
    implements $CircleResponseCopyWith<$Res> {
  factory _$$CircleResponseImplCopyWith(_$CircleResponseImpl value,
          $Res Function(_$CircleResponseImpl) then) =
      __$$CircleResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ledgerId,
      String startDate,
      String? endDate,
      String status,
      String createdAt});
}

/// @nodoc
class __$$CircleResponseImplCopyWithImpl<$Res>
    extends _$CircleResponseCopyWithImpl<$Res, _$CircleResponseImpl>
    implements _$$CircleResponseImplCopyWith<$Res> {
  __$$CircleResponseImplCopyWithImpl(
      _$CircleResponseImpl _value, $Res Function(_$CircleResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ledgerId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_$CircleResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ledgerId: null == ledgerId
          ? _value.ledgerId
          : ledgerId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CircleResponseImpl implements _CircleResponse {
  const _$CircleResponseImpl(
      {required this.id,
      required this.ledgerId,
      required this.startDate,
      this.endDate,
      required this.status,
      required this.createdAt});

  factory _$CircleResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CircleResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String ledgerId;
  @override
  final String startDate;
// ISO-8601 date (YYYY-MM-DD)
  @override
  final String? endDate;
// null until the circle is started
  @override
  final String status;
// PENDING | ACTIVE | COMPLETED
  @override
  final String createdAt;

  @override
  String toString() {
    return 'CircleResponse(id: $id, ledgerId: $ledgerId, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircleResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ledgerId, ledgerId) ||
                other.ledgerId == ledgerId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, ledgerId, startDate, endDate, status, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CircleResponseImplCopyWith<_$CircleResponseImpl> get copyWith =>
      __$$CircleResponseImplCopyWithImpl<_$CircleResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CircleResponseImplToJson(
      this,
    );
  }
}

abstract class _CircleResponse implements CircleResponse {
  const factory _CircleResponse(
      {required final String id,
      required final String ledgerId,
      required final String startDate,
      final String? endDate,
      required final String status,
      required final String createdAt}) = _$CircleResponseImpl;

  factory _CircleResponse.fromJson(Map<String, dynamic> json) =
      _$CircleResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get ledgerId;
  @override
  String get startDate;
  @override // ISO-8601 date (YYYY-MM-DD)
  String? get endDate;
  @override // null until the circle is started
  String get status;
  @override // PENDING | ACTIVE | COMPLETED
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CircleResponseImplCopyWith<_$CircleResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCircleRequest _$CreateCircleRequestFromJson(Map<String, dynamic> json) {
  return _CreateCircleRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateCircleRequest {
  String get startDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateCircleRequestCopyWith<CreateCircleRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCircleRequestCopyWith<$Res> {
  factory $CreateCircleRequestCopyWith(
          CreateCircleRequest value, $Res Function(CreateCircleRequest) then) =
      _$CreateCircleRequestCopyWithImpl<$Res, CreateCircleRequest>;
  @useResult
  $Res call({String startDate});
}

/// @nodoc
class _$CreateCircleRequestCopyWithImpl<$Res, $Val extends CreateCircleRequest>
    implements $CreateCircleRequestCopyWith<$Res> {
  _$CreateCircleRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCircleRequestImplCopyWith<$Res>
    implements $CreateCircleRequestCopyWith<$Res> {
  factory _$$CreateCircleRequestImplCopyWith(_$CreateCircleRequestImpl value,
          $Res Function(_$CreateCircleRequestImpl) then) =
      __$$CreateCircleRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String startDate});
}

/// @nodoc
class __$$CreateCircleRequestImplCopyWithImpl<$Res>
    extends _$CreateCircleRequestCopyWithImpl<$Res, _$CreateCircleRequestImpl>
    implements _$$CreateCircleRequestImplCopyWith<$Res> {
  __$$CreateCircleRequestImplCopyWithImpl(_$CreateCircleRequestImpl _value,
      $Res Function(_$CreateCircleRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
  }) {
    return _then(_$CreateCircleRequestImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCircleRequestImpl implements _CreateCircleRequest {
  const _$CreateCircleRequestImpl({required this.startDate});

  factory _$CreateCircleRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCircleRequestImplFromJson(json);

  @override
  final String startDate;

  @override
  String toString() {
    return 'CreateCircleRequest(startDate: $startDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCircleRequestImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, startDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCircleRequestImplCopyWith<_$CreateCircleRequestImpl> get copyWith =>
      __$$CreateCircleRequestImplCopyWithImpl<_$CreateCircleRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCircleRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateCircleRequest implements CreateCircleRequest {
  const factory _CreateCircleRequest({required final String startDate}) =
      _$CreateCircleRequestImpl;

  factory _CreateCircleRequest.fromJson(Map<String, dynamic> json) =
      _$CreateCircleRequestImpl.fromJson;

  @override
  String get startDate;
  @override
  @JsonKey(ignore: true)
  _$$CreateCircleRequestImplCopyWith<_$CreateCircleRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CircleParticipantResponse _$CircleParticipantResponseFromJson(
    Map<String, dynamic> json) {
  return _CircleParticipantResponse.fromJson(json);
}

/// @nodoc
mixin _$CircleParticipantResponse {
  String get userId => throw _privateConstructorUsedError;
  String get userFullName => throw _privateConstructorUsedError;
  int get handCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CircleParticipantResponseCopyWith<CircleParticipantResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CircleParticipantResponseCopyWith<$Res> {
  factory $CircleParticipantResponseCopyWith(CircleParticipantResponse value,
          $Res Function(CircleParticipantResponse) then) =
      _$CircleParticipantResponseCopyWithImpl<$Res, CircleParticipantResponse>;
  @useResult
  $Res call({String userId, String userFullName, int handCount});
}

/// @nodoc
class _$CircleParticipantResponseCopyWithImpl<$Res,
        $Val extends CircleParticipantResponse>
    implements $CircleParticipantResponseCopyWith<$Res> {
  _$CircleParticipantResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userFullName = null,
    Object? handCount = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFullName: null == userFullName
          ? _value.userFullName
          : userFullName // ignore: cast_nullable_to_non_nullable
              as String,
      handCount: null == handCount
          ? _value.handCount
          : handCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CircleParticipantResponseImplCopyWith<$Res>
    implements $CircleParticipantResponseCopyWith<$Res> {
  factory _$$CircleParticipantResponseImplCopyWith(
          _$CircleParticipantResponseImpl value,
          $Res Function(_$CircleParticipantResponseImpl) then) =
      __$$CircleParticipantResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String userFullName, int handCount});
}

/// @nodoc
class __$$CircleParticipantResponseImplCopyWithImpl<$Res>
    extends _$CircleParticipantResponseCopyWithImpl<$Res,
        _$CircleParticipantResponseImpl>
    implements _$$CircleParticipantResponseImplCopyWith<$Res> {
  __$$CircleParticipantResponseImplCopyWithImpl(
      _$CircleParticipantResponseImpl _value,
      $Res Function(_$CircleParticipantResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userFullName = null,
    Object? handCount = null,
  }) {
    return _then(_$CircleParticipantResponseImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFullName: null == userFullName
          ? _value.userFullName
          : userFullName // ignore: cast_nullable_to_non_nullable
              as String,
      handCount: null == handCount
          ? _value.handCount
          : handCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CircleParticipantResponseImpl implements _CircleParticipantResponse {
  const _$CircleParticipantResponseImpl(
      {required this.userId,
      required this.userFullName,
      required this.handCount});

  factory _$CircleParticipantResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CircleParticipantResponseImplFromJson(json);

  @override
  final String userId;
  @override
  final String userFullName;
  @override
  final int handCount;

  @override
  String toString() {
    return 'CircleParticipantResponse(userId: $userId, userFullName: $userFullName, handCount: $handCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircleParticipantResponseImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userFullName, userFullName) ||
                other.userFullName == userFullName) &&
            (identical(other.handCount, handCount) ||
                other.handCount == handCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, userFullName, handCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CircleParticipantResponseImplCopyWith<_$CircleParticipantResponseImpl>
      get copyWith => __$$CircleParticipantResponseImplCopyWithImpl<
          _$CircleParticipantResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CircleParticipantResponseImplToJson(
      this,
    );
  }
}

abstract class _CircleParticipantResponse implements CircleParticipantResponse {
  const factory _CircleParticipantResponse(
      {required final String userId,
      required final String userFullName,
      required final int handCount}) = _$CircleParticipantResponseImpl;

  factory _CircleParticipantResponse.fromJson(Map<String, dynamic> json) =
      _$CircleParticipantResponseImpl.fromJson;

  @override
  String get userId;
  @override
  String get userFullName;
  @override
  int get handCount;
  @override
  @JsonKey(ignore: true)
  _$$CircleParticipantResponseImplCopyWith<_$CircleParticipantResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AddParticipantRequest _$AddParticipantRequestFromJson(
    Map<String, dynamic> json) {
  return _AddParticipantRequest.fromJson(json);
}

/// @nodoc
mixin _$AddParticipantRequest {
  String get userId => throw _privateConstructorUsedError;
  int get handCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddParticipantRequestCopyWith<AddParticipantRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddParticipantRequestCopyWith<$Res> {
  factory $AddParticipantRequestCopyWith(AddParticipantRequest value,
          $Res Function(AddParticipantRequest) then) =
      _$AddParticipantRequestCopyWithImpl<$Res, AddParticipantRequest>;
  @useResult
  $Res call({String userId, int handCount});
}

/// @nodoc
class _$AddParticipantRequestCopyWithImpl<$Res,
        $Val extends AddParticipantRequest>
    implements $AddParticipantRequestCopyWith<$Res> {
  _$AddParticipantRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? handCount = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      handCount: null == handCount
          ? _value.handCount
          : handCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddParticipantRequestImplCopyWith<$Res>
    implements $AddParticipantRequestCopyWith<$Res> {
  factory _$$AddParticipantRequestImplCopyWith(
          _$AddParticipantRequestImpl value,
          $Res Function(_$AddParticipantRequestImpl) then) =
      __$$AddParticipantRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, int handCount});
}

/// @nodoc
class __$$AddParticipantRequestImplCopyWithImpl<$Res>
    extends _$AddParticipantRequestCopyWithImpl<$Res,
        _$AddParticipantRequestImpl>
    implements _$$AddParticipantRequestImplCopyWith<$Res> {
  __$$AddParticipantRequestImplCopyWithImpl(_$AddParticipantRequestImpl _value,
      $Res Function(_$AddParticipantRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? handCount = null,
  }) {
    return _then(_$AddParticipantRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      handCount: null == handCount
          ? _value.handCount
          : handCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddParticipantRequestImpl implements _AddParticipantRequest {
  const _$AddParticipantRequestImpl(
      {required this.userId, required this.handCount});

  factory _$AddParticipantRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddParticipantRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final int handCount;

  @override
  String toString() {
    return 'AddParticipantRequest(userId: $userId, handCount: $handCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddParticipantRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.handCount, handCount) ||
                other.handCount == handCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, handCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddParticipantRequestImplCopyWith<_$AddParticipantRequestImpl>
      get copyWith => __$$AddParticipantRequestImplCopyWithImpl<
          _$AddParticipantRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddParticipantRequestImplToJson(
      this,
    );
  }
}

abstract class _AddParticipantRequest implements AddParticipantRequest {
  const factory _AddParticipantRequest(
      {required final String userId,
      required final int handCount}) = _$AddParticipantRequestImpl;

  factory _AddParticipantRequest.fromJson(Map<String, dynamic> json) =
      _$AddParticipantRequestImpl.fromJson;

  @override
  String get userId;
  @override
  int get handCount;
  @override
  @JsonKey(ignore: true)
  _$$AddParticipantRequestImplCopyWith<_$AddParticipantRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AssignRotationRequest _$AssignRotationRequestFromJson(
    Map<String, dynamic> json) {
  return _AssignRotationRequest.fromJson(json);
}

/// @nodoc
mixin _$AssignRotationRequest {
  List<String> get orderedUserIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssignRotationRequestCopyWith<AssignRotationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignRotationRequestCopyWith<$Res> {
  factory $AssignRotationRequestCopyWith(AssignRotationRequest value,
          $Res Function(AssignRotationRequest) then) =
      _$AssignRotationRequestCopyWithImpl<$Res, AssignRotationRequest>;
  @useResult
  $Res call({List<String> orderedUserIds});
}

/// @nodoc
class _$AssignRotationRequestCopyWithImpl<$Res,
        $Val extends AssignRotationRequest>
    implements $AssignRotationRequestCopyWith<$Res> {
  _$AssignRotationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderedUserIds = null,
  }) {
    return _then(_value.copyWith(
      orderedUserIds: null == orderedUserIds
          ? _value.orderedUserIds
          : orderedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssignRotationRequestImplCopyWith<$Res>
    implements $AssignRotationRequestCopyWith<$Res> {
  factory _$$AssignRotationRequestImplCopyWith(
          _$AssignRotationRequestImpl value,
          $Res Function(_$AssignRotationRequestImpl) then) =
      __$$AssignRotationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> orderedUserIds});
}

/// @nodoc
class __$$AssignRotationRequestImplCopyWithImpl<$Res>
    extends _$AssignRotationRequestCopyWithImpl<$Res,
        _$AssignRotationRequestImpl>
    implements _$$AssignRotationRequestImplCopyWith<$Res> {
  __$$AssignRotationRequestImplCopyWithImpl(_$AssignRotationRequestImpl _value,
      $Res Function(_$AssignRotationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderedUserIds = null,
  }) {
    return _then(_$AssignRotationRequestImpl(
      orderedUserIds: null == orderedUserIds
          ? _value._orderedUserIds
          : orderedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignRotationRequestImpl implements _AssignRotationRequest {
  const _$AssignRotationRequestImpl(
      {required final List<String> orderedUserIds})
      : _orderedUserIds = orderedUserIds;

  factory _$AssignRotationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignRotationRequestImplFromJson(json);

  final List<String> _orderedUserIds;
  @override
  List<String> get orderedUserIds {
    if (_orderedUserIds is EqualUnmodifiableListView) return _orderedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderedUserIds);
  }

  @override
  String toString() {
    return 'AssignRotationRequest(orderedUserIds: $orderedUserIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignRotationRequestImpl &&
            const DeepCollectionEquality()
                .equals(other._orderedUserIds, _orderedUserIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_orderedUserIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignRotationRequestImplCopyWith<_$AssignRotationRequestImpl>
      get copyWith => __$$AssignRotationRequestImplCopyWithImpl<
          _$AssignRotationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignRotationRequestImplToJson(
      this,
    );
  }
}

abstract class _AssignRotationRequest implements AssignRotationRequest {
  const factory _AssignRotationRequest(
          {required final List<String> orderedUserIds}) =
      _$AssignRotationRequestImpl;

  factory _AssignRotationRequest.fromJson(Map<String, dynamic> json) =
      _$AssignRotationRequestImpl.fromJson;

  @override
  List<String> get orderedUserIds;
  @override
  @JsonKey(ignore: true)
  _$$AssignRotationRequestImplCopyWith<_$AssignRotationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RotationSlotResponse _$RotationSlotResponseFromJson(Map<String, dynamic> json) {
  return _RotationSlotResponse.fromJson(json);
}

/// @nodoc
mixin _$RotationSlotResponse {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userFullName => throw _privateConstructorUsedError;
  int get handNumber =>
      throw _privateConstructorUsedError; // 1-indexed, display only
  int get position =>
      throw _privateConstructorUsedError; // 0-indexed, the real ordering key
  String? get scheduledDate =>
      throw _privateConstructorUsedError; // null until the circle starts
  String get status => throw _privateConstructorUsedError; // PENDING | PAID
  double? get amount => throw _privateConstructorUsedError; // null until PAID
  String? get paidAt => throw _privateConstructorUsedError;

  /// Set once the slot's own recipient self-confirms they actually
  /// received the payout an Admin already confirmed. Null until then.
  /// Purely a transparency layer — does NOT gate the rotation moving
  /// forward (confirmPayout already advanced the queue by the time
  /// this can even be called); only meaningful once `status == 'PAID'`.
  String? get recipientConfirmedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RotationSlotResponseCopyWith<RotationSlotResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RotationSlotResponseCopyWith<$Res> {
  factory $RotationSlotResponseCopyWith(RotationSlotResponse value,
          $Res Function(RotationSlotResponse) then) =
      _$RotationSlotResponseCopyWithImpl<$Res, RotationSlotResponse>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userFullName,
      int handNumber,
      int position,
      String? scheduledDate,
      String status,
      double? amount,
      String? paidAt,
      String? recipientConfirmedAt});
}

/// @nodoc
class _$RotationSlotResponseCopyWithImpl<$Res,
        $Val extends RotationSlotResponse>
    implements $RotationSlotResponseCopyWith<$Res> {
  _$RotationSlotResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userFullName = null,
    Object? handNumber = null,
    Object? position = null,
    Object? scheduledDate = freezed,
    Object? status = null,
    Object? amount = freezed,
    Object? paidAt = freezed,
    Object? recipientConfirmedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFullName: null == userFullName
          ? _value.userFullName
          : userFullName // ignore: cast_nullable_to_non_nullable
              as String,
      handNumber: null == handNumber
          ? _value.handNumber
          : handNumber // ignore: cast_nullable_to_non_nullable
              as int,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledDate: freezed == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientConfirmedAt: freezed == recipientConfirmedAt
          ? _value.recipientConfirmedAt
          : recipientConfirmedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RotationSlotResponseImplCopyWith<$Res>
    implements $RotationSlotResponseCopyWith<$Res> {
  factory _$$RotationSlotResponseImplCopyWith(_$RotationSlotResponseImpl value,
          $Res Function(_$RotationSlotResponseImpl) then) =
      __$$RotationSlotResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userFullName,
      int handNumber,
      int position,
      String? scheduledDate,
      String status,
      double? amount,
      String? paidAt,
      String? recipientConfirmedAt});
}

/// @nodoc
class __$$RotationSlotResponseImplCopyWithImpl<$Res>
    extends _$RotationSlotResponseCopyWithImpl<$Res, _$RotationSlotResponseImpl>
    implements _$$RotationSlotResponseImplCopyWith<$Res> {
  __$$RotationSlotResponseImplCopyWithImpl(_$RotationSlotResponseImpl _value,
      $Res Function(_$RotationSlotResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userFullName = null,
    Object? handNumber = null,
    Object? position = null,
    Object? scheduledDate = freezed,
    Object? status = null,
    Object? amount = freezed,
    Object? paidAt = freezed,
    Object? recipientConfirmedAt = freezed,
  }) {
    return _then(_$RotationSlotResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFullName: null == userFullName
          ? _value.userFullName
          : userFullName // ignore: cast_nullable_to_non_nullable
              as String,
      handNumber: null == handNumber
          ? _value.handNumber
          : handNumber // ignore: cast_nullable_to_non_nullable
              as int,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledDate: freezed == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientConfirmedAt: freezed == recipientConfirmedAt
          ? _value.recipientConfirmedAt
          : recipientConfirmedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RotationSlotResponseImpl implements _RotationSlotResponse {
  const _$RotationSlotResponseImpl(
      {required this.id,
      required this.userId,
      required this.userFullName,
      required this.handNumber,
      required this.position,
      this.scheduledDate,
      required this.status,
      this.amount,
      this.paidAt,
      this.recipientConfirmedAt});

  factory _$RotationSlotResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RotationSlotResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userFullName;
  @override
  final int handNumber;
// 1-indexed, display only
  @override
  final int position;
// 0-indexed, the real ordering key
  @override
  final String? scheduledDate;
// null until the circle starts
  @override
  final String status;
// PENDING | PAID
  @override
  final double? amount;
// null until PAID
  @override
  final String? paidAt;

  /// Set once the slot's own recipient self-confirms they actually
  /// received the payout an Admin already confirmed. Null until then.
  /// Purely a transparency layer — does NOT gate the rotation moving
  /// forward (confirmPayout already advanced the queue by the time
  /// this can even be called); only meaningful once `status == 'PAID'`.
  @override
  final String? recipientConfirmedAt;

  @override
  String toString() {
    return 'RotationSlotResponse(id: $id, userId: $userId, userFullName: $userFullName, handNumber: $handNumber, position: $position, scheduledDate: $scheduledDate, status: $status, amount: $amount, paidAt: $paidAt, recipientConfirmedAt: $recipientConfirmedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RotationSlotResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userFullName, userFullName) ||
                other.userFullName == userFullName) &&
            (identical(other.handNumber, handNumber) ||
                other.handNumber == handNumber) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.recipientConfirmedAt, recipientConfirmedAt) ||
                other.recipientConfirmedAt == recipientConfirmedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userFullName,
      handNumber,
      position,
      scheduledDate,
      status,
      amount,
      paidAt,
      recipientConfirmedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RotationSlotResponseImplCopyWith<_$RotationSlotResponseImpl>
      get copyWith =>
          __$$RotationSlotResponseImplCopyWithImpl<_$RotationSlotResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RotationSlotResponseImplToJson(
      this,
    );
  }
}

abstract class _RotationSlotResponse implements RotationSlotResponse {
  const factory _RotationSlotResponse(
      {required final String id,
      required final String userId,
      required final String userFullName,
      required final int handNumber,
      required final int position,
      final String? scheduledDate,
      required final String status,
      final double? amount,
      final String? paidAt,
      final String? recipientConfirmedAt}) = _$RotationSlotResponseImpl;

  factory _RotationSlotResponse.fromJson(Map<String, dynamic> json) =
      _$RotationSlotResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userFullName;
  @override
  int get handNumber;
  @override // 1-indexed, display only
  int get position;
  @override // 0-indexed, the real ordering key
  String? get scheduledDate;
  @override // null until the circle starts
  String get status;
  @override // PENDING | PAID
  double? get amount;
  @override // null until PAID
  String? get paidAt;
  @override

  /// Set once the slot's own recipient self-confirms they actually
  /// received the payout an Admin already confirmed. Null until then.
  /// Purely a transparency layer — does NOT gate the rotation moving
  /// forward (confirmPayout already advanced the queue by the time
  /// this can even be called); only meaningful once `status == 'PAID'`.
  String? get recipientConfirmedAt;
  @override
  @JsonKey(ignore: true)
  _$$RotationSlotResponseImplCopyWith<_$RotationSlotResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CurrentPayoutResponse _$CurrentPayoutResponseFromJson(
    Map<String, dynamic> json) {
  return _CurrentPayoutResponse.fromJson(json);
}

/// @nodoc
mixin _$CurrentPayoutResponse {
  String get slotId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userFullName => throw _privateConstructorUsedError;
  int get handNumber => throw _privateConstructorUsedError;
  String get scheduledDate => throw _privateConstructorUsedError;
  double get confirmedSoFar => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CurrentPayoutResponseCopyWith<CurrentPayoutResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentPayoutResponseCopyWith<$Res> {
  factory $CurrentPayoutResponseCopyWith(CurrentPayoutResponse value,
          $Res Function(CurrentPayoutResponse) then) =
      _$CurrentPayoutResponseCopyWithImpl<$Res, CurrentPayoutResponse>;
  @useResult
  $Res call(
      {String slotId,
      String userId,
      String userFullName,
      int handNumber,
      String scheduledDate,
      double confirmedSoFar,
      double targetAmount});
}

/// @nodoc
class _$CurrentPayoutResponseCopyWithImpl<$Res,
        $Val extends CurrentPayoutResponse>
    implements $CurrentPayoutResponseCopyWith<$Res> {
  _$CurrentPayoutResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slotId = null,
    Object? userId = null,
    Object? userFullName = null,
    Object? handNumber = null,
    Object? scheduledDate = null,
    Object? confirmedSoFar = null,
    Object? targetAmount = null,
  }) {
    return _then(_value.copyWith(
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFullName: null == userFullName
          ? _value.userFullName
          : userFullName // ignore: cast_nullable_to_non_nullable
              as String,
      handNumber: null == handNumber
          ? _value.handNumber
          : handNumber // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedSoFar: null == confirmedSoFar
          ? _value.confirmedSoFar
          : confirmedSoFar // ignore: cast_nullable_to_non_nullable
              as double,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentPayoutResponseImplCopyWith<$Res>
    implements $CurrentPayoutResponseCopyWith<$Res> {
  factory _$$CurrentPayoutResponseImplCopyWith(
          _$CurrentPayoutResponseImpl value,
          $Res Function(_$CurrentPayoutResponseImpl) then) =
      __$$CurrentPayoutResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String slotId,
      String userId,
      String userFullName,
      int handNumber,
      String scheduledDate,
      double confirmedSoFar,
      double targetAmount});
}

/// @nodoc
class __$$CurrentPayoutResponseImplCopyWithImpl<$Res>
    extends _$CurrentPayoutResponseCopyWithImpl<$Res,
        _$CurrentPayoutResponseImpl>
    implements _$$CurrentPayoutResponseImplCopyWith<$Res> {
  __$$CurrentPayoutResponseImplCopyWithImpl(_$CurrentPayoutResponseImpl _value,
      $Res Function(_$CurrentPayoutResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slotId = null,
    Object? userId = null,
    Object? userFullName = null,
    Object? handNumber = null,
    Object? scheduledDate = null,
    Object? confirmedSoFar = null,
    Object? targetAmount = null,
  }) {
    return _then(_$CurrentPayoutResponseImpl(
      slotId: null == slotId
          ? _value.slotId
          : slotId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFullName: null == userFullName
          ? _value.userFullName
          : userFullName // ignore: cast_nullable_to_non_nullable
              as String,
      handNumber: null == handNumber
          ? _value.handNumber
          : handNumber // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedSoFar: null == confirmedSoFar
          ? _value.confirmedSoFar
          : confirmedSoFar // ignore: cast_nullable_to_non_nullable
              as double,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentPayoutResponseImpl implements _CurrentPayoutResponse {
  const _$CurrentPayoutResponseImpl(
      {required this.slotId,
      required this.userId,
      required this.userFullName,
      required this.handNumber,
      required this.scheduledDate,
      required this.confirmedSoFar,
      required this.targetAmount});

  factory _$CurrentPayoutResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentPayoutResponseImplFromJson(json);

  @override
  final String slotId;
  @override
  final String userId;
  @override
  final String userFullName;
  @override
  final int handNumber;
  @override
  final String scheduledDate;
  @override
  final double confirmedSoFar;
  @override
  final double targetAmount;

  @override
  String toString() {
    return 'CurrentPayoutResponse(slotId: $slotId, userId: $userId, userFullName: $userFullName, handNumber: $handNumber, scheduledDate: $scheduledDate, confirmedSoFar: $confirmedSoFar, targetAmount: $targetAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentPayoutResponseImpl &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userFullName, userFullName) ||
                other.userFullName == userFullName) &&
            (identical(other.handNumber, handNumber) ||
                other.handNumber == handNumber) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.confirmedSoFar, confirmedSoFar) ||
                other.confirmedSoFar == confirmedSoFar) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, slotId, userId, userFullName,
      handNumber, scheduledDate, confirmedSoFar, targetAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentPayoutResponseImplCopyWith<_$CurrentPayoutResponseImpl>
      get copyWith => __$$CurrentPayoutResponseImplCopyWithImpl<
          _$CurrentPayoutResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentPayoutResponseImplToJson(
      this,
    );
  }
}

abstract class _CurrentPayoutResponse implements CurrentPayoutResponse {
  const factory _CurrentPayoutResponse(
      {required final String slotId,
      required final String userId,
      required final String userFullName,
      required final int handNumber,
      required final String scheduledDate,
      required final double confirmedSoFar,
      required final double targetAmount}) = _$CurrentPayoutResponseImpl;

  factory _CurrentPayoutResponse.fromJson(Map<String, dynamic> json) =
      _$CurrentPayoutResponseImpl.fromJson;

  @override
  String get slotId;
  @override
  String get userId;
  @override
  String get userFullName;
  @override
  int get handNumber;
  @override
  String get scheduledDate;
  @override
  double get confirmedSoFar;
  @override
  double get targetAmount;
  @override
  @JsonKey(ignore: true)
  _$$CurrentPayoutResponseImplCopyWith<_$CurrentPayoutResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConfirmPayoutRequest _$ConfirmPayoutRequestFromJson(Map<String, dynamic> json) {
  return _ConfirmPayoutRequest.fromJson(json);
}

/// @nodoc
mixin _$ConfirmPayoutRequest {
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfirmPayoutRequestCopyWith<ConfirmPayoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmPayoutRequestCopyWith<$Res> {
  factory $ConfirmPayoutRequestCopyWith(ConfirmPayoutRequest value,
          $Res Function(ConfirmPayoutRequest) then) =
      _$ConfirmPayoutRequestCopyWithImpl<$Res, ConfirmPayoutRequest>;
  @useResult
  $Res call({String? note});
}

/// @nodoc
class _$ConfirmPayoutRequestCopyWithImpl<$Res,
        $Val extends ConfirmPayoutRequest>
    implements $ConfirmPayoutRequestCopyWith<$Res> {
  _$ConfirmPayoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfirmPayoutRequestImplCopyWith<$Res>
    implements $ConfirmPayoutRequestCopyWith<$Res> {
  factory _$$ConfirmPayoutRequestImplCopyWith(_$ConfirmPayoutRequestImpl value,
          $Res Function(_$ConfirmPayoutRequestImpl) then) =
      __$$ConfirmPayoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? note});
}

/// @nodoc
class __$$ConfirmPayoutRequestImplCopyWithImpl<$Res>
    extends _$ConfirmPayoutRequestCopyWithImpl<$Res, _$ConfirmPayoutRequestImpl>
    implements _$$ConfirmPayoutRequestImplCopyWith<$Res> {
  __$$ConfirmPayoutRequestImplCopyWithImpl(_$ConfirmPayoutRequestImpl _value,
      $Res Function(_$ConfirmPayoutRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? note = freezed,
  }) {
    return _then(_$ConfirmPayoutRequestImpl(
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfirmPayoutRequestImpl implements _ConfirmPayoutRequest {
  const _$ConfirmPayoutRequestImpl({this.note});

  factory _$ConfirmPayoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfirmPayoutRequestImplFromJson(json);

  @override
  final String? note;

  @override
  String toString() {
    return 'ConfirmPayoutRequest(note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmPayoutRequestImpl &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmPayoutRequestImplCopyWith<_$ConfirmPayoutRequestImpl>
      get copyWith =>
          __$$ConfirmPayoutRequestImplCopyWithImpl<_$ConfirmPayoutRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfirmPayoutRequestImplToJson(
      this,
    );
  }
}

abstract class _ConfirmPayoutRequest implements ConfirmPayoutRequest {
  const factory _ConfirmPayoutRequest({final String? note}) =
      _$ConfirmPayoutRequestImpl;

  factory _ConfirmPayoutRequest.fromJson(Map<String, dynamic> json) =
      _$ConfirmPayoutRequestImpl.fromJson;

  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$ConfirmPayoutRequestImplCopyWith<_$ConfirmPayoutRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CircleActivityLogEntry _$CircleActivityLogEntryFromJson(
    Map<String, dynamic> json) {
  return _CircleActivityLogEntry.fromJson(json);
}

/// @nodoc
mixin _$CircleActivityLogEntry {
  String get id => throw _privateConstructorUsedError;
  String get actorUserId => throw _privateConstructorUsedError;
  String get actorFullName => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CircleActivityLogEntryCopyWith<CircleActivityLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CircleActivityLogEntryCopyWith<$Res> {
  factory $CircleActivityLogEntryCopyWith(CircleActivityLogEntry value,
          $Res Function(CircleActivityLogEntry) then) =
      _$CircleActivityLogEntryCopyWithImpl<$Res, CircleActivityLogEntry>;
  @useResult
  $Res call(
      {String id,
      String actorUserId,
      String actorFullName,
      String action,
      String? note,
      String createdAt});
}

/// @nodoc
class _$CircleActivityLogEntryCopyWithImpl<$Res,
        $Val extends CircleActivityLogEntry>
    implements $CircleActivityLogEntryCopyWith<$Res> {
  _$CircleActivityLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorUserId = null,
    Object? actorFullName = null,
    Object? action = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorUserId: null == actorUserId
          ? _value.actorUserId
          : actorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      actorFullName: null == actorFullName
          ? _value.actorFullName
          : actorFullName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CircleActivityLogEntryImplCopyWith<$Res>
    implements $CircleActivityLogEntryCopyWith<$Res> {
  factory _$$CircleActivityLogEntryImplCopyWith(
          _$CircleActivityLogEntryImpl value,
          $Res Function(_$CircleActivityLogEntryImpl) then) =
      __$$CircleActivityLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String actorUserId,
      String actorFullName,
      String action,
      String? note,
      String createdAt});
}

/// @nodoc
class __$$CircleActivityLogEntryImplCopyWithImpl<$Res>
    extends _$CircleActivityLogEntryCopyWithImpl<$Res,
        _$CircleActivityLogEntryImpl>
    implements _$$CircleActivityLogEntryImplCopyWith<$Res> {
  __$$CircleActivityLogEntryImplCopyWithImpl(
      _$CircleActivityLogEntryImpl _value,
      $Res Function(_$CircleActivityLogEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorUserId = null,
    Object? actorFullName = null,
    Object? action = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CircleActivityLogEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorUserId: null == actorUserId
          ? _value.actorUserId
          : actorUserId // ignore: cast_nullable_to_non_nullable
              as String,
      actorFullName: null == actorFullName
          ? _value.actorFullName
          : actorFullName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CircleActivityLogEntryImpl implements _CircleActivityLogEntry {
  const _$CircleActivityLogEntryImpl(
      {required this.id,
      required this.actorUserId,
      required this.actorFullName,
      required this.action,
      this.note,
      required this.createdAt});

  factory _$CircleActivityLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CircleActivityLogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String actorUserId;
  @override
  final String actorFullName;
  @override
  final String action;
  @override
  final String? note;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'CircleActivityLogEntry(id: $id, actorUserId: $actorUserId, actorFullName: $actorFullName, action: $action, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircleActivityLogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actorUserId, actorUserId) ||
                other.actorUserId == actorUserId) &&
            (identical(other.actorFullName, actorFullName) ||
                other.actorFullName == actorFullName) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, actorUserId, actorFullName, action, note, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CircleActivityLogEntryImplCopyWith<_$CircleActivityLogEntryImpl>
      get copyWith => __$$CircleActivityLogEntryImplCopyWithImpl<
          _$CircleActivityLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CircleActivityLogEntryImplToJson(
      this,
    );
  }
}

abstract class _CircleActivityLogEntry implements CircleActivityLogEntry {
  const factory _CircleActivityLogEntry(
      {required final String id,
      required final String actorUserId,
      required final String actorFullName,
      required final String action,
      final String? note,
      required final String createdAt}) = _$CircleActivityLogEntryImpl;

  factory _CircleActivityLogEntry.fromJson(Map<String, dynamic> json) =
      _$CircleActivityLogEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get actorUserId;
  @override
  String get actorFullName;
  @override
  String get action;
  @override
  String? get note;
  @override
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CircleActivityLogEntryImplCopyWith<_$CircleActivityLogEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
