// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_thread_pager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageThreadPagerHash() =>
    r'3cc29985225af8a10b01e2c9b84e7d2361ceb827';

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

abstract class _$MessageThreadPager
    extends BuildlessAutoDisposeAsyncNotifier<MessageThreadPageState> {
  late final ({
    String ledgerId,
    String? otherUserId,
    MessageThreadType type
  }) key;

  FutureOr<MessageThreadPageState> build(
    ({String ledgerId, String? otherUserId, MessageThreadType type}) key,
  );
}

/// See also [MessageThreadPager].
@ProviderFor(MessageThreadPager)
const messageThreadPagerProvider = MessageThreadPagerFamily();

/// See also [MessageThreadPager].
class MessageThreadPagerFamily
    extends Family<AsyncValue<MessageThreadPageState>> {
  /// See also [MessageThreadPager].
  const MessageThreadPagerFamily();

  /// See also [MessageThreadPager].
  MessageThreadPagerProvider call(
    ({String ledgerId, String? otherUserId, MessageThreadType type}) key,
  ) {
    return MessageThreadPagerProvider(
      key,
    );
  }

  @override
  MessageThreadPagerProvider getProviderOverride(
    covariant MessageThreadPagerProvider provider,
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
  String? get name => r'messageThreadPagerProvider';
}

/// See also [MessageThreadPager].
class MessageThreadPagerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MessageThreadPager, MessageThreadPageState> {
  /// See also [MessageThreadPager].
  MessageThreadPagerProvider(
    ({String ledgerId, String? otherUserId, MessageThreadType type}) key,
  ) : this._internal(
          () => MessageThreadPager()..key = key,
          from: messageThreadPagerProvider,
          name: r'messageThreadPagerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageThreadPagerHash,
          dependencies: MessageThreadPagerFamily._dependencies,
          allTransitiveDependencies:
              MessageThreadPagerFamily._allTransitiveDependencies,
          key: key,
        );

  MessageThreadPagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final ({String ledgerId, String? otherUserId, MessageThreadType type}) key;

  @override
  FutureOr<MessageThreadPageState> runNotifierBuild(
    covariant MessageThreadPager notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(MessageThreadPager Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessageThreadPagerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MessageThreadPager,
      MessageThreadPageState> createElement() {
    return _MessageThreadPagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageThreadPagerProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessageThreadPagerRef
    on AutoDisposeAsyncNotifierProviderRef<MessageThreadPageState> {
  /// The parameter `key` of this provider.
  ({String ledgerId, String? otherUserId, MessageThreadType type}) get key;
}

class _MessageThreadPagerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MessageThreadPager,
        MessageThreadPageState> with MessageThreadPagerRef {
  _MessageThreadPagerProviderElement(super.provider);

  @override
  ({String ledgerId, String? otherUserId, MessageThreadType type}) get key =>
      (origin as MessageThreadPagerProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
