// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributions_pager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contributionsPagerHash() =>
    r'723779f905fc0c4d285e27470f6177b66099ed83';

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

abstract class _$ContributionsPager
    extends BuildlessAutoDisposeAsyncNotifier<ContributionsPageState> {
  late final ({String ledgerId, ContributionScope scope}) key;

  FutureOr<ContributionsPageState> build(
    ({String ledgerId, ContributionScope scope}) key,
  );
}

/// See also [ContributionsPager].
@ProviderFor(ContributionsPager)
const contributionsPagerProvider = ContributionsPagerFamily();

/// See also [ContributionsPager].
class ContributionsPagerFamily
    extends Family<AsyncValue<ContributionsPageState>> {
  /// See also [ContributionsPager].
  const ContributionsPagerFamily();

  /// See also [ContributionsPager].
  ContributionsPagerProvider call(
    ({String ledgerId, ContributionScope scope}) key,
  ) {
    return ContributionsPagerProvider(
      key,
    );
  }

  @override
  ContributionsPagerProvider getProviderOverride(
    covariant ContributionsPagerProvider provider,
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
  String? get name => r'contributionsPagerProvider';
}

/// See also [ContributionsPager].
class ContributionsPagerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ContributionsPager, ContributionsPageState> {
  /// See also [ContributionsPager].
  ContributionsPagerProvider(
    ({String ledgerId, ContributionScope scope}) key,
  ) : this._internal(
          () => ContributionsPager()..key = key,
          from: contributionsPagerProvider,
          name: r'contributionsPagerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$contributionsPagerHash,
          dependencies: ContributionsPagerFamily._dependencies,
          allTransitiveDependencies:
              ContributionsPagerFamily._allTransitiveDependencies,
          key: key,
        );

  ContributionsPagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final ({String ledgerId, ContributionScope scope}) key;

  @override
  FutureOr<ContributionsPageState> runNotifierBuild(
    covariant ContributionsPager notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(ContributionsPager Function() create) {
    return ProviderOverride(
      origin: this,
      override: ContributionsPagerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ContributionsPager,
      ContributionsPageState> createElement() {
    return _ContributionsPagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContributionsPagerProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ContributionsPagerRef
    on AutoDisposeAsyncNotifierProviderRef<ContributionsPageState> {
  /// The parameter `key` of this provider.
  ({String ledgerId, ContributionScope scope}) get key;
}

class _ContributionsPagerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ContributionsPager,
        ContributionsPageState> with ContributionsPagerRef {
  _ContributionsPagerProviderElement(super.provider);

  @override
  ({String ledgerId, ContributionScope scope}) get key =>
      (origin as ContributionsPagerProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
