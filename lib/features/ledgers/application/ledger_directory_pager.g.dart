// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_directory_pager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ledgerDirectoryPagerHash() =>
    r'19738aa79c677e4102e648a181a2cc241781efef';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LedgerDirectoryPager
    extends BuildlessAutoDisposeAsyncNotifier<LedgerDirectoryPageState> {
  late final String search;

  FutureOr<LedgerDirectoryPageState> build(
    String search,
  );
}

/// Keyed by the search term alone ('' for no filter) — a new search
/// resets to a fresh page-0 fetch under its own key, same as
/// ContributionsPager is keyed by (ledgerId, scope). Riverpod's family
/// caching means switching between two search terms and back reuses
/// whatever was already fetched, rather than re-fetching every keystroke
/// (paired with the screen's own debounce before it ever updates this
/// key — see LedgerDirectoryScreen).
///
/// Copied from [LedgerDirectoryPager].
@ProviderFor(LedgerDirectoryPager)
const ledgerDirectoryPagerProvider = LedgerDirectoryPagerFamily();

/// Keyed by the search term alone ('' for no filter) — a new search
/// resets to a fresh page-0 fetch under its own key, same as
/// ContributionsPager is keyed by (ledgerId, scope). Riverpod's family
/// caching means switching between two search terms and back reuses
/// whatever was already fetched, rather than re-fetching every keystroke
/// (paired with the screen's own debounce before it ever updates this
/// key — see LedgerDirectoryScreen).
///
/// Copied from [LedgerDirectoryPager].
class LedgerDirectoryPagerFamily
    extends Family<AsyncValue<LedgerDirectoryPageState>> {
  /// Keyed by the search term alone ('' for no filter) — a new search
  /// resets to a fresh page-0 fetch under its own key, same as
  /// ContributionsPager is keyed by (ledgerId, scope). Riverpod's family
  /// caching means switching between two search terms and back reuses
  /// whatever was already fetched, rather than re-fetching every keystroke
  /// (paired with the screen's own debounce before it ever updates this
  /// key — see LedgerDirectoryScreen).
  ///
  /// Copied from [LedgerDirectoryPager].
  const LedgerDirectoryPagerFamily();

  /// Keyed by the search term alone ('' for no filter) — a new search
  /// resets to a fresh page-0 fetch under its own key, same as
  /// ContributionsPager is keyed by (ledgerId, scope). Riverpod's family
  /// caching means switching between two search terms and back reuses
  /// whatever was already fetched, rather than re-fetching every keystroke
  /// (paired with the screen's own debounce before it ever updates this
  /// key — see LedgerDirectoryScreen).
  ///
  /// Copied from [LedgerDirectoryPager].
  LedgerDirectoryPagerProvider call(
    String search,
  ) {
    return LedgerDirectoryPagerProvider(
      search,
    );
  }

  @override
  LedgerDirectoryPagerProvider getProviderOverride(
    covariant LedgerDirectoryPagerProvider provider,
  ) {
    return call(
      provider.search,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'ledgerDirectoryPagerProvider';
}

/// Keyed by the search term alone ('' for no filter) — a new search
/// resets to a fresh page-0 fetch under its own key, same as
/// ContributionsPager is keyed by (ledgerId, scope). Riverpod's family
/// caching means switching between two search terms and back reuses
/// whatever was already fetched, rather than re-fetching every keystroke
/// (paired with the screen's own debounce before it ever updates this
/// key — see LedgerDirectoryScreen).
///
/// Copied from [LedgerDirectoryPager].
class LedgerDirectoryPagerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LedgerDirectoryPager, LedgerDirectoryPageState> {
  /// Keyed by the search term alone ('' for no filter) — a new search
  /// resets to a fresh page-0 fetch under its own key, same as
  /// ContributionsPager is keyed by (ledgerId, scope). Riverpod's family
  /// caching means switching between two search terms and back reuses
  /// whatever was already fetched, rather than re-fetching every keystroke
  /// (paired with the screen's own debounce before it ever updates this
  /// key — see LedgerDirectoryScreen).
  ///
  /// Copied from [LedgerDirectoryPager].
  LedgerDirectoryPagerProvider(
    String search,
  ) : this._internal(
          () => LedgerDirectoryPager()..search = search,
          from: ledgerDirectoryPagerProvider,
          name: r'ledgerDirectoryPagerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ledgerDirectoryPagerHash,
          dependencies: LedgerDirectoryPagerFamily._dependencies,
          allTransitiveDependencies:
              LedgerDirectoryPagerFamily._allTransitiveDependencies,
          search: search,
        );

  LedgerDirectoryPagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.search,
  }) : super.internal();

  final String search;

  @override
  FutureOr<LedgerDirectoryPageState> runNotifierBuild(
    covariant LedgerDirectoryPager notifier,
  ) {
    return notifier.build(
      search,
    );
  }

  @override
  Override overrideWith(LedgerDirectoryPager Function() create) {
    return ProviderOverride(
      origin: this,
      override: LedgerDirectoryPagerProvider._internal(
        () => create()..search = search,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LedgerDirectoryPager,
      LedgerDirectoryPageState> createElement() {
    return _LedgerDirectoryPagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LedgerDirectoryPagerProvider && other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LedgerDirectoryPagerRef
    on AutoDisposeAsyncNotifierProviderRef<LedgerDirectoryPageState> {
  /// The parameter `search` of this provider.
  String get search;
}

class _LedgerDirectoryPagerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LedgerDirectoryPager,
        LedgerDirectoryPageState> with LedgerDirectoryPagerRef {
  _LedgerDirectoryPagerProviderElement(super.provider);

  @override
  String get search => (origin as LedgerDirectoryPagerProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
