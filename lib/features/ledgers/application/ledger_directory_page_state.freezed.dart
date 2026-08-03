// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_directory_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LedgerDirectoryPageState {
  List<LedgerDirectoryEntryResponse> get items =>
      throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  String? get loadMoreError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LedgerDirectoryPageStateCopyWith<LedgerDirectoryPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerDirectoryPageStateCopyWith<$Res> {
  factory $LedgerDirectoryPageStateCopyWith(LedgerDirectoryPageState value,
          $Res Function(LedgerDirectoryPageState) then) =
      _$LedgerDirectoryPageStateCopyWithImpl<$Res, LedgerDirectoryPageState>;
  @useResult
  $Res call(
      {List<LedgerDirectoryEntryResponse> items,
      int page,
      bool hasMore,
      bool isLoadingMore,
      String? loadMoreError});
}

/// @nodoc
class _$LedgerDirectoryPageStateCopyWithImpl<$Res,
        $Val extends LedgerDirectoryPageState>
    implements $LedgerDirectoryPageStateCopyWith<$Res> {
  _$LedgerDirectoryPageStateCopyWithImpl(this._value, this._then);

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
              as List<LedgerDirectoryEntryResponse>,
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
abstract class _$$LedgerDirectoryPageStateImplCopyWith<$Res>
    implements $LedgerDirectoryPageStateCopyWith<$Res> {
  factory _$$LedgerDirectoryPageStateImplCopyWith(
          _$LedgerDirectoryPageStateImpl value,
          $Res Function(_$LedgerDirectoryPageStateImpl) then) =
      __$$LedgerDirectoryPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LedgerDirectoryEntryResponse> items,
      int page,
      bool hasMore,
      bool isLoadingMore,
      String? loadMoreError});
}

/// @nodoc
class __$$LedgerDirectoryPageStateImplCopyWithImpl<$Res>
    extends _$LedgerDirectoryPageStateCopyWithImpl<$Res,
        _$LedgerDirectoryPageStateImpl>
    implements _$$LedgerDirectoryPageStateImplCopyWith<$Res> {
  __$$LedgerDirectoryPageStateImplCopyWithImpl(
      _$LedgerDirectoryPageStateImpl _value,
      $Res Function(_$LedgerDirectoryPageStateImpl) _then)
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
    return _then(_$LedgerDirectoryPageStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LedgerDirectoryEntryResponse>,
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

class _$LedgerDirectoryPageStateImpl implements _LedgerDirectoryPageState {
  const _$LedgerDirectoryPageStateImpl(
      {final List<LedgerDirectoryEntryResponse> items = const [],
      this.page = 0,
      this.hasMore = true,
      this.isLoadingMore = false,
      this.loadMoreError})
      : _items = items;

  final List<LedgerDirectoryEntryResponse> _items;
  @override
  @JsonKey()
  List<LedgerDirectoryEntryResponse> get items {
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
    return 'LedgerDirectoryPageState(items: $items, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerDirectoryPageStateImpl &&
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
  _$$LedgerDirectoryPageStateImplCopyWith<_$LedgerDirectoryPageStateImpl>
      get copyWith => __$$LedgerDirectoryPageStateImplCopyWithImpl<
          _$LedgerDirectoryPageStateImpl>(this, _$identity);
}

abstract class _LedgerDirectoryPageState implements LedgerDirectoryPageState {
  const factory _LedgerDirectoryPageState(
      {final List<LedgerDirectoryEntryResponse> items,
      final int page,
      final bool hasMore,
      final bool isLoadingMore,
      final String? loadMoreError}) = _$LedgerDirectoryPageStateImpl;

  @override
  List<LedgerDirectoryEntryResponse> get items;
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
  _$$LedgerDirectoryPageStateImplCopyWith<_$LedgerDirectoryPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
