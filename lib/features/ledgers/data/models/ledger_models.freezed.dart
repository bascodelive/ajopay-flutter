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
