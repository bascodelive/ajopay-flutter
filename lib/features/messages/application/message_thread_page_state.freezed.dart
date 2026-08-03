// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_thread_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MessageThreadPageState {
  List<MessageResponse> get items => throw _privateConstructorUsedError;
  int get earliestPageFetched => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  String? get loadMoreError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageThreadPageStateCopyWith<MessageThreadPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageThreadPageStateCopyWith<$Res> {
  factory $MessageThreadPageStateCopyWith(MessageThreadPageState value,
          $Res Function(MessageThreadPageState) then) =
      _$MessageThreadPageStateCopyWithImpl<$Res, MessageThreadPageState>;
  @useResult
  $Res call(
      {List<MessageResponse> items,
      int earliestPageFetched,
      bool hasMore,
      bool isLoadingMore,
      String? loadMoreError});
}

/// @nodoc
class _$MessageThreadPageStateCopyWithImpl<$Res,
        $Val extends MessageThreadPageState>
    implements $MessageThreadPageStateCopyWith<$Res> {
  _$MessageThreadPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? earliestPageFetched = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MessageResponse>,
      earliestPageFetched: null == earliestPageFetched
          ? _value.earliestPageFetched
          : earliestPageFetched // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MessageThreadPageStateImplCopyWith<$Res>
    implements $MessageThreadPageStateCopyWith<$Res> {
  factory _$$MessageThreadPageStateImplCopyWith(
          _$MessageThreadPageStateImpl value,
          $Res Function(_$MessageThreadPageStateImpl) then) =
      __$$MessageThreadPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MessageResponse> items,
      int earliestPageFetched,
      bool hasMore,
      bool isLoadingMore,
      String? loadMoreError});
}

/// @nodoc
class __$$MessageThreadPageStateImplCopyWithImpl<$Res>
    extends _$MessageThreadPageStateCopyWithImpl<$Res,
        _$MessageThreadPageStateImpl>
    implements _$$MessageThreadPageStateImplCopyWith<$Res> {
  __$$MessageThreadPageStateImplCopyWithImpl(
      _$MessageThreadPageStateImpl _value,
      $Res Function(_$MessageThreadPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? earliestPageFetched = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(_$MessageThreadPageStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MessageResponse>,
      earliestPageFetched: null == earliestPageFetched
          ? _value.earliestPageFetched
          : earliestPageFetched // ignore: cast_nullable_to_non_nullable
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

class _$MessageThreadPageStateImpl implements _MessageThreadPageState {
  const _$MessageThreadPageStateImpl(
      {final List<MessageResponse> items = const [],
      this.earliestPageFetched = 0,
      this.hasMore = true,
      this.isLoadingMore = false,
      this.loadMoreError})
      : _items = items;

  final List<MessageResponse> _items;
  @override
  @JsonKey()
  List<MessageResponse> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int earliestPageFetched;
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
    return 'MessageThreadPageState(items: $items, earliestPageFetched: $earliestPageFetched, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageThreadPageStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.earliestPageFetched, earliestPageFetched) ||
                other.earliestPageFetched == earliestPageFetched) &&
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
      earliestPageFetched,
      hasMore,
      isLoadingMore,
      loadMoreError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageThreadPageStateImplCopyWith<_$MessageThreadPageStateImpl>
      get copyWith => __$$MessageThreadPageStateImplCopyWithImpl<
          _$MessageThreadPageStateImpl>(this, _$identity);
}

abstract class _MessageThreadPageState implements MessageThreadPageState {
  const factory _MessageThreadPageState(
      {final List<MessageResponse> items,
      final int earliestPageFetched,
      final bool hasMore,
      final bool isLoadingMore,
      final String? loadMoreError}) = _$MessageThreadPageStateImpl;

  @override
  List<MessageResponse> get items;
  @override
  int get earliestPageFetched;
  @override
  bool get hasMore;
  @override
  bool get isLoadingMore;
  @override
  String? get loadMoreError;
  @override
  @JsonKey(ignore: true)
  _$$MessageThreadPageStateImplCopyWith<_$MessageThreadPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
