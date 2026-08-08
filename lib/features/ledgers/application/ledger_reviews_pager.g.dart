// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_reviews_pager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ledgerReviewsPagerHash() =>
    r'bf92a24637debb33be881c1f6ec815eafd4934b9';

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

abstract class _$LedgerReviewsPager
    extends BuildlessAutoDisposeAsyncNotifier<LedgerReviewsPageState> {
  late final String ledgerId;

  FutureOr<LedgerReviewsPageState> build(
    String ledgerId,
  );
}

/// See also [LedgerReviewsPager].
@ProviderFor(LedgerReviewsPager)
const ledgerReviewsPagerProvider = LedgerReviewsPagerFamily();

/// See also [LedgerReviewsPager].
class LedgerReviewsPagerFamily
    extends Family<AsyncValue<LedgerReviewsPageState>> {
  /// See also [LedgerReviewsPager].
  const LedgerReviewsPagerFamily();

  /// See also [LedgerReviewsPager].
  LedgerReviewsPagerProvider call(
    String ledgerId,
  ) {
    return LedgerReviewsPagerProvider(
      ledgerId,
    );
  }

  @override
  LedgerReviewsPagerProvider getProviderOverride(
    covariant LedgerReviewsPagerProvider provider,
  ) {
    return call(
      provider.ledgerId,
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
  String? get name => r'ledgerReviewsPagerProvider';
}

/// See also [LedgerReviewsPager].
class LedgerReviewsPagerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LedgerReviewsPager, LedgerReviewsPageState> {
  /// See also [LedgerReviewsPager].
  LedgerReviewsPagerProvider(
    String ledgerId,
  ) : this._internal(
          () => LedgerReviewsPager()..ledgerId = ledgerId,
          from: ledgerReviewsPagerProvider,
          name: r'ledgerReviewsPagerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ledgerReviewsPagerHash,
          dependencies: LedgerReviewsPagerFamily._dependencies,
          allTransitiveDependencies:
              LedgerReviewsPagerFamily._allTransitiveDependencies,
          ledgerId: ledgerId,
        );

  LedgerReviewsPagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ledgerId,
  }) : super.internal();

  final String ledgerId;

  @override
  FutureOr<LedgerReviewsPageState> runNotifierBuild(
    covariant LedgerReviewsPager notifier,
  ) {
    return notifier.build(
      ledgerId,
    );
  }

  @override
  Override overrideWith(LedgerReviewsPager Function() create) {
    return ProviderOverride(
      origin: this,
      override: LedgerReviewsPagerProvider._internal(
        () => create()..ledgerId = ledgerId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ledgerId: ledgerId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LedgerReviewsPager,
      LedgerReviewsPageState> createElement() {
    return _LedgerReviewsPagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LedgerReviewsPagerProvider && other.ledgerId == ledgerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ledgerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LedgerReviewsPagerRef
    on AutoDisposeAsyncNotifierProviderRef<LedgerReviewsPageState> {
  /// The parameter `ledgerId` of this provider.
  String get ledgerId;
}

class _LedgerReviewsPagerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LedgerReviewsPager,
        LedgerReviewsPageState> with LedgerReviewsPagerRef {
  _LedgerReviewsPagerProviderElement(super.provider);

  @override
  String get ledgerId => (origin as LedgerReviewsPagerProvider).ledgerId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
