// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PageResponse<T> _$PageResponseFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _PageResponse<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$PageResponse<T> {
  List<T> get content => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get first => throw _privateConstructorUsedError;
  bool get last => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PageResponseCopyWith<T, PageResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageResponseCopyWith<T, $Res> {
  factory $PageResponseCopyWith(
          PageResponse<T> value, $Res Function(PageResponse<T>) then) =
      _$PageResponseCopyWithImpl<T, $Res, PageResponse<T>>;
  @useResult
  $Res call(
      {List<T> content,
      int page,
      int size,
      int totalElements,
      int totalPages,
      bool first,
      bool last});
}

/// @nodoc
class _$PageResponseCopyWithImpl<T, $Res, $Val extends PageResponse<T>>
    implements $PageResponseCopyWith<T, $Res> {
  _$PageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? page = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? first = null,
    Object? last = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as List<T>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      first: null == first
          ? _value.first
          : first // ignore: cast_nullable_to_non_nullable
              as bool,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageResponseImplCopyWith<T, $Res>
    implements $PageResponseCopyWith<T, $Res> {
  factory _$$PageResponseImplCopyWith(_$PageResponseImpl<T> value,
          $Res Function(_$PageResponseImpl<T>) then) =
      __$$PageResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {List<T> content,
      int page,
      int size,
      int totalElements,
      int totalPages,
      bool first,
      bool last});
}

/// @nodoc
class __$$PageResponseImplCopyWithImpl<T, $Res>
    extends _$PageResponseCopyWithImpl<T, $Res, _$PageResponseImpl<T>>
    implements _$$PageResponseImplCopyWith<T, $Res> {
  __$$PageResponseImplCopyWithImpl(
      _$PageResponseImpl<T> _value, $Res Function(_$PageResponseImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? page = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? first = null,
    Object? last = null,
  }) {
    return _then(_$PageResponseImpl<T>(
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<T>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      first: null == first
          ? _value.first
          : first // ignore: cast_nullable_to_non_nullable
              as bool,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$PageResponseImpl<T> implements _PageResponse<T> {
  const _$PageResponseImpl(
      {required final List<T> content,
      required this.page,
      required this.size,
      required this.totalElements,
      required this.totalPages,
      required this.first,
      required this.last})
      : _content = content;

  factory _$PageResponseImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$PageResponseImplFromJson(json, fromJsonT);

  final List<T> _content;
  @override
  List<T> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  final int page;
  @override
  final int size;
  @override
  final int totalElements;
  @override
  final int totalPages;
  @override
  final bool first;
  @override
  final bool last;

  @override
  String toString() {
    return 'PageResponse<$T>(content: $content, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages, first: $first, last: $last)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageResponseImpl<T> &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.first, first) || other.first == first) &&
            (identical(other.last, last) || other.last == last));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_content),
      page,
      size,
      totalElements,
      totalPages,
      first,
      last);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageResponseImplCopyWith<T, _$PageResponseImpl<T>> get copyWith =>
      __$$PageResponseImplCopyWithImpl<T, _$PageResponseImpl<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$PageResponseImplToJson<T>(this, toJsonT);
  }
}

abstract class _PageResponse<T> implements PageResponse<T> {
  const factory _PageResponse(
      {required final List<T> content,
      required final int page,
      required final int size,
      required final int totalElements,
      required final int totalPages,
      required final bool first,
      required final bool last}) = _$PageResponseImpl<T>;

  factory _PageResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$PageResponseImpl<T>.fromJson;

  @override
  List<T> get content;
  @override
  int get page;
  @override
  int get size;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  bool get first;
  @override
  bool get last;
  @override
  @JsonKey(ignore: true)
  _$$PageResponseImplCopyWith<T, _$PageResponseImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
