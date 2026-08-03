import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/brand_underline.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../data/models/ledger_models.dart';
import '../../application/ledger_controller.dart';

class LedgerHomeScreen extends ConsumerWidget {
  const LedgerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgersAsync = ref.watch(myLedgersProvider);

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
        data: (_) => FloatingActionButton.extended(
          onPressed: () => _showCreateOrJoinSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('New / Join'),
        ),
        orElse: () => null,
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

class _LedgerCard extends StatelessWidget {
  const _LedgerCard({required this.ledger});

  final LedgerResponse ledger;

  Color get _statusColor =>
      ledger.status == 'ACTIVE' ? AjopayColors.primary : AjopayColors.error;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/ledgers/${ledger.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Same rounded-icon language as the new Directory screen's
              // tiles, so a ledger reads as the same kind of "object"
              // whether the caller's browsing their own list or the
              // public directory.
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AjopayColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.savings_rounded,
                    color: AjopayColors.primaryDark, size: 22),
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
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        _RoleBadge(role: ledger.callerRole),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.repeat,
                            size: 16, color: AjopayColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          '${ledger.contributionFrequency[0]}${ledger.contributionFrequency.substring(1).toLowerCase()} · ₦${ledger.contributionAmount.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: _statusColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ledger.status,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _statusColor,
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
