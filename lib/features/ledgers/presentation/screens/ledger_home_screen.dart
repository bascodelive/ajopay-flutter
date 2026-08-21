import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/brand_underline.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../subscriptions/application/subscription_controller.dart';
import '../../data/models/ledger_models.dart';
import '../../application/ledger_controller.dart';

class LedgerHomeScreen extends ConsumerWidget {
  const LedgerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgersAsync = ref.watch(myLedgersProvider);
    final limitAsync = ref.watch(ledgerLimitProvider);
    final isPremium =
        ref.watch(subscriptionControllerProvider).valueOrNull?.isPremium ??
            false;
    // Fails open on loading/error — a transient hiccup fetching the
    // limit shouldn't block someone from even opening the sheet; the
    // backend's own enforceGroupLimit is still the real gate regardless
    // of what this client-side check shows.
    final limit = limitAsync.valueOrNull;
    final isAtLimit = limit?.isAtLimit ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajopay'),
        actions: [
          // Gated on purpose — a brand-new, zero-ledger account gets a
          // 403 from the backend on /directory (see LedgerService's
          // membership gate), so this icon simply doesn't exist for
          // that account rather than existing as a dead-end tap. Mirrors
          // the same "must already belong to at least one ledger" rule
          // the backend enforces, rather than letting the client offer
          // something the server will just reject.
          ledgersAsync.maybeWhen(
            data: (ledgers) => ledgers.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Browse ledgers',
                    icon: const Icon(Icons.travel_explore_outlined),
                    onPressed: () => context.push('/ledgers/directory'),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: AppBackdrop(
        // A long ledger list scrolls well past a short gradient fade, so
        // this screen's fade is shorter than a form screen's — otherwise
        // it would just look like a flat color by the time anyone scrolls.
        stops: const [0.0, 0.15],
        child: ledgersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AjopayColors.error),
                  const SizedBox(height: 12),
                  const Text('Could not load your ledgers.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(myLedgersProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (ledgers) => RefreshIndicator(
            onRefresh: () => ref.refresh(myLedgersProvider.future),
            child: ledgers.isEmpty
                ? _EmptyState(
                    onRefresh: () => ref.invalidate(myLedgersProvider))
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: ledgers.length,
                    itemBuilder: (context, index) =>
                        _LedgerCard(ledger: ledgers[index]),
                  ),
          ),
        ),
      ),
      floatingActionButton: ledgersAsync.maybeWhen(
        data: (_) => isAtLimit
            ? FloatingActionButton.extended(
                onPressed: () =>
                    _showLimitReachedSheet(context, isPremium, limit!),
                backgroundColor: AjopayColors.gold,
                icon: const Icon(Icons.workspace_premium_outlined),
                label: Text(isPremium ? 'At your limit' : 'Upgrade for more'),
              )
            : FloatingActionButton.extended(
                onPressed: () => _showCreateOrJoinSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('New / Join'),
              ),
        orElse: () => null,
      ),
    );
  }

  /// Shown instead of the Create/Join sheet once the caller is at their
  /// tier's active-ledger limit — explains why, and only offers an
  /// Upgrade path if there's actually a higher tier to upgrade TO. A
  /// Premium caller already at THEIR cap has nothing to upgrade into,
  /// so that case is purely informational, no CTA.
  void _showLimitReachedSheet(
    BuildContext context,
    bool isPremium,
    LedgerLimitResponse limit,
  ) {
    final noun = limit.maxActiveGroups == 1 ? 'ledger' : 'ledgers';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AjopayColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AjopayColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: AjopayColors.gold, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                isPremium
                    ? "You're at your Premium limit"
                    : "You've reached your ledger limit",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isPremium
                    ? "Your Premium plan allows up to ${limit.maxActiveGroups} "
                        'active $noun, and you already have '
                        '${limit.activeGroupCount}.'
                    : 'Free accounts can have ${limit.maxActiveGroups} active '
                        '$noun at a time. Upgrade to Premium to create or '
                        'join more.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AjopayColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 24),
              if (!isPremium)
                AppPrimaryButton(
                  label: 'Upgrade to Premium',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/subscription');
                  },
                )
              else
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Got it'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateOrJoinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Create a new ledger'),
                subtitle: const Text('Start a savings group and invite others'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/ledgers/create');
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_add_outlined),
                title: const Text('Join with an invite code'),
                subtitle: const Text("Someone already shared a code with you"),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/ledgers/join');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.savings_outlined,
                      size: 64, color: AjopayColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'No ledgers yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const BrandUnderline(width: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Create a savings group or join one with an invite code '
                    'to get started.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AjopayColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tap the button below to begin.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AjopayColors.textMuted,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LedgerCard extends ConsumerWidget {
  const _LedgerCard({required this.ledger});

  final LedgerResponse ledger;

  Color _statusColor(bool locked) => locked
      ? AjopayColors.textMuted
      : (ledger.status == 'ACTIVE' ? AjopayColors.primary : AjopayColors.error);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locked = ledger.locked;

    final card = Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: locked
            ? () => _showLockedLedgerSheet(context, ref)
            : () => context.push('/ledgers/${ledger.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Same rounded-icon language as the new Directory screen's
              // tiles, so a ledger reads as the same kind of "object"
              // whether the caller's browsing their own list or the
              // public directory. Locked swaps the savings icon for a
              // lock, gray instead of Primary Tint — a glance should
              // tell locked apart from ordinary ACTIVE/SUSPENDED status.
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      locked ? AjopayColors.border : AjopayColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  locked ? Icons.lock_outline_rounded : Icons.savings_rounded,
                  color: locked
                      ? AjopayColors.textMuted
                      : AjopayColors.primaryDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ledger.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: locked ? AjopayColors.textMuted : null,
                                ),
                          ),
                        ),
                        if (locked)
                          _LockedBadge()
                        else
                          _RoleBadge(role: ledger.callerRole),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.repeat,
                            size: 16,
                            color: locked
                                ? AjopayColors.textMuted
                                : AjopayColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          '${ledger.contributionFrequency[0]}${ledger.contributionFrequency.substring(1).toLowerCase()} · ₦${ledger.contributionAmount.toStringAsFixed(0)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: locked ? AjopayColors.textMuted : null,
                              ),
                        ),
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: _statusColor(locked),
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          locked ? 'LOCKED' : ledger.status,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _statusColor(locked),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Desaturated, not just dimmed — a plain Opacity() on a still-green
    // icon/badge still reads as "this ledger, slightly faded," which
    // isn't a strong enough signal next to normal cards in the same
    // list. Grayscale is the "this is unavailable" signal every OS uses
    // for disabled UI; cheap here since this list is realistically a
    // handful of items, not a hot scroll path.
    if (!locked) return card;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: card,
    );
  }

  void _showLockedLedgerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _LockedLedgerSheet(ledger: ledger),
    );
  }
}

class _LockedBadge extends StatelessWidget {
  const _LockedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AjopayColors.border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 12, color: AjopayColors.textMuted),
          const SizedBox(width: 4),
          Text(
            'LOCKED',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AjopayColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AjopayColors.primaryTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AjopayColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

/// Shown when a locked ledger's card is tapped. Explains why (in the
/// same words the backend's LedgerAccessLockedException already uses,
/// so nothing here can drift out of sync with the real 403 message a
/// stray write attempt would show), and offers the two real ways out:
/// renew, or make THIS ledger the one that stays free.
class _LockedLedgerSheet extends ConsumerStatefulWidget {
  const _LockedLedgerSheet({required this.ledger});

  final LedgerResponse ledger;

  @override
  ConsumerState<_LockedLedgerSheet> createState() => _LockedLedgerSheetState();
}

class _LockedLedgerSheetState extends ConsumerState<_LockedLedgerSheet> {
  bool _submitting = false;

  Future<void> _makeThisFree() async {
    setState(() => _submitting = true);
    final notifier = ref.read(ledgerControllerProvider.notifier);
    final success = await notifier.chooseKeptLedger(widget.ledger.id);
    if (success) {
      ref.invalidate(myLedgersProvider);
      if (mounted) Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              notifier.lastError ?? 'Something went wrong. Please try again.'),
        ),
      );
    }
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AjopayColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AjopayColors.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  color: AjopayColors.gold, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'This ledger is locked',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.ledger.name} is locked because your Premium '
              'subscription expired. Renew Premium, or make this your '
              'free ledger, to unlock it.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AjopayColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: 'Renew Premium',
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/subscription');
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _submitting ? null : _makeThisFree,
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Make this my free ledger'),
            ),
          ],
        ),
      ),
    );
  }
}