// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ledgerControllerHash() => r'531565b1bb3000d8f89841e8d3144d57f8bae29b';

/// Holds the ledger currently being created/joined/viewed/edited.
///
/// This is NOT "the user's list of ledgers" — that's `myLedgersProvider`
/// below, a separate simple FutureProvider, since listing is pure fetch
/// with no mutation. This notifier tracks one ledger at a time, identified
/// by whatever `ledgerId` the caller already has (from create/join, from
/// picking one in the list, or from navigation state).
///
/// Copied from [LedgerController].
@ProviderFor(LedgerController)
final ledgerControllerProvider =
    AutoDisposeNotifierProvider<LedgerController, LedgerResponse?>.internal(
  LedgerController.new,
  name: r'ledgerControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ledgerControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LedgerController = AutoDisposeNotifier<LedgerResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
