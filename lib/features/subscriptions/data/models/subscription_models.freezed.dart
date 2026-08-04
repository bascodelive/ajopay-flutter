// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpgradeResponse _$UpgradeResponseFromJson(Map<String, dynamic> json) {
  return _UpgradeResponse.fromJson(json);
}

/// @nodoc
mixin _$UpgradeResponse {
  String get checkoutUrl => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpgradeResponseCopyWith<UpgradeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpgradeResponseCopyWith<$Res> {
  factory $UpgradeResponseCopyWith(
          UpgradeResponse value, $Res Function(UpgradeResponse) then) =
      _$UpgradeResponseCopyWithImpl<$Res, UpgradeResponse>;
  @useResult
  $Res call({String checkoutUrl, String reference});
}

/// @nodoc
class _$UpgradeResponseCopyWithImpl<$Res, $Val extends UpgradeResponse>
    implements $UpgradeResponseCopyWith<$Res> {
  _$UpgradeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkoutUrl = null,
    Object? reference = null,
  }) {
    return _then(_value.copyWith(
      checkoutUrl: null == checkoutUrl
          ? _value.checkoutUrl
          : checkoutUrl // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpgradeResponseImplCopyWith<$Res>
    implements $UpgradeResponseCopyWith<$Res> {
  factory _$$UpgradeResponseImplCopyWith(_$UpgradeResponseImpl value,
          $Res Function(_$UpgradeResponseImpl) then) =
      __$$UpgradeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String checkoutUrl, String reference});
}

/// @nodoc
class __$$UpgradeResponseImplCopyWithImpl<$Res>
    extends _$UpgradeResponseCopyWithImpl<$Res, _$UpgradeResponseImpl>
    implements _$$UpgradeResponseImplCopyWith<$Res> {
  __$$UpgradeResponseImplCopyWithImpl(
      _$UpgradeResponseImpl _value, $Res Function(_$UpgradeResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkoutUrl = null,
    Object? reference = null,
  }) {
    return _then(_$UpgradeResponseImpl(
      checkoutUrl: null == checkoutUrl
          ? _value.checkoutUrl
          : checkoutUrl // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpgradeResponseImpl implements _UpgradeResponse {
  const _$UpgradeResponseImpl(
      {required this.checkoutUrl, required this.reference});

  factory _$UpgradeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpgradeResponseImplFromJson(json);

  @override
  final String checkoutUrl;
  @override
  final String reference;

  @override
  String toString() {
    return 'UpgradeResponse(checkoutUrl: $checkoutUrl, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpgradeResponseImpl &&
            (identical(other.checkoutUrl, checkoutUrl) ||
                other.checkoutUrl == checkoutUrl) &&
            (identical(other.reference, reference) ||
                other.reference == reference));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, checkoutUrl, reference);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpgradeResponseImplCopyWith<_$UpgradeResponseImpl> get copyWith =>
      __$$UpgradeResponseImplCopyWithImpl<_$UpgradeResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpgradeResponseImplToJson(
      this,
    );
  }
}

abstract class _UpgradeResponse implements UpgradeResponse {
  const factory _UpgradeResponse(
      {required final String checkoutUrl,
      required final String reference}) = _$UpgradeResponseImpl;

  factory _UpgradeResponse.fromJson(Map<String, dynamic> json) =
      _$UpgradeResponseImpl.fromJson;

  @override
  String get checkoutUrl;
  @override
  String get reference;
  @override
  @JsonKey(ignore: true)
  _$$UpgradeResponseImplCopyWith<_$UpgradeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscriptionStatusResponse _$SubscriptionStatusResponseFromJson(
    Map<String, dynamic> json) {
  return _SubscriptionStatusResponse.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionStatusResponse {
  bool get isPremium => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubscriptionStatusResponseCopyWith<SubscriptionStatusResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionStatusResponseCopyWith<$Res> {
  factory $SubscriptionStatusResponseCopyWith(SubscriptionStatusResponse value,
          $Res Function(SubscriptionStatusResponse) then) =
      _$SubscriptionStatusResponseCopyWithImpl<$Res,
          SubscriptionStatusResponse>;
  @useResult
  $Res call({bool isPremium, String? status, DateTime? expiresAt});
}

/// @nodoc
class _$SubscriptionStatusResponseCopyWithImpl<$Res,
        $Val extends SubscriptionStatusResponse>
    implements $SubscriptionStatusResponseCopyWith<$Res> {
  _$SubscriptionStatusResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPremium = null,
    Object? status = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionStatusResponseImplCopyWith<$Res>
    implements $SubscriptionStatusResponseCopyWith<$Res> {
  factory _$$SubscriptionStatusResponseImplCopyWith(
          _$SubscriptionStatusResponseImpl value,
          $Res Function(_$SubscriptionStatusResponseImpl) then) =
      __$$SubscriptionStatusResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPremium, String? status, DateTime? expiresAt});
}

/// @nodoc
class __$$SubscriptionStatusResponseImplCopyWithImpl<$Res>
    extends _$SubscriptionStatusResponseCopyWithImpl<$Res,
        _$SubscriptionStatusResponseImpl>
    implements _$$SubscriptionStatusResponseImplCopyWith<$Res> {
  __$$SubscriptionStatusResponseImplCopyWithImpl(
      _$SubscriptionStatusResponseImpl _value,
      $Res Function(_$SubscriptionStatusResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPremium = null,
    Object? status = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$SubscriptionStatusResponseImpl(
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionStatusResponseImpl implements _SubscriptionStatusResponse {
  const _$SubscriptionStatusResponseImpl(
      {required this.isPremium, this.status, this.expiresAt});

  factory _$SubscriptionStatusResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SubscriptionStatusResponseImplFromJson(json);

  @override
  final bool isPremium;
  @override
  final String? status;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'SubscriptionStatusResponse(isPremium: $isPremium, status: $status, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionStatusResponseImpl &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isPremium, status, expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionStatusResponseImplCopyWith<_$SubscriptionStatusResponseImpl>
      get copyWith => __$$SubscriptionStatusResponseImplCopyWithImpl<
          _$SubscriptionStatusResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionStatusResponseImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionStatusResponse
    implements SubscriptionStatusResponse {
  const factory _SubscriptionStatusResponse(
      {required final bool isPremium,
      final String? status,
      final DateTime? expiresAt}) = _$SubscriptionStatusResponseImpl;

  factory _SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) =
      _$SubscriptionStatusResponseImpl.fromJson;

  @override
  bool get isPremium;
  @override
  String? get status;
  @override
  DateTime? get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionStatusResponseImplCopyWith<_$SubscriptionStatusResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
