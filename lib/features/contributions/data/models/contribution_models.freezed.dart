// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contribution_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContributionResponse _$ContributionResponseFromJson(Map<String, dynamic> json) {
  return _ContributionResponse.fromJson(json);
}

/// @nodoc
mixin _$ContributionResponse {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get memberFullName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get cycleDate =>
      throw _privateConstructorUsedError; // ISO-8601 date (YYYY-MM-DD)
  String get status =>
      throw _privateConstructorUsedError; // PENDING | REPORTED | PAID | MISSED
  String? get recordedByFullName => throw _privateConstructorUsedError;
  String? get reportedAt =>
      throw _privateConstructorUsedError; // ISO-8601 timestamp, null until member self-reports
  String? get memberNote => throw _privateConstructorUsedError;

  /// 1-indexed. Always 1 for the original manual per-member scheduling
  /// path (`POST .../contributions`, and its batch counterpart below).
  /// A contribution generated via a Circle's rotation
  /// (`POST .../circles/{id}/generate-cycle-contributions`) reflects
  /// which of a multi-hand participant's turns this row is for — a
  /// 2-hand member has TWO rows for the same cycleDate, one with
  /// handNumber 1 and one with handNumber 2. Note there is no
  /// `circleId` on this response even for circle-generated rows — the
  /// backend's ContributionResponse DTO doesn't carry one; a client
  /// that needs to know which circle a row belongs to has to correlate
  /// by cycleDate/userId against the rotation queue separately.
  int get handNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContributionResponseCopyWith<ContributionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContributionResponseCopyWith<$Res> {
  factory $ContributionResponseCopyWith(ContributionResponse value,
          $Res Function(ContributionResponse) then) =
      _$ContributionResponseCopyWithImpl<$Res, ContributionResponse>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String memberFullName,
      double amount,
      String cycleDate,
      String status,
      String? recordedByFullName,
      String? reportedAt,
      String? memberNote,
      int handNumber});
}

/// @nodoc
class _$ContributionResponseCopyWithImpl<$Res,
        $Val extends ContributionResponse>
    implements $ContributionResponseCopyWith<$Res> {
  _$ContributionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? memberFullName = null,
    Object? amount = null,
    Object? cycleDate = null,
    Object? status = null,
    Object? recordedByFullName = freezed,
    Object? reportedAt = freezed,
    Object? memberNote = freezed,
    Object? handNumber = null,
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
      memberFullName: null == memberFullName
          ? _value.memberFullName
          : memberFullName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      cycleDate: null == cycleDate
          ? _value.cycleDate
          : cycleDate // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recordedByFullName: freezed == recordedByFullName
          ? _value.recordedByFullName
          : recordedByFullName // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: freezed == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      memberNote: freezed == memberNote
          ? _value.memberNote
          : memberNote // ignore: cast_nullable_to_non_nullable
              as String?,
      handNumber: null == handNumber
          ? _value.handNumber
          : handNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContributionResponseImplCopyWith<$Res>
    implements $ContributionResponseCopyWith<$Res> {
  factory _$$ContributionResponseImplCopyWith(_$ContributionResponseImpl value,
          $Res Function(_$ContributionResponseImpl) then) =
      __$$ContributionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String memberFullName,
      double amount,
      String cycleDate,
      String status,
      String? recordedByFullName,
      String? reportedAt,
      String? memberNote,
      int handNumber});
}

/// @nodoc
class __$$ContributionResponseImplCopyWithImpl<$Res>
    extends _$ContributionResponseCopyWithImpl<$Res, _$ContributionResponseImpl>
    implements _$$ContributionResponseImplCopyWith<$Res> {
  __$$ContributionResponseImplCopyWithImpl(_$ContributionResponseImpl _value,
      $Res Function(_$ContributionResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? memberFullName = null,
    Object? amount = null,
    Object? cycleDate = null,
    Object? status = null,
    Object? recordedByFullName = freezed,
    Object? reportedAt = freezed,
    Object? memberNote = freezed,
    Object? handNumber = null,
  }) {
    return _then(_$ContributionResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      memberFullName: null == memberFullName
          ? _value.memberFullName
          : memberFullName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      cycleDate: null == cycleDate
          ? _value.cycleDate
          : cycleDate // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recordedByFullName: freezed == recordedByFullName
          ? _value.recordedByFullName
          : recordedByFullName // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: freezed == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      memberNote: freezed == memberNote
          ? _value.memberNote
          : memberNote // ignore: cast_nullable_to_non_nullable
              as String?,
      handNumber: null == handNumber
          ? _value.handNumber
          : handNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContributionResponseImpl implements _ContributionResponse {
  const _$ContributionResponseImpl(
      {required this.id,
      required this.userId,
      required this.memberFullName,
      required this.amount,
      required this.cycleDate,
      required this.status,
      this.recordedByFullName,
      this.reportedAt,
      this.memberNote,
      this.handNumber = 1});

  factory _$ContributionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContributionResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String memberFullName;
  @override
  final double amount;
  @override
  final String cycleDate;
// ISO-8601 date (YYYY-MM-DD)
  @override
  final String status;
// PENDING | REPORTED | PAID | MISSED
  @override
  final String? recordedByFullName;
  @override
  final String? reportedAt;
// ISO-8601 timestamp, null until member self-reports
  @override
  final String? memberNote;

  /// 1-indexed. Always 1 for the original manual per-member scheduling
  /// path (`POST .../contributions`, and its batch counterpart below).
  /// A contribution generated via a Circle's rotation
  /// (`POST .../circles/{id}/generate-cycle-contributions`) reflects
  /// which of a multi-hand participant's turns this row is for — a
  /// 2-hand member has TWO rows for the same cycleDate, one with
  /// handNumber 1 and one with handNumber 2. Note there is no
  /// `circleId` on this response even for circle-generated rows — the
  /// backend's ContributionResponse DTO doesn't carry one; a client
  /// that needs to know which circle a row belongs to has to correlate
  /// by cycleDate/userId against the rotation queue separately.
  @override
  @JsonKey()
  final int handNumber;

  @override
  String toString() {
    return 'ContributionResponse(id: $id, userId: $userId, memberFullName: $memberFullName, amount: $amount, cycleDate: $cycleDate, status: $status, recordedByFullName: $recordedByFullName, reportedAt: $reportedAt, memberNote: $memberNote, handNumber: $handNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.memberFullName, memberFullName) ||
                other.memberFullName == memberFullName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.cycleDate, cycleDate) ||
                other.cycleDate == cycleDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.recordedByFullName, recordedByFullName) ||
                other.recordedByFullName == recordedByFullName) &&
            (identical(other.reportedAt, reportedAt) ||
                other.reportedAt == reportedAt) &&
            (identical(other.memberNote, memberNote) ||
                other.memberNote == memberNote) &&
            (identical(other.handNumber, handNumber) ||
                other.handNumber == handNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      memberFullName,
      amount,
      cycleDate,
      status,
      recordedByFullName,
      reportedAt,
      memberNote,
      handNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionResponseImplCopyWith<_$ContributionResponseImpl>
      get copyWith =>
          __$$ContributionResponseImplCopyWithImpl<_$ContributionResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContributionResponseImplToJson(
      this,
    );
  }
}

abstract class _ContributionResponse implements ContributionResponse {
  const factory _ContributionResponse(
      {required final String id,
      required final String userId,
      required final String memberFullName,
      required final double amount,
      required final String cycleDate,
      required final String status,
      final String? recordedByFullName,
      final String? reportedAt,
      final String? memberNote,
      final int handNumber}) = _$ContributionResponseImpl;

  factory _ContributionResponse.fromJson(Map<String, dynamic> json) =
      _$ContributionResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get memberFullName;
  @override
  double get amount;
  @override
  String get cycleDate;
  @override // ISO-8601 date (YYYY-MM-DD)
  String get status;
  @override // PENDING | REPORTED | PAID | MISSED
  String? get recordedByFullName;
  @override
  String? get reportedAt;
  @override // ISO-8601 timestamp, null until member self-reports
  String? get memberNote;
  @override

  /// 1-indexed. Always 1 for the original manual per-member scheduling
  /// path (`POST .../contributions`, and its batch counterpart below).
  /// A contribution generated via a Circle's rotation
  /// (`POST .../circles/{id}/generate-cycle-contributions`) reflects
  /// which of a multi-hand participant's turns this row is for — a
  /// 2-hand member has TWO rows for the same cycleDate, one with
  /// handNumber 1 and one with handNumber 2. Note there is no
  /// `circleId` on this response even for circle-generated rows — the
  /// backend's ContributionResponse DTO doesn't carry one; a client
  /// that needs to know which circle a row belongs to has to correlate
  /// by cycleDate/userId against the rotation queue separately.
  int get handNumber;
  @override
  @JsonKey(ignore: true)
  _$$ContributionResponseImplCopyWith<_$ContributionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ScheduleContributionRequest _$ScheduleContributionRequestFromJson(
    Map<String, dynamic> json) {
  return _ScheduleContributionRequest.fromJson(json);
}

/// @nodoc
mixin _$ScheduleContributionRequest {
  String get memberUserId => throw _privateConstructorUsedError;
  String get cycleDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduleContributionRequestCopyWith<ScheduleContributionRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleContributionRequestCopyWith<$Res> {
  factory $ScheduleContributionRequestCopyWith(
          ScheduleContributionRequest value,
          $Res Function(ScheduleContributionRequest) then) =
      _$ScheduleContributionRequestCopyWithImpl<$Res,
          ScheduleContributionRequest>;
  @useResult
  $Res call({String memberUserId, String cycleDate});
}

/// @nodoc
class _$ScheduleContributionRequestCopyWithImpl<$Res,
        $Val extends ScheduleContributionRequest>
    implements $ScheduleContributionRequestCopyWith<$Res> {
  _$ScheduleContributionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberUserId = null,
    Object? cycleDate = null,
  }) {
    return _then(_value.copyWith(
      memberUserId: null == memberUserId
          ? _value.memberUserId
          : memberUserId // ignore: cast_nullable_to_non_nullable
              as String,
      cycleDate: null == cycleDate
          ? _value.cycleDate
          : cycleDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleContributionRequestImplCopyWith<$Res>
    implements $ScheduleContributionRequestCopyWith<$Res> {
  factory _$$ScheduleContributionRequestImplCopyWith(
          _$ScheduleContributionRequestImpl value,
          $Res Function(_$ScheduleContributionRequestImpl) then) =
      __$$ScheduleContributionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String memberUserId, String cycleDate});
}

/// @nodoc
class __$$ScheduleContributionRequestImplCopyWithImpl<$Res>
    extends _$ScheduleContributionRequestCopyWithImpl<$Res,
        _$ScheduleContributionRequestImpl>
    implements _$$ScheduleContributionRequestImplCopyWith<$Res> {
  __$$ScheduleContributionRequestImplCopyWithImpl(
      _$ScheduleContributionRequestImpl _value,
      $Res Function(_$ScheduleContributionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberUserId = null,
    Object? cycleDate = null,
  }) {
    return _then(_$ScheduleContributionRequestImpl(
      memberUserId: null == memberUserId
          ? _value.memberUserId
          : memberUserId // ignore: cast_nullable_to_non_nullable
              as String,
      cycleDate: null == cycleDate
          ? _value.cycleDate
          : cycleDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleContributionRequestImpl
    implements _ScheduleContributionRequest {
  const _$ScheduleContributionRequestImpl(
      {required this.memberUserId, required this.cycleDate});

  factory _$ScheduleContributionRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ScheduleContributionRequestImplFromJson(json);

  @override
  final String memberUserId;
  @override
  final String cycleDate;

  @override
  String toString() {
    return 'ScheduleContributionRequest(memberUserId: $memberUserId, cycleDate: $cycleDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleContributionRequestImpl &&
            (identical(other.memberUserId, memberUserId) ||
                other.memberUserId == memberUserId) &&
            (identical(other.cycleDate, cycleDate) ||
                other.cycleDate == cycleDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, memberUserId, cycleDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleContributionRequestImplCopyWith<_$ScheduleContributionRequestImpl>
      get copyWith => __$$ScheduleContributionRequestImplCopyWithImpl<
          _$ScheduleContributionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleContributionRequestImplToJson(
      this,
    );
  }
}

abstract class _ScheduleContributionRequest
    implements ScheduleContributionRequest {
  const factory _ScheduleContributionRequest(
      {required final String memberUserId,
      required final String cycleDate}) = _$ScheduleContributionRequestImpl;

  factory _ScheduleContributionRequest.fromJson(Map<String, dynamic> json) =
      _$ScheduleContributionRequestImpl.fromJson;

  @override
  String get memberUserId;
  @override
  String get cycleDate;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleContributionRequestImplCopyWith<_$ScheduleContributionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchScheduleContributionRequest _$BatchScheduleContributionRequestFromJson(
    Map<String, dynamic> json) {
  return _BatchScheduleContributionRequest.fromJson(json);
}

/// @nodoc
mixin _$BatchScheduleContributionRequest {
  List<String> get memberUserIds => throw _privateConstructorUsedError;
  String get cycleDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BatchScheduleContributionRequestCopyWith<BatchScheduleContributionRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchScheduleContributionRequestCopyWith<$Res> {
  factory $BatchScheduleContributionRequestCopyWith(
          BatchScheduleContributionRequest value,
          $Res Function(BatchScheduleContributionRequest) then) =
      _$BatchScheduleContributionRequestCopyWithImpl<$Res,
          BatchScheduleContributionRequest>;
  @useResult
  $Res call({List<String> memberUserIds, String cycleDate});
}

/// @nodoc
class _$BatchScheduleContributionRequestCopyWithImpl<$Res,
        $Val extends BatchScheduleContributionRequest>
    implements $BatchScheduleContributionRequestCopyWith<$Res> {
  _$BatchScheduleContributionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberUserIds = null,
    Object? cycleDate = null,
  }) {
    return _then(_value.copyWith(
      memberUserIds: null == memberUserIds
          ? _value.memberUserIds
          : memberUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cycleDate: null == cycleDate
          ? _value.cycleDate
          : cycleDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchScheduleContributionRequestImplCopyWith<$Res>
    implements $BatchScheduleContributionRequestCopyWith<$Res> {
  factory _$$BatchScheduleContributionRequestImplCopyWith(
          _$BatchScheduleContributionRequestImpl value,
          $Res Function(_$BatchScheduleContributionRequestImpl) then) =
      __$$BatchScheduleContributionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> memberUserIds, String cycleDate});
}

/// @nodoc
class __$$BatchScheduleContributionRequestImplCopyWithImpl<$Res>
    extends _$BatchScheduleContributionRequestCopyWithImpl<$Res,
        _$BatchScheduleContributionRequestImpl>
    implements _$$BatchScheduleContributionRequestImplCopyWith<$Res> {
  __$$BatchScheduleContributionRequestImplCopyWithImpl(
      _$BatchScheduleContributionRequestImpl _value,
      $Res Function(_$BatchScheduleContributionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberUserIds = null,
    Object? cycleDate = null,
  }) {
    return _then(_$BatchScheduleContributionRequestImpl(
      memberUserIds: null == memberUserIds
          ? _value._memberUserIds
          : memberUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cycleDate: null == cycleDate
          ? _value.cycleDate
          : cycleDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchScheduleContributionRequestImpl
    implements _BatchScheduleContributionRequest {
  const _$BatchScheduleContributionRequestImpl(
      {required final List<String> memberUserIds, required this.cycleDate})
      : _memberUserIds = memberUserIds;

  factory _$BatchScheduleContributionRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BatchScheduleContributionRequestImplFromJson(json);

  final List<String> _memberUserIds;
  @override
  List<String> get memberUserIds {
    if (_memberUserIds is EqualUnmodifiableListView) return _memberUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberUserIds);
  }

  @override
  final String cycleDate;

  @override
  String toString() {
    return 'BatchScheduleContributionRequest(memberUserIds: $memberUserIds, cycleDate: $cycleDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchScheduleContributionRequestImpl &&
            const DeepCollectionEquality()
                .equals(other._memberUserIds, _memberUserIds) &&
            (identical(other.cycleDate, cycleDate) ||
                other.cycleDate == cycleDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_memberUserIds), cycleDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchScheduleContributionRequestImplCopyWith<
          _$BatchScheduleContributionRequestImpl>
      get copyWith => __$$BatchScheduleContributionRequestImplCopyWithImpl<
          _$BatchScheduleContributionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchScheduleContributionRequestImplToJson(
      this,
    );
  }
}

abstract class _BatchScheduleContributionRequest
    implements BatchScheduleContributionRequest {
  const factory _BatchScheduleContributionRequest(
          {required final List<String> memberUserIds,
          required final String cycleDate}) =
      _$BatchScheduleContributionRequestImpl;

  factory _BatchScheduleContributionRequest.fromJson(
          Map<String, dynamic> json) =
      _$BatchScheduleContributionRequestImpl.fromJson;

  @override
  List<String> get memberUserIds;
  @override
  String get cycleDate;
  @override
  @JsonKey(ignore: true)
  _$$BatchScheduleContributionRequestImplCopyWith<
          _$BatchScheduleContributionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchScheduleContributionResponse _$BatchScheduleContributionResponseFromJson(
    Map<String, dynamic> json) {
  return _BatchScheduleContributionResponse.fromJson(json);
}

/// @nodoc
mixin _$BatchScheduleContributionResponse {
  List<ContributionResponse> get created => throw _privateConstructorUsedError;
  List<SkippedMember> get skipped => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BatchScheduleContributionResponseCopyWith<BatchScheduleContributionResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchScheduleContributionResponseCopyWith<$Res> {
  factory $BatchScheduleContributionResponseCopyWith(
          BatchScheduleContributionResponse value,
          $Res Function(BatchScheduleContributionResponse) then) =
      _$BatchScheduleContributionResponseCopyWithImpl<$Res,
          BatchScheduleContributionResponse>;
  @useResult
  $Res call({List<ContributionResponse> created, List<SkippedMember> skipped});
}

/// @nodoc
class _$BatchScheduleContributionResponseCopyWithImpl<$Res,
        $Val extends BatchScheduleContributionResponse>
    implements $BatchScheduleContributionResponseCopyWith<$Res> {
  _$BatchScheduleContributionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? created = null,
    Object? skipped = null,
  }) {
    return _then(_value.copyWith(
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as List<ContributionResponse>,
      skipped: null == skipped
          ? _value.skipped
          : skipped // ignore: cast_nullable_to_non_nullable
              as List<SkippedMember>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchScheduleContributionResponseImplCopyWith<$Res>
    implements $BatchScheduleContributionResponseCopyWith<$Res> {
  factory _$$BatchScheduleContributionResponseImplCopyWith(
          _$BatchScheduleContributionResponseImpl value,
          $Res Function(_$BatchScheduleContributionResponseImpl) then) =
      __$$BatchScheduleContributionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ContributionResponse> created, List<SkippedMember> skipped});
}

/// @nodoc
class __$$BatchScheduleContributionResponseImplCopyWithImpl<$Res>
    extends _$BatchScheduleContributionResponseCopyWithImpl<$Res,
        _$BatchScheduleContributionResponseImpl>
    implements _$$BatchScheduleContributionResponseImplCopyWith<$Res> {
  __$$BatchScheduleContributionResponseImplCopyWithImpl(
      _$BatchScheduleContributionResponseImpl _value,
      $Res Function(_$BatchScheduleContributionResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? created = null,
    Object? skipped = null,
  }) {
    return _then(_$BatchScheduleContributionResponseImpl(
      created: null == created
          ? _value._created
          : created // ignore: cast_nullable_to_non_nullable
              as List<ContributionResponse>,
      skipped: null == skipped
          ? _value._skipped
          : skipped // ignore: cast_nullable_to_non_nullable
              as List<SkippedMember>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchScheduleContributionResponseImpl
    implements _BatchScheduleContributionResponse {
  const _$BatchScheduleContributionResponseImpl(
      {required final List<ContributionResponse> created,
      required final List<SkippedMember> skipped})
      : _created = created,
        _skipped = skipped;

  factory _$BatchScheduleContributionResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BatchScheduleContributionResponseImplFromJson(json);

  final List<ContributionResponse> _created;
  @override
  List<ContributionResponse> get created {
    if (_created is EqualUnmodifiableListView) return _created;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_created);
  }

  final List<SkippedMember> _skipped;
  @override
  List<SkippedMember> get skipped {
    if (_skipped is EqualUnmodifiableListView) return _skipped;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skipped);
  }

  @override
  String toString() {
    return 'BatchScheduleContributionResponse(created: $created, skipped: $skipped)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchScheduleContributionResponseImpl &&
            const DeepCollectionEquality().equals(other._created, _created) &&
            const DeepCollectionEquality().equals(other._skipped, _skipped));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_created),
      const DeepCollectionEquality().hash(_skipped));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchScheduleContributionResponseImplCopyWith<
          _$BatchScheduleContributionResponseImpl>
      get copyWith => __$$BatchScheduleContributionResponseImplCopyWithImpl<
          _$BatchScheduleContributionResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchScheduleContributionResponseImplToJson(
      this,
    );
  }
}

abstract class _BatchScheduleContributionResponse
    implements BatchScheduleContributionResponse {
  const factory _BatchScheduleContributionResponse(
          {required final List<ContributionResponse> created,
          required final List<SkippedMember> skipped}) =
      _$BatchScheduleContributionResponseImpl;

  factory _BatchScheduleContributionResponse.fromJson(
          Map<String, dynamic> json) =
      _$BatchScheduleContributionResponseImpl.fromJson;

  @override
  List<ContributionResponse> get created;
  @override
  List<SkippedMember> get skipped;
  @override
  @JsonKey(ignore: true)
  _$$BatchScheduleContributionResponseImplCopyWith<
          _$BatchScheduleContributionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SkippedMember _$SkippedMemberFromJson(Map<String, dynamic> json) {
  return _SkippedMember.fromJson(json);
}

/// @nodoc
mixin _$SkippedMember {
  String get memberUserId => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SkippedMemberCopyWith<SkippedMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkippedMemberCopyWith<$Res> {
  factory $SkippedMemberCopyWith(
          SkippedMember value, $Res Function(SkippedMember) then) =
      _$SkippedMemberCopyWithImpl<$Res, SkippedMember>;
  @useResult
  $Res call({String memberUserId, String reason});
}

/// @nodoc
class _$SkippedMemberCopyWithImpl<$Res, $Val extends SkippedMember>
    implements $SkippedMemberCopyWith<$Res> {
  _$SkippedMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberUserId = null,
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      memberUserId: null == memberUserId
          ? _value.memberUserId
          : memberUserId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkippedMemberImplCopyWith<$Res>
    implements $SkippedMemberCopyWith<$Res> {
  factory _$$SkippedMemberImplCopyWith(
          _$SkippedMemberImpl value, $Res Function(_$SkippedMemberImpl) then) =
      __$$SkippedMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String memberUserId, String reason});
}

/// @nodoc
class __$$SkippedMemberImplCopyWithImpl<$Res>
    extends _$SkippedMemberCopyWithImpl<$Res, _$SkippedMemberImpl>
    implements _$$SkippedMemberImplCopyWith<$Res> {
  __$$SkippedMemberImplCopyWithImpl(
      _$SkippedMemberImpl _value, $Res Function(_$SkippedMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberUserId = null,
    Object? reason = null,
  }) {
    return _then(_$SkippedMemberImpl(
      memberUserId: null == memberUserId
          ? _value.memberUserId
          : memberUserId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkippedMemberImpl implements _SkippedMember {
  const _$SkippedMemberImpl({required this.memberUserId, required this.reason});

  factory _$SkippedMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkippedMemberImplFromJson(json);

  @override
  final String memberUserId;
  @override
  final String reason;

  @override
  String toString() {
    return 'SkippedMember(memberUserId: $memberUserId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkippedMemberImpl &&
            (identical(other.memberUserId, memberUserId) ||
                other.memberUserId == memberUserId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, memberUserId, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkippedMemberImplCopyWith<_$SkippedMemberImpl> get copyWith =>
      __$$SkippedMemberImplCopyWithImpl<_$SkippedMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkippedMemberImplToJson(
      this,
    );
  }
}

abstract class _SkippedMember implements SkippedMember {
  const factory _SkippedMember(
      {required final String memberUserId,
      required final String reason}) = _$SkippedMemberImpl;

  factory _SkippedMember.fromJson(Map<String, dynamic> json) =
      _$SkippedMemberImpl.fromJson;

  @override
  String get memberUserId;
  @override
  String get reason;
  @override
  @JsonKey(ignore: true)
  _$$SkippedMemberImplCopyWith<_$SkippedMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContributionActionRequest _$ContributionActionRequestFromJson(
    Map<String, dynamic> json) {
  return _ContributionActionRequest.fromJson(json);
}

/// @nodoc
mixin _$ContributionActionRequest {
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContributionActionRequestCopyWith<ContributionActionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContributionActionRequestCopyWith<$Res> {
  factory $ContributionActionRequestCopyWith(ContributionActionRequest value,
          $Res Function(ContributionActionRequest) then) =
      _$ContributionActionRequestCopyWithImpl<$Res, ContributionActionRequest>;
  @useResult
  $Res call({String? note});
}

/// @nodoc
class _$ContributionActionRequestCopyWithImpl<$Res,
        $Val extends ContributionActionRequest>
    implements $ContributionActionRequestCopyWith<$Res> {
  _$ContributionActionRequestCopyWithImpl(this._value, this._then);

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
abstract class _$$ContributionActionRequestImplCopyWith<$Res>
    implements $ContributionActionRequestCopyWith<$Res> {
  factory _$$ContributionActionRequestImplCopyWith(
          _$ContributionActionRequestImpl value,
          $Res Function(_$ContributionActionRequestImpl) then) =
      __$$ContributionActionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? note});
}

/// @nodoc
class __$$ContributionActionRequestImplCopyWithImpl<$Res>
    extends _$ContributionActionRequestCopyWithImpl<$Res,
        _$ContributionActionRequestImpl>
    implements _$$ContributionActionRequestImplCopyWith<$Res> {
  __$$ContributionActionRequestImplCopyWithImpl(
      _$ContributionActionRequestImpl _value,
      $Res Function(_$ContributionActionRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? note = freezed,
  }) {
    return _then(_$ContributionActionRequestImpl(
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContributionActionRequestImpl implements _ContributionActionRequest {
  const _$ContributionActionRequestImpl({this.note});

  factory _$ContributionActionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContributionActionRequestImplFromJson(json);

  @override
  final String? note;

  @override
  String toString() {
    return 'ContributionActionRequest(note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionActionRequestImpl &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionActionRequestImplCopyWith<_$ContributionActionRequestImpl>
      get copyWith => __$$ContributionActionRequestImplCopyWithImpl<
          _$ContributionActionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContributionActionRequestImplToJson(
      this,
    );
  }
}

abstract class _ContributionActionRequest implements ContributionActionRequest {
  const factory _ContributionActionRequest({final String? note}) =
      _$ContributionActionRequestImpl;

  factory _ContributionActionRequest.fromJson(Map<String, dynamic> json) =
      _$ContributionActionRequestImpl.fromJson;

  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$ContributionActionRequestImplCopyWith<_$ContributionActionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContributionActivityLogEntry _$ContributionActivityLogEntryFromJson(
    Map<String, dynamic> json) {
  return _ContributionActivityLogEntry.fromJson(json);
}

/// @nodoc
mixin _$ContributionActivityLogEntry {
  String get id => throw _privateConstructorUsedError;
  String get actorUserId => throw _privateConstructorUsedError;
  String get actorFullName => throw _privateConstructorUsedError;
  String get actorRole => throw _privateConstructorUsedError; // MEMBER | ADMIN
  String get action => throw _privateConstructorUsedError;
  String? get previousStatus =>
      throw _privateConstructorUsedError; // null only for SCHEDULED
  String get newStatus => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContributionActivityLogEntryCopyWith<ContributionActivityLogEntry>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContributionActivityLogEntryCopyWith<$Res> {
  factory $ContributionActivityLogEntryCopyWith(
          ContributionActivityLogEntry value,
          $Res Function(ContributionActivityLogEntry) then) =
      _$ContributionActivityLogEntryCopyWithImpl<$Res,
          ContributionActivityLogEntry>;
  @useResult
  $Res call(
      {String id,
      String actorUserId,
      String actorFullName,
      String actorRole,
      String action,
      String? previousStatus,
      String newStatus,
      String? note,
      String createdAt});
}

/// @nodoc
class _$ContributionActivityLogEntryCopyWithImpl<$Res,
        $Val extends ContributionActivityLogEntry>
    implements $ContributionActivityLogEntryCopyWith<$Res> {
  _$ContributionActivityLogEntryCopyWithImpl(this._value, this._then);

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
    Object? actorRole = null,
    Object? action = null,
    Object? previousStatus = freezed,
    Object? newStatus = null,
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
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      previousStatus: freezed == previousStatus
          ? _value.previousStatus
          : previousStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ContributionActivityLogEntryImplCopyWith<$Res>
    implements $ContributionActivityLogEntryCopyWith<$Res> {
  factory _$$ContributionActivityLogEntryImplCopyWith(
          _$ContributionActivityLogEntryImpl value,
          $Res Function(_$ContributionActivityLogEntryImpl) then) =
      __$$ContributionActivityLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String actorUserId,
      String actorFullName,
      String actorRole,
      String action,
      String? previousStatus,
      String newStatus,
      String? note,
      String createdAt});
}

/// @nodoc
class __$$ContributionActivityLogEntryImplCopyWithImpl<$Res>
    extends _$ContributionActivityLogEntryCopyWithImpl<$Res,
        _$ContributionActivityLogEntryImpl>
    implements _$$ContributionActivityLogEntryImplCopyWith<$Res> {
  __$$ContributionActivityLogEntryImplCopyWithImpl(
      _$ContributionActivityLogEntryImpl _value,
      $Res Function(_$ContributionActivityLogEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorUserId = null,
    Object? actorFullName = null,
    Object? actorRole = null,
    Object? action = null,
    Object? previousStatus = freezed,
    Object? newStatus = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ContributionActivityLogEntryImpl(
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
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      previousStatus: freezed == previousStatus
          ? _value.previousStatus
          : previousStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
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
class _$ContributionActivityLogEntryImpl
    implements _ContributionActivityLogEntry {
  const _$ContributionActivityLogEntryImpl(
      {required this.id,
      required this.actorUserId,
      required this.actorFullName,
      required this.actorRole,
      required this.action,
      this.previousStatus,
      required this.newStatus,
      this.note,
      required this.createdAt});

  factory _$ContributionActivityLogEntryImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ContributionActivityLogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String actorUserId;
  @override
  final String actorFullName;
  @override
  final String actorRole;
// MEMBER | ADMIN
  @override
  final String action;
  @override
  final String? previousStatus;
// null only for SCHEDULED
  @override
  final String newStatus;
  @override
  final String? note;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'ContributionActivityLogEntry(id: $id, actorUserId: $actorUserId, actorFullName: $actorFullName, actorRole: $actorRole, action: $action, previousStatus: $previousStatus, newStatus: $newStatus, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionActivityLogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actorUserId, actorUserId) ||
                other.actorUserId == actorUserId) &&
            (identical(other.actorFullName, actorFullName) ||
                other.actorFullName == actorFullName) &&
            (identical(other.actorRole, actorRole) ||
                other.actorRole == actorRole) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.previousStatus, previousStatus) ||
                other.previousStatus == previousStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, actorUserId, actorFullName,
      actorRole, action, previousStatus, newStatus, note, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionActivityLogEntryImplCopyWith<
          _$ContributionActivityLogEntryImpl>
      get copyWith => __$$ContributionActivityLogEntryImplCopyWithImpl<
          _$ContributionActivityLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContributionActivityLogEntryImplToJson(
      this,
    );
  }
}

abstract class _ContributionActivityLogEntry
    implements ContributionActivityLogEntry {
  const factory _ContributionActivityLogEntry(
      {required final String id,
      required final String actorUserId,
      required final String actorFullName,
      required final String actorRole,
      required final String action,
      final String? previousStatus,
      required final String newStatus,
      final String? note,
      required final String createdAt}) = _$ContributionActivityLogEntryImpl;

  factory _ContributionActivityLogEntry.fromJson(Map<String, dynamic> json) =
      _$ContributionActivityLogEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get actorUserId;
  @override
  String get actorFullName;
  @override
  String get actorRole;
  @override // MEMBER | ADMIN
  String get action;
  @override
  String? get previousStatus;
  @override // null only for SCHEDULED
  String get newStatus;
  @override
  String? get note;
  @override
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ContributionActivityLogEntryImplCopyWith<
          _$ContributionActivityLogEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
