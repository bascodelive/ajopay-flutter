// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationsPageState {
  List<NotificationResponse> get items => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  String? get loadMoreError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsPageStateCopyWith<NotificationsPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsPageStateCopyWith<$Res> {
  factory $NotificationsPageStateCopyWith(NotificationsPageState value,
          $Res Function(NotificationsPageState) then) =
      _$NotificationsPageStateCopyWithImpl<$Res, NotificationsPageState>;
  @useResult
  $Res call(
      {List<NotificationResponse> items,
      int page,
      bool hasMore,
      bool isLoadingMore,
      String? loadMoreError});
}

/// @nodoc
class _$NotificationsPageStateCopyWithImpl<$Res,
        $Val extends NotificationsPageState>
    implements $NotificationsPageStateCopyWith<$Res> {
  _$NotificationsPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NotificationResponse>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadMoreError: freezed == loadMoreError
          ? _value.loadMoreError
          : loadMoreError // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsPageStateImplCopyWith<$Res>
    implements $NotificationsPageStateCopyWith<$Res> {
  factory _$$NotificationsPageStateImplCopyWith(
          _$NotificationsPageStateImpl value,
          $Res Function(_$NotificationsPageStateImpl) then) =
      __$$NotificationsPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<NotificationResponse> items,
      int page,
      bool hasMore,
      bool isLoadingMore,
      String? loadMoreError});
}

/// @nodoc
class __$$NotificationsPageStateImplCopyWithImpl<$Res>
    extends _$NotificationsPageStateCopyWithImpl<$Res,
        _$NotificationsPageStateImpl>
    implements _$$NotificationsPageStateImplCopyWith<$Res> {
  __$$NotificationsPageStateImplCopyWithImpl(
      _$NotificationsPageStateImpl _value,
      $Res Function(_$NotificationsPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(_$NotificationsPageStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NotificationResponse>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadMoreError: freezed == loadMoreError
          ? _value.loadMoreError
          : loadMoreError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NotificationsPageStateImpl implements _NotificationsPageState {
  const _$NotificationsPageStateImpl(
      {final List<NotificationResponse> items = const [],
      this.page = 0,
      this.hasMore = true,
      this.isLoadingMore = false,
      this.loadMoreError})
      : _items = items;

  final List<NotificationResponse> _items;
  @override
  @JsonKey()
  List<NotificationResponse> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  final String? loadMoreError;

  @override
  String toString() {
    return 'NotificationsPageState(items: $items, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsPageStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.loadMoreError, loadMoreError) ||
                other.loadMoreError == loadMoreError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      page,
      hasMore,
      isLoadingMore,
      loadMoreError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsPageStateImplCopyWith<_$NotificationsPageStateImpl>
      get copyWith => __$$NotificationsPageStateImplCopyWithImpl<
          _$NotificationsPageStateImpl>(this, _$identity);
}

abstract class _NotificationsPageState implements NotificationsPageState {
  const factory _NotificationsPageState(
      {final List<NotificationResponse> items,
      final int page,
      final bool hasMore,
      final bool isLoadingMore,
      final String? loadMoreError}) = _$NotificationsPageStateImpl;

  @override
  List<NotificationResponse> get items;
  @override
  int get page;
  @override
  bool get hasMore;
  @override
  bool get isLoadingMore;
  @override
  String? get loadMoreError;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsPageStateImplCopyWith<_$NotificationsPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
