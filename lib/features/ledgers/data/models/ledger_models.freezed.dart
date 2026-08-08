// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LedgerResponse _$LedgerResponseFromJson(Map<String, dynamic> json) {
  return _LedgerResponse.fromJson(json);
}

/// @nodoc
mixin _$LedgerResponse {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get inviteCode => throw _privateConstructorUsedError;
  String get contributionFrequency =>
      throw _privateConstructorUsedError; // DAILY | WEEKLY | MONTHLY
  double get contributionAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError; // ACTIVE | SUSPENDED
  String get callerRole =>
      throw _privateConstructorUsedError; // ADMIN | PRESIDENT | ASSISTANT | MEMBER
  /// The CALLER's own membership status on this ledger — NOT the
  /// ledger's own status (see `status` above for that). Added when
  /// joining stopped being instant: a join now returns PENDING until
  /// the ledger's Admin approves it. Every other endpoint that returns
  /// a LedgerResponse (create/get/update/getMyLedgers) only ever does
  /// so for an ACTIVE caller server-side, so this is always 'ACTIVE'
  /// there — only the join response can meaningfully be 'PENDING'.
  String get membershipStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LedgerResponseCopyWith<LedgerResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerResponseCopyWith<$Res> {
  factory $LedgerResponseCopyWith(
          LedgerResponse value, $Res Function(LedgerResponse) then) =
      _$LedgerResponseCopyWithImpl<$Res, LedgerResponse>;
  @useResult
  $Res call(
      {String id,
      String name,
      String inviteCode,
      String contributionFrequency,
      double contributionAmount,
      String status,
      String callerRole,
      String membershipStatus});
}

/// @nodoc
class _$LedgerResponseCopyWithImpl<$Res, $Val extends LedgerResponse>
    implements $LedgerResponseCopyWith<$Res> {
  _$LedgerResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
    Object? status = null,
    Object? callerRole = null,
    Object? membershipStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      callerRole: null == callerRole
          ? _value.callerRole
          : callerRole // ignore: cast_nullable_to_non_nullable
              as String,
      membershipStatus: null == membershipStatus
          ? _value.membershipStatus
          : membershipStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerResponseImplCopyWith<$Res>
    implements $LedgerResponseCopyWith<$Res> {
  factory _$$LedgerResponseImplCopyWith(_$LedgerResponseImpl value,
          $Res Function(_$LedgerResponseImpl) then) =
      __$$LedgerResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String inviteCode,
      String contributionFrequency,
      double contributionAmount,
      String status,
      String callerRole,
      String membershipStatus});
}

/// @nodoc
class __$$LedgerResponseImplCopyWithImpl<$Res>
    extends _$LedgerResponseCopyWithImpl<$Res, _$LedgerResponseImpl>
    implements _$$LedgerResponseImplCopyWith<$Res> {
  __$$LedgerResponseImplCopyWithImpl(
      _$LedgerResponseImpl _value, $Res Function(_$LedgerResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
    Object? status = null,
    Object? callerRole = null,
    Object? membershipStatus = null,
  }) {
    return _then(_$LedgerResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      callerRole: null == callerRole
          ? _value.callerRole
          : callerRole // ignore: cast_nullable_to_non_nullable
              as String,
      membershipStatus: null == membershipStatus
          ? _value.membershipStatus
          : membershipStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerResponseImpl implements _LedgerResponse {
  const _$LedgerResponseImpl(
      {required this.id,
      required this.name,
      required this.inviteCode,
      required this.contributionFrequency,
      required this.contributionAmount,
      required this.status,
      required this.callerRole,
      required this.membershipStatus});

  factory _$LedgerResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String inviteCode;
  @override
  final String contributionFrequency;
// DAILY | WEEKLY | MONTHLY
  @override
  final double contributionAmount;
  @override
  final String status;
// ACTIVE | SUSPENDED
  @override
  final String callerRole;
// ADMIN | PRESIDENT | ASSISTANT | MEMBER
  /// The CALLER's own membership status on this ledger — NOT the
  /// ledger's own status (see `status` above for that). Added when
  /// joining stopped being instant: a join now returns PENDING until
  /// the ledger's Admin approves it. Every other endpoint that returns
  /// a LedgerResponse (create/get/update/getMyLedgers) only ever does
  /// so for an ACTIVE caller server-side, so this is always 'ACTIVE'
  /// there — only the join response can meaningfully be 'PENDING'.
  @override
  final String membershipStatus;

  @override
  String toString() {
    return 'LedgerResponse(id: $id, name: $name, inviteCode: $inviteCode, contributionFrequency: $contributionFrequency, contributionAmount: $contributionAmount, status: $status, callerRole: $callerRole, membershipStatus: $membershipStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.contributionFrequency, contributionFrequency) ||
                other.contributionFrequency == contributionFrequency) &&
            (identical(other.contributionAmount, contributionAmount) ||
                other.contributionAmount == contributionAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.callerRole, callerRole) ||
                other.callerRole == callerRole) &&
            (identical(other.membershipStatus, membershipStatus) ||
                other.membershipStatus == membershipStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      inviteCode,
      contributionFrequency,
      contributionAmount,
      status,
      callerRole,
      membershipStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerResponseImplCopyWith<_$LedgerResponseImpl> get copyWith =>
      __$$LedgerResponseImplCopyWithImpl<_$LedgerResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerResponseImplToJson(
      this,
    );
  }
}

abstract class _LedgerResponse implements LedgerResponse {
  const factory _LedgerResponse(
      {required final String id,
      required final String name,
      required final String inviteCode,
      required final String contributionFrequency,
      required final double contributionAmount,
      required final String status,
      required final String callerRole,
      required final String membershipStatus}) = _$LedgerResponseImpl;

  factory _LedgerResponse.fromJson(Map<String, dynamic> json) =
      _$LedgerResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get inviteCode;
  @override
  String get contributionFrequency;
  @override // DAILY | WEEKLY | MONTHLY
  double get contributionAmount;
  @override
  String get status;
  @override // ACTIVE | SUSPENDED
  String get callerRole;
  @override // ADMIN | PRESIDENT | ASSISTANT | MEMBER
  /// The CALLER's own membership status on this ledger — NOT the
  /// ledger's own status (see `status` above for that). Added when
  /// joining stopped being instant: a join now returns PENDING until
  /// the ledger's Admin approves it. Every other endpoint that returns
  /// a LedgerResponse (create/get/update/getMyLedgers) only ever does
  /// so for an ACTIVE caller server-side, so this is always 'ACTIVE'
  /// there — only the join response can meaningfully be 'PENDING'.
  String get membershipStatus;
  @override
  @JsonKey(ignore: true)
  _$$LedgerResponseImplCopyWith<_$LedgerResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateLedgerRequest _$CreateLedgerRequestFromJson(Map<String, dynamic> json) {
  return _CreateLedgerRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateLedgerRequest {
  String get name => throw _privateConstructorUsedError;
  String get contributionFrequency => throw _privateConstructorUsedError;
  double get contributionAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateLedgerRequestCopyWith<CreateLedgerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateLedgerRequestCopyWith<$Res> {
  factory $CreateLedgerRequestCopyWith(
          CreateLedgerRequest value, $Res Function(CreateLedgerRequest) then) =
      _$CreateLedgerRequestCopyWithImpl<$Res, CreateLedgerRequest>;
  @useResult
  $Res call(
      {String name, String contributionFrequency, double contributionAmount});
}

/// @nodoc
class _$CreateLedgerRequestCopyWithImpl<$Res, $Val extends CreateLedgerRequest>
    implements $CreateLedgerRequestCopyWith<$Res> {
  _$CreateLedgerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateLedgerRequestImplCopyWith<$Res>
    implements $CreateLedgerRequestCopyWith<$Res> {
  factory _$$CreateLedgerRequestImplCopyWith(_$CreateLedgerRequestImpl value,
          $Res Function(_$CreateLedgerRequestImpl) then) =
      __$$CreateLedgerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String contributionFrequency, double contributionAmount});
}

/// @nodoc
class __$$CreateLedgerRequestImplCopyWithImpl<$Res>
    extends _$CreateLedgerRequestCopyWithImpl<$Res, _$CreateLedgerRequestImpl>
    implements _$$CreateLedgerRequestImplCopyWith<$Res> {
  __$$CreateLedgerRequestImplCopyWithImpl(_$CreateLedgerRequestImpl _value,
      $Res Function(_$CreateLedgerRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
  }) {
    return _then(_$CreateLedgerRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateLedgerRequestImpl implements _CreateLedgerRequest {
  const _$CreateLedgerRequestImpl(
      {required this.name,
      required this.contributionFrequency,
      required this.contributionAmount});

  factory _$CreateLedgerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateLedgerRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String contributionFrequency;
  @override
  final double contributionAmount;

  @override
  String toString() {
    return 'CreateLedgerRequest(name: $name, contributionFrequency: $contributionFrequency, contributionAmount: $contributionAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateLedgerRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contributionFrequency, contributionFrequency) ||
                other.contributionFrequency == contributionFrequency) &&
            (identical(other.contributionAmount, contributionAmount) ||
                other.contributionAmount == contributionAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, contributionFrequency, contributionAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateLedgerRequestImplCopyWith<_$CreateLedgerRequestImpl> get copyWith =>
      __$$CreateLedgerRequestImplCopyWithImpl<_$CreateLedgerRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateLedgerRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateLedgerRequest implements CreateLedgerRequest {
  const factory _CreateLedgerRequest(
      {required final String name,
      required final String contributionFrequency,
      required final double contributionAmount}) = _$CreateLedgerRequestImpl;

  factory _CreateLedgerRequest.fromJson(Map<String, dynamic> json) =
      _$CreateLedgerRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get contributionFrequency;
  @override
  double get contributionAmount;
  @override
  @JsonKey(ignore: true)
  _$$CreateLedgerRequestImplCopyWith<_$CreateLedgerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateLedgerRequest _$UpdateLedgerRequestFromJson(Map<String, dynamic> json) {
  return _UpdateLedgerRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateLedgerRequest {
  String get name => throw _privateConstructorUsedError;
  String get contributionFrequency => throw _privateConstructorUsedError;
  double get contributionAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateLedgerRequestCopyWith<UpdateLedgerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateLedgerRequestCopyWith<$Res> {
  factory $UpdateLedgerRequestCopyWith(
          UpdateLedgerRequest value, $Res Function(UpdateLedgerRequest) then) =
      _$UpdateLedgerRequestCopyWithImpl<$Res, UpdateLedgerRequest>;
  @useResult
  $Res call(
      {String name, String contributionFrequency, double contributionAmount});
}

/// @nodoc
class _$UpdateLedgerRequestCopyWithImpl<$Res, $Val extends UpdateLedgerRequest>
    implements $UpdateLedgerRequestCopyWith<$Res> {
  _$UpdateLedgerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateLedgerRequestImplCopyWith<$Res>
    implements $UpdateLedgerRequestCopyWith<$Res> {
  factory _$$UpdateLedgerRequestImplCopyWith(_$UpdateLedgerRequestImpl value,
          $Res Function(_$UpdateLedgerRequestImpl) then) =
      __$$UpdateLedgerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String contributionFrequency, double contributionAmount});
}

/// @nodoc
class __$$UpdateLedgerRequestImplCopyWithImpl<$Res>
    extends _$UpdateLedgerRequestCopyWithImpl<$Res, _$UpdateLedgerRequestImpl>
    implements _$$UpdateLedgerRequestImplCopyWith<$Res> {
  __$$UpdateLedgerRequestImplCopyWithImpl(_$UpdateLedgerRequestImpl _value,
      $Res Function(_$UpdateLedgerRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
  }) {
    return _then(_$UpdateLedgerRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateLedgerRequestImpl implements _UpdateLedgerRequest {
  const _$UpdateLedgerRequestImpl(
      {required this.name,
      required this.contributionFrequency,
      required this.contributionAmount});

  factory _$UpdateLedgerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateLedgerRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String contributionFrequency;
  @override
  final double contributionAmount;

  @override
  String toString() {
    return 'UpdateLedgerRequest(name: $name, contributionFrequency: $contributionFrequency, contributionAmount: $contributionAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateLedgerRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contributionFrequency, contributionFrequency) ||
                other.contributionFrequency == contributionFrequency) &&
            (identical(other.contributionAmount, contributionAmount) ||
                other.contributionAmount == contributionAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, contributionFrequency, contributionAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateLedgerRequestImplCopyWith<_$UpdateLedgerRequestImpl> get copyWith =>
      __$$UpdateLedgerRequestImplCopyWithImpl<_$UpdateLedgerRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateLedgerRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateLedgerRequest implements UpdateLedgerRequest {
  const factory _UpdateLedgerRequest(
      {required final String name,
      required final String contributionFrequency,
      required final double contributionAmount}) = _$UpdateLedgerRequestImpl;

  factory _UpdateLedgerRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateLedgerRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get contributionFrequency;
  @override
  double get contributionAmount;
  @override
  @JsonKey(ignore: true)
  _$$UpdateLedgerRequestImplCopyWith<_$UpdateLedgerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JoinLedgerRequest _$JoinLedgerRequestFromJson(Map<String, dynamic> json) {
  return _JoinLedgerRequest.fromJson(json);
}

/// @nodoc
mixin _$JoinLedgerRequest {
  String get inviteCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JoinLedgerRequestCopyWith<JoinLedgerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinLedgerRequestCopyWith<$Res> {
  factory $JoinLedgerRequestCopyWith(
          JoinLedgerRequest value, $Res Function(JoinLedgerRequest) then) =
      _$JoinLedgerRequestCopyWithImpl<$Res, JoinLedgerRequest>;
  @useResult
  $Res call({String inviteCode});
}

/// @nodoc
class _$JoinLedgerRequestCopyWithImpl<$Res, $Val extends JoinLedgerRequest>
    implements $JoinLedgerRequestCopyWith<$Res> {
  _$JoinLedgerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inviteCode = null,
  }) {
    return _then(_value.copyWith(
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JoinLedgerRequestImplCopyWith<$Res>
    implements $JoinLedgerRequestCopyWith<$Res> {
  factory _$$JoinLedgerRequestImplCopyWith(_$JoinLedgerRequestImpl value,
          $Res Function(_$JoinLedgerRequestImpl) then) =
      __$$JoinLedgerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String inviteCode});
}

/// @nodoc
class __$$JoinLedgerRequestImplCopyWithImpl<$Res>
    extends _$JoinLedgerRequestCopyWithImpl<$Res, _$JoinLedgerRequestImpl>
    implements _$$JoinLedgerRequestImplCopyWith<$Res> {
  __$$JoinLedgerRequestImplCopyWithImpl(_$JoinLedgerRequestImpl _value,
      $Res Function(_$JoinLedgerRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inviteCode = null,
  }) {
    return _then(_$JoinLedgerRequestImpl(
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinLedgerRequestImpl implements _JoinLedgerRequest {
  const _$JoinLedgerRequestImpl({required this.inviteCode});

  factory _$JoinLedgerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinLedgerRequestImplFromJson(json);

  @override
  final String inviteCode;

  @override
  String toString() {
    return 'JoinLedgerRequest(inviteCode: $inviteCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinLedgerRequestImpl &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, inviteCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinLedgerRequestImplCopyWith<_$JoinLedgerRequestImpl> get copyWith =>
      __$$JoinLedgerRequestImplCopyWithImpl<_$JoinLedgerRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinLedgerRequestImplToJson(
      this,
    );
  }
}

abstract class _JoinLedgerRequest implements JoinLedgerRequest {
  const factory _JoinLedgerRequest({required final String inviteCode}) =
      _$JoinLedgerRequestImpl;

  factory _JoinLedgerRequest.fromJson(Map<String, dynamic> json) =
      _$JoinLedgerRequestImpl.fromJson;

  @override
  String get inviteCode;
  @override
  @JsonKey(ignore: true)
  _$$JoinLedgerRequestImplCopyWith<_$JoinLedgerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LedgerMemberResponse _$LedgerMemberResponseFromJson(Map<String, dynamic> json) {
  return _LedgerMemberResponse.fromJson(json);
}

/// @nodoc
mixin _$LedgerMemberResponse {
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // ADMIN | PRESIDENT | ASSISTANT | MEMBER
  /// ACTIVE — approved, full access.
  /// PENDING — requested to join, awaiting Admin approval/rejection.
  /// INVALIDATED — declined by the Admin, OR auto-invalidated because
  ///   this user (on a free-tier account) requested to join a
  ///   different ledger while this request was still pending.
  /// REMOVED — was ACTIVE, then removed by the Admin.
  String get status => throw _privateConstructorUsedError;
  String get joinedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LedgerMemberResponseCopyWith<LedgerMemberResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerMemberResponseCopyWith<$Res> {
  factory $LedgerMemberResponseCopyWith(LedgerMemberResponse value,
          $Res Function(LedgerMemberResponse) then) =
      _$LedgerMemberResponseCopyWithImpl<$Res, LedgerMemberResponse>;
  @useResult
  $Res call(
      {String userId,
      String fullName,
      String role,
      String status,
      String joinedAt});
}

/// @nodoc
class _$LedgerMemberResponseCopyWithImpl<$Res,
        $Val extends LedgerMemberResponse>
    implements $LedgerMemberResponseCopyWith<$Res> {
  _$LedgerMemberResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? role = null,
    Object? status = null,
    Object? joinedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerMemberResponseImplCopyWith<$Res>
    implements $LedgerMemberResponseCopyWith<$Res> {
  factory _$$LedgerMemberResponseImplCopyWith(_$LedgerMemberResponseImpl value,
          $Res Function(_$LedgerMemberResponseImpl) then) =
      __$$LedgerMemberResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String fullName,
      String role,
      String status,
      String joinedAt});
}

/// @nodoc
class __$$LedgerMemberResponseImplCopyWithImpl<$Res>
    extends _$LedgerMemberResponseCopyWithImpl<$Res, _$LedgerMemberResponseImpl>
    implements _$$LedgerMemberResponseImplCopyWith<$Res> {
  __$$LedgerMemberResponseImplCopyWithImpl(_$LedgerMemberResponseImpl _value,
      $Res Function(_$LedgerMemberResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? role = null,
    Object? status = null,
    Object? joinedAt = null,
  }) {
    return _then(_$LedgerMemberResponseImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerMemberResponseImpl implements _LedgerMemberResponse {
  const _$LedgerMemberResponseImpl(
      {required this.userId,
      required this.fullName,
      required this.role,
      required this.status,
      required this.joinedAt});

  factory _$LedgerMemberResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerMemberResponseImplFromJson(json);

  @override
  final String userId;
  @override
  final String fullName;
  @override
  final String role;
// ADMIN | PRESIDENT | ASSISTANT | MEMBER
  /// ACTIVE — approved, full access.
  /// PENDING — requested to join, awaiting Admin approval/rejection.
  /// INVALIDATED — declined by the Admin, OR auto-invalidated because
  ///   this user (on a free-tier account) requested to join a
  ///   different ledger while this request was still pending.
  /// REMOVED — was ACTIVE, then removed by the Admin.
  @override
  final String status;
  @override
  final String joinedAt;

  @override
  String toString() {
    return 'LedgerMemberResponse(userId: $userId, fullName: $fullName, role: $role, status: $status, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerMemberResponseImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, fullName, role, status, joinedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerMemberResponseImplCopyWith<_$LedgerMemberResponseImpl>
      get copyWith =>
          __$$LedgerMemberResponseImplCopyWithImpl<_$LedgerMemberResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerMemberResponseImplToJson(
      this,
    );
  }
}

abstract class _LedgerMemberResponse implements LedgerMemberResponse {
  const factory _LedgerMemberResponse(
      {required final String userId,
      required final String fullName,
      required final String role,
      required final String status,
      required final String joinedAt}) = _$LedgerMemberResponseImpl;

  factory _LedgerMemberResponse.fromJson(Map<String, dynamic> json) =
      _$LedgerMemberResponseImpl.fromJson;

  @override
  String get userId;
  @override
  String get fullName;
  @override
  String get role;
  @override // ADMIN | PRESIDENT | ASSISTANT | MEMBER
  /// ACTIVE — approved, full access.
  /// PENDING — requested to join, awaiting Admin approval/rejection.
  /// INVALIDATED — declined by the Admin, OR auto-invalidated because
  ///   this user (on a free-tier account) requested to join a
  ///   different ledger while this request was still pending.
  /// REMOVED — was ACTIVE, then removed by the Admin.
  String get status;
  @override
  String get joinedAt;
  @override
  @JsonKey(ignore: true)
  _$$LedgerMemberResponseImplCopyWith<_$LedgerMemberResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LedgerDirectoryEntryResponse _$LedgerDirectoryEntryResponseFromJson(
    Map<String, dynamic> json) {
  return _LedgerDirectoryEntryResponse.fromJson(json);
}

/// @nodoc
mixin _$LedgerDirectoryEntryResponse {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get contributionFrequency =>
      throw _privateConstructorUsedError; // DAILY | WEEKLY | MONTHLY
  double get contributionAmount => throw _privateConstructorUsedError;

  /// 0.0 if never rated — always treat that as "no rating yet," never
  /// as a genuine zero-star average.
  double get averageRating => throw _privateConstructorUsedError;
  int get ratingCount => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LedgerDirectoryEntryResponseCopyWith<LedgerDirectoryEntryResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerDirectoryEntryResponseCopyWith<$Res> {
  factory $LedgerDirectoryEntryResponseCopyWith(
          LedgerDirectoryEntryResponse value,
          $Res Function(LedgerDirectoryEntryResponse) then) =
      _$LedgerDirectoryEntryResponseCopyWithImpl<$Res,
          LedgerDirectoryEntryResponse>;
  @useResult
  $Res call(
      {String id,
      String name,
      String contributionFrequency,
      double contributionAmount,
      double averageRating,
      int ratingCount,
      String createdAt});
}

/// @nodoc
class _$LedgerDirectoryEntryResponseCopyWithImpl<$Res,
        $Val extends LedgerDirectoryEntryResponse>
    implements $LedgerDirectoryEntryResponseCopyWith<$Res> {
  _$LedgerDirectoryEntryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
    Object? averageRating = null,
    Object? ratingCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerDirectoryEntryResponseImplCopyWith<$Res>
    implements $LedgerDirectoryEntryResponseCopyWith<$Res> {
  factory _$$LedgerDirectoryEntryResponseImplCopyWith(
          _$LedgerDirectoryEntryResponseImpl value,
          $Res Function(_$LedgerDirectoryEntryResponseImpl) then) =
      __$$LedgerDirectoryEntryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String contributionFrequency,
      double contributionAmount,
      double averageRating,
      int ratingCount,
      String createdAt});
}

/// @nodoc
class __$$LedgerDirectoryEntryResponseImplCopyWithImpl<$Res>
    extends _$LedgerDirectoryEntryResponseCopyWithImpl<$Res,
        _$LedgerDirectoryEntryResponseImpl>
    implements _$$LedgerDirectoryEntryResponseImplCopyWith<$Res> {
  __$$LedgerDirectoryEntryResponseImplCopyWithImpl(
      _$LedgerDirectoryEntryResponseImpl _value,
      $Res Function(_$LedgerDirectoryEntryResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contributionFrequency = null,
    Object? contributionAmount = null,
    Object? averageRating = null,
    Object? ratingCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$LedgerDirectoryEntryResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contributionFrequency: null == contributionFrequency
          ? _value.contributionFrequency
          : contributionFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      contributionAmount: null == contributionAmount
          ? _value.contributionAmount
          : contributionAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerDirectoryEntryResponseImpl
    implements _LedgerDirectoryEntryResponse {
  const _$LedgerDirectoryEntryResponseImpl(
      {required this.id,
      required this.name,
      required this.contributionFrequency,
      required this.contributionAmount,
      required this.averageRating,
      required this.ratingCount,
      required this.createdAt});

  factory _$LedgerDirectoryEntryResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$LedgerDirectoryEntryResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String contributionFrequency;
// DAILY | WEEKLY | MONTHLY
  @override
  final double contributionAmount;

  /// 0.0 if never rated — always treat that as "no rating yet," never
  /// as a genuine zero-star average.
  @override
  final double averageRating;
  @override
  final int ratingCount;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'LedgerDirectoryEntryResponse(id: $id, name: $name, contributionFrequency: $contributionFrequency, contributionAmount: $contributionAmount, averageRating: $averageRating, ratingCount: $ratingCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerDirectoryEntryResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contributionFrequency, contributionFrequency) ||
                other.contributionFrequency == contributionFrequency) &&
            (identical(other.contributionAmount, contributionAmount) ||
                other.contributionAmount == contributionAmount) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, contributionFrequency,
      contributionAmount, averageRating, ratingCount, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerDirectoryEntryResponseImplCopyWith<
          _$LedgerDirectoryEntryResponseImpl>
      get copyWith => __$$LedgerDirectoryEntryResponseImplCopyWithImpl<
          _$LedgerDirectoryEntryResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerDirectoryEntryResponseImplToJson(
      this,
    );
  }
}

abstract class _LedgerDirectoryEntryResponse
    implements LedgerDirectoryEntryResponse {
  const factory _LedgerDirectoryEntryResponse(
      {required final String id,
      required final String name,
      required final String contributionFrequency,
      required final double contributionAmount,
      required final double averageRating,
      required final int ratingCount,
      required final String createdAt}) = _$LedgerDirectoryEntryResponseImpl;

  factory _LedgerDirectoryEntryResponse.fromJson(Map<String, dynamic> json) =
      _$LedgerDirectoryEntryResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get contributionFrequency;
  @override // DAILY | WEEKLY | MONTHLY
  double get contributionAmount;
  @override

  /// 0.0 if never rated — always treat that as "no rating yet," never
  /// as a genuine zero-star average.
  double get averageRating;
  @override
  int get ratingCount;
  @override
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$LedgerDirectoryEntryResponseImplCopyWith<
          _$LedgerDirectoryEntryResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RateLedgerRequest _$RateLedgerRequestFromJson(Map<String, dynamic> json) {
  return _RateLedgerRequest.fromJson(json);
}

/// @nodoc
mixin _$RateLedgerRequest {
  int get stars => throw _privateConstructorUsedError;

  /// Optional — null/omitted means "just a star rating, no comment."
  String? get reviewText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RateLedgerRequestCopyWith<RateLedgerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RateLedgerRequestCopyWith<$Res> {
  factory $RateLedgerRequestCopyWith(
          RateLedgerRequest value, $Res Function(RateLedgerRequest) then) =
      _$RateLedgerRequestCopyWithImpl<$Res, RateLedgerRequest>;
  @useResult
  $Res call({int stars, String? reviewText});
}

/// @nodoc
class _$RateLedgerRequestCopyWithImpl<$Res, $Val extends RateLedgerRequest>
    implements $RateLedgerRequestCopyWith<$Res> {
  _$RateLedgerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stars = null,
    Object? reviewText = freezed,
  }) {
    return _then(_value.copyWith(
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RateLedgerRequestImplCopyWith<$Res>
    implements $RateLedgerRequestCopyWith<$Res> {
  factory _$$RateLedgerRequestImplCopyWith(_$RateLedgerRequestImpl value,
          $Res Function(_$RateLedgerRequestImpl) then) =
      __$$RateLedgerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int stars, String? reviewText});
}

/// @nodoc
class __$$RateLedgerRequestImplCopyWithImpl<$Res>
    extends _$RateLedgerRequestCopyWithImpl<$Res, _$RateLedgerRequestImpl>
    implements _$$RateLedgerRequestImplCopyWith<$Res> {
  __$$RateLedgerRequestImplCopyWithImpl(_$RateLedgerRequestImpl _value,
      $Res Function(_$RateLedgerRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stars = null,
    Object? reviewText = freezed,
  }) {
    return _then(_$RateLedgerRequestImpl(
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RateLedgerRequestImpl implements _RateLedgerRequest {
  const _$RateLedgerRequestImpl({required this.stars, this.reviewText});

  factory _$RateLedgerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RateLedgerRequestImplFromJson(json);

  @override
  final int stars;

  /// Optional — null/omitted means "just a star rating, no comment."
  @override
  final String? reviewText;

  @override
  String toString() {
    return 'RateLedgerRequest(stars: $stars, reviewText: $reviewText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RateLedgerRequestImpl &&
            (identical(other.stars, stars) || other.stars == stars) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, stars, reviewText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RateLedgerRequestImplCopyWith<_$RateLedgerRequestImpl> get copyWith =>
      __$$RateLedgerRequestImplCopyWithImpl<_$RateLedgerRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RateLedgerRequestImplToJson(
      this,
    );
  }
}

abstract class _RateLedgerRequest implements RateLedgerRequest {
  const factory _RateLedgerRequest(
      {required final int stars,
      final String? reviewText}) = _$RateLedgerRequestImpl;

  factory _RateLedgerRequest.fromJson(Map<String, dynamic> json) =
      _$RateLedgerRequestImpl.fromJson;

  @override
  int get stars;
  @override

  /// Optional — null/omitted means "just a star rating, no comment."
  String? get reviewText;
  @override
  @JsonKey(ignore: true)
  _$$RateLedgerRequestImplCopyWith<_$RateLedgerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LedgerRatingResponse _$LedgerRatingResponseFromJson(Map<String, dynamic> json) {
  return _LedgerRatingResponse.fromJson(json);
}

/// @nodoc
mixin _$LedgerRatingResponse {
  String get ledgerId => throw _privateConstructorUsedError;
  int get stars => throw _privateConstructorUsedError;
  String? get reviewText => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LedgerRatingResponseCopyWith<LedgerRatingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerRatingResponseCopyWith<$Res> {
  factory $LedgerRatingResponseCopyWith(LedgerRatingResponse value,
          $Res Function(LedgerRatingResponse) then) =
      _$LedgerRatingResponseCopyWithImpl<$Res, LedgerRatingResponse>;
  @useResult
  $Res call({String ledgerId, int stars, String? reviewText, String updatedAt});
}

/// @nodoc
class _$LedgerRatingResponseCopyWithImpl<$Res,
        $Val extends LedgerRatingResponse>
    implements $LedgerRatingResponseCopyWith<$Res> {
  _$LedgerRatingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ledgerId = null,
    Object? stars = null,
    Object? reviewText = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      ledgerId: null == ledgerId
          ? _value.ledgerId
          : ledgerId // ignore: cast_nullable_to_non_nullable
              as String,
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerRatingResponseImplCopyWith<$Res>
    implements $LedgerRatingResponseCopyWith<$Res> {
  factory _$$LedgerRatingResponseImplCopyWith(_$LedgerRatingResponseImpl value,
          $Res Function(_$LedgerRatingResponseImpl) then) =
      __$$LedgerRatingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String ledgerId, int stars, String? reviewText, String updatedAt});
}

/// @nodoc
class __$$LedgerRatingResponseImplCopyWithImpl<$Res>
    extends _$LedgerRatingResponseCopyWithImpl<$Res, _$LedgerRatingResponseImpl>
    implements _$$LedgerRatingResponseImplCopyWith<$Res> {
  __$$LedgerRatingResponseImplCopyWithImpl(_$LedgerRatingResponseImpl _value,
      $Res Function(_$LedgerRatingResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ledgerId = null,
    Object? stars = null,
    Object? reviewText = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$LedgerRatingResponseImpl(
      ledgerId: null == ledgerId
          ? _value.ledgerId
          : ledgerId // ignore: cast_nullable_to_non_nullable
              as String,
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerRatingResponseImpl implements _LedgerRatingResponse {
  const _$LedgerRatingResponseImpl(
      {required this.ledgerId,
      required this.stars,
      this.reviewText,
      required this.updatedAt});

  factory _$LedgerRatingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerRatingResponseImplFromJson(json);

  @override
  final String ledgerId;
  @override
  final int stars;
  @override
  final String? reviewText;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'LedgerRatingResponse(ledgerId: $ledgerId, stars: $stars, reviewText: $reviewText, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerRatingResponseImpl &&
            (identical(other.ledgerId, ledgerId) ||
                other.ledgerId == ledgerId) &&
            (identical(other.stars, stars) || other.stars == stars) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, ledgerId, stars, reviewText, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerRatingResponseImplCopyWith<_$LedgerRatingResponseImpl>
      get copyWith =>
          __$$LedgerRatingResponseImplCopyWithImpl<_$LedgerRatingResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerRatingResponseImplToJson(
      this,
    );
  }
}

abstract class _LedgerRatingResponse implements LedgerRatingResponse {
  const factory _LedgerRatingResponse(
      {required final String ledgerId,
      required final int stars,
      final String? reviewText,
      required final String updatedAt}) = _$LedgerRatingResponseImpl;

  factory _LedgerRatingResponse.fromJson(Map<String, dynamic> json) =
      _$LedgerRatingResponseImpl.fromJson;

  @override
  String get ledgerId;
  @override
  int get stars;
  @override
  String? get reviewText;
  @override
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$LedgerRatingResponseImplCopyWith<_$LedgerRatingResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LedgerReviewResponse _$LedgerReviewResponseFromJson(Map<String, dynamic> json) {
  return _LedgerReviewResponse.fromJson(json);
}

/// @nodoc
mixin _$LedgerReviewResponse {
  String get userId => throw _privateConstructorUsedError;
  String get reviewerFullName => throw _privateConstructorUsedError;
  int get stars => throw _privateConstructorUsedError;
  String? get reviewText => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LedgerReviewResponseCopyWith<LedgerReviewResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerReviewResponseCopyWith<$Res> {
  factory $LedgerReviewResponseCopyWith(LedgerReviewResponse value,
          $Res Function(LedgerReviewResponse) then) =
      _$LedgerReviewResponseCopyWithImpl<$Res, LedgerReviewResponse>;
  @useResult
  $Res call(
      {String userId,
      String reviewerFullName,
      int stars,
      String? reviewText,
      String createdAt});
}

/// @nodoc
class _$LedgerReviewResponseCopyWithImpl<$Res,
        $Val extends LedgerReviewResponse>
    implements $LedgerReviewResponseCopyWith<$Res> {
  _$LedgerReviewResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? reviewerFullName = null,
    Object? stars = null,
    Object? reviewText = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerFullName: null == reviewerFullName
          ? _value.reviewerFullName
          : reviewerFullName // ignore: cast_nullable_to_non_nullable
              as String,
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerReviewResponseImplCopyWith<$Res>
    implements $LedgerReviewResponseCopyWith<$Res> {
  factory _$$LedgerReviewResponseImplCopyWith(_$LedgerReviewResponseImpl value,
          $Res Function(_$LedgerReviewResponseImpl) then) =
      __$$LedgerReviewResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String reviewerFullName,
      int stars,
      String? reviewText,
      String createdAt});
}

/// @nodoc
class __$$LedgerReviewResponseImplCopyWithImpl<$Res>
    extends _$LedgerReviewResponseCopyWithImpl<$Res, _$LedgerReviewResponseImpl>
    implements _$$LedgerReviewResponseImplCopyWith<$Res> {
  __$$LedgerReviewResponseImplCopyWithImpl(_$LedgerReviewResponseImpl _value,
      $Res Function(_$LedgerReviewResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? reviewerFullName = null,
    Object? stars = null,
    Object? reviewText = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$LedgerReviewResponseImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerFullName: null == reviewerFullName
          ? _value.reviewerFullName
          : reviewerFullName // ignore: cast_nullable_to_non_nullable
              as String,
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
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
class _$LedgerReviewResponseImpl implements _LedgerReviewResponse {
  const _$LedgerReviewResponseImpl(
      {required this.userId,
      required this.reviewerFullName,
      required this.stars,
      this.reviewText,
      required this.createdAt});

  factory _$LedgerReviewResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerReviewResponseImplFromJson(json);

  @override
  final String userId;
  @override
  final String reviewerFullName;
  @override
  final int stars;
  @override
  final String? reviewText;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'LedgerReviewResponse(userId: $userId, reviewerFullName: $reviewerFullName, stars: $stars, reviewText: $reviewText, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerReviewResponseImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reviewerFullName, reviewerFullName) ||
                other.reviewerFullName == reviewerFullName) &&
            (identical(other.stars, stars) || other.stars == stars) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, reviewerFullName, stars, reviewText, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerReviewResponseImplCopyWith<_$LedgerReviewResponseImpl>
      get copyWith =>
          __$$LedgerReviewResponseImplCopyWithImpl<_$LedgerReviewResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerReviewResponseImplToJson(
      this,
    );
  }
}

abstract class _LedgerReviewResponse implements LedgerReviewResponse {
  const factory _LedgerReviewResponse(
      {required final String userId,
      required final String reviewerFullName,
      required final int stars,
      final String? reviewText,
      required final String createdAt}) = _$LedgerReviewResponseImpl;

  factory _LedgerReviewResponse.fromJson(Map<String, dynamic> json) =
      _$LedgerReviewResponseImpl.fromJson;

  @override
  String get userId;
  @override
  String get reviewerFullName;
  @override
  int get stars;
  @override
  String? get reviewText;
  @override
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$LedgerReviewResponseImplCopyWith<_$LedgerReviewResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LedgerLimitResponse _$LedgerLimitResponseFromJson(Map<String, dynamic> json) {
  return _LedgerLimitResponse.fromJson(json);
}

/// @nodoc
mixin _$LedgerLimitResponse {
  int get maxActiveGroups => throw _privateConstructorUsedError;
  int get activeGroupCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LedgerLimitResponseCopyWith<LedgerLimitResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerLimitResponseCopyWith<$Res> {
  factory $LedgerLimitResponseCopyWith(
          LedgerLimitResponse value, $Res Function(LedgerLimitResponse) then) =
      _$LedgerLimitResponseCopyWithImpl<$Res, LedgerLimitResponse>;
  @useResult
  $Res call({int maxActiveGroups, int activeGroupCount});
}

/// @nodoc
class _$LedgerLimitResponseCopyWithImpl<$Res, $Val extends LedgerLimitResponse>
    implements $LedgerLimitResponseCopyWith<$Res> {
  _$LedgerLimitResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxActiveGroups = null,
    Object? activeGroupCount = null,
  }) {
    return _then(_value.copyWith(
      maxActiveGroups: null == maxActiveGroups
          ? _value.maxActiveGroups
          : maxActiveGroups // ignore: cast_nullable_to_non_nullable
              as int,
      activeGroupCount: null == activeGroupCount
          ? _value.activeGroupCount
          : activeGroupCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerLimitResponseImplCopyWith<$Res>
    implements $LedgerLimitResponseCopyWith<$Res> {
  factory _$$LedgerLimitResponseImplCopyWith(_$LedgerLimitResponseImpl value,
          $Res Function(_$LedgerLimitResponseImpl) then) =
      __$$LedgerLimitResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int maxActiveGroups, int activeGroupCount});
}

/// @nodoc
class __$$LedgerLimitResponseImplCopyWithImpl<$Res>
    extends _$LedgerLimitResponseCopyWithImpl<$Res, _$LedgerLimitResponseImpl>
    implements _$$LedgerLimitResponseImplCopyWith<$Res> {
  __$$LedgerLimitResponseImplCopyWithImpl(_$LedgerLimitResponseImpl _value,
      $Res Function(_$LedgerLimitResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxActiveGroups = null,
    Object? activeGroupCount = null,
  }) {
    return _then(_$LedgerLimitResponseImpl(
      maxActiveGroups: null == maxActiveGroups
          ? _value.maxActiveGroups
          : maxActiveGroups // ignore: cast_nullable_to_non_nullable
              as int,
      activeGroupCount: null == activeGroupCount
          ? _value.activeGroupCount
          : activeGroupCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerLimitResponseImpl extends _LedgerLimitResponse {
  const _$LedgerLimitResponseImpl(
      {required this.maxActiveGroups, required this.activeGroupCount})
      : super._();

  factory _$LedgerLimitResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerLimitResponseImplFromJson(json);

  @override
  final int maxActiveGroups;
  @override
  final int activeGroupCount;

  @override
  String toString() {
    return 'LedgerLimitResponse(maxActiveGroups: $maxActiveGroups, activeGroupCount: $activeGroupCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerLimitResponseImpl &&
            (identical(other.maxActiveGroups, maxActiveGroups) ||
                other.maxActiveGroups == maxActiveGroups) &&
            (identical(other.activeGroupCount, activeGroupCount) ||
                other.activeGroupCount == activeGroupCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, maxActiveGroups, activeGroupCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerLimitResponseImplCopyWith<_$LedgerLimitResponseImpl> get copyWith =>
      __$$LedgerLimitResponseImplCopyWithImpl<_$LedgerLimitResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerLimitResponseImplToJson(
      this,
    );
  }
}

abstract class _LedgerLimitResponse extends LedgerLimitResponse {
  const factory _LedgerLimitResponse(
      {required final int maxActiveGroups,
      required final int activeGroupCount}) = _$LedgerLimitResponseImpl;
  const _LedgerLimitResponse._() : super._();

  factory _LedgerLimitResponse.fromJson(Map<String, dynamic> json) =
      _$LedgerLimitResponseImpl.fromJson;

  @override
  int get maxActiveGroups;
  @override
  int get activeGroupCount;
  @override
  @JsonKey(ignore: true)
  _$$LedgerLimitResponseImplCopyWith<_$LedgerLimitResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
