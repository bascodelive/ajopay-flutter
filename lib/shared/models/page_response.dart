import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_response.freezed.dart';
part 'page_response.g.dart';

/// Matches API.md's Conventions section exactly — every 📄-marked
/// endpoint returns this wrapper shape instead of a bare array.
///
/// `genericArgumentFactories: true` is required for a generic Freezed
/// class — without it, `fromJson` can't know how to deserialize the
/// `content` list's item type at runtime. Callers must pass their own
/// `fromJsonT` (see ContributionRepository for the pattern).
@Freezed(genericArgumentFactories: true)
class PageResponse<T> with _$PageResponse<T> {
  const factory PageResponse({
    required List<T> content,
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool first,
    required bool last,
  }) = _PageResponse<T>;

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageResponseFromJson(json, fromJsonT);
}
