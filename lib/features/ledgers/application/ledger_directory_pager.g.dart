// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_directory_pager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ledgerDirectoryPagerHash() =>
    r'5b1836fc5a7b833f1cc1a4325afd5271417a2bf6';

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
  late final ({DirectorySort orderBy, String search}) key;

  FutureOr<LedgerDirectoryPageState> build(
    ({DirectorySort orderBy, String search}) key,
  );
}

/// See also [LedgerDirectoryPager].
@ProviderFor(LedgerDirectoryPager)
const ledgerDirectoryPagerProvider = LedgerDirectoryPagerFamily();

/// See also [LedgerDirectoryPager].
class LedgerDirectoryPagerFamily
    extends Family<AsyncValue<LedgerDirectoryPageState>> {
  /// See also [LedgerDirectoryPager].
  const LedgerDirectoryPagerFamily();

  /// See also [LedgerDirectoryPager].
  LedgerDirectoryPagerProvider call(
    ({DirectorySort orderBy, String search}) key,
  ) {
    return LedgerDirectoryPagerProvider(
      key,
    );
  }

  @override
  LedgerDirectoryPagerProvider getProviderOverride(
    covariant LedgerDirectoryPagerProvider provider,
  ) {
    return call(
      provider.key,
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

/// See also [LedgerDirectoryPager].
class LedgerDirectoryPagerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LedgerDirectoryPager, LedgerDirectoryPageState> {
  /// See also [LedgerDirectoryPager].
  LedgerDirectoryPagerProvider(
    ({DirectorySort orderBy, String search}) key,
  ) : this._internal(
          () => LedgerDirectoryPager()..key = key,
          from: ledgerDirectoryPagerProvider,
          name: r'ledgerDirectoryPagerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ledgerDirectoryPagerHash,
          dependencies: LedgerDirectoryPagerFamily._dependencies,
          allTransitiveDependencies:
              LedgerDirectoryPagerFamily._allTransitiveDependencies,
          key: key,
        );

  LedgerDirectoryPagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final ({DirectorySort orderBy, String search}) key;

  @override
  FutureOr<LedgerDirectoryPageState> runNotifierBuild(
    covariant LedgerDirectoryPager notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(LedgerDirectoryPager Function() create) {
    return ProviderOverride(
      origin: this,
      override: LedgerDirectoryPagerProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
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
    return other is LedgerDirectoryPagerProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LedgerDirectoryPagerRef
    on AutoDisposeAsyncNotifierProviderRef<LedgerDirectoryPageState> {
  /// The parameter `key` of this provider.
  ({DirectorySort orderBy, String search}) get key;
}

class _LedgerDirectoryPagerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LedgerDirectoryPager,
        LedgerDirectoryPageState> with LedgerDirectoryPagerRef {
  _LedgerDirectoryPagerProviderElement(super.provider);

  @override
  ({DirectorySort orderBy, String search}) get key =>
      (origin as LedgerDirectoryPagerProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
