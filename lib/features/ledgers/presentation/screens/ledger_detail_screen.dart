import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/ledger_controller.dart';
import '../../data/models/ledger_models.dart';

class LedgerDetailScreen extends ConsumerWidget {
  const LedgerDetailScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(ledgerDetailProvider(ledgerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        actions: [
          ledgerAsync.maybeWhen(
            data: (ledger) => ledger.callerRole == 'ADMIN'
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => context.push('/ledgers/$ledgerId/edit'),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: ledgerAsync.when(
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
                const Text('Could not load this ledger.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(ledgerDetailProvider(ledgerId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (ledger) => RefreshIndicator(
          onRefresh: () => ref.refresh(ledgerDetailProvider(ledgerId).future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderCard(ledger: ledger),
                const SizedBox(height: 16),
                _InviteCodeCard(ledger: ledger),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.groups_outlined),
                    title: const Text('Members'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/ledgers/$ledgerId/members'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.ledger});

  final LedgerResponse ledger;

  @override
  Widget build(BuildContext context) {
    final isActive = ledger.status == 'ACTIVE';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ledger.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AjopayColors.primaryTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ledger.callerRole,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AjopayColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.repeat,
              label: 'Frequency',
              value:
                  '${ledger.contributionFrequency[0]}${ledger.contributionFrequency.substring(1).toLowerCase()}',
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.payments_outlined,
              label: 'Amount',
              value:
                  '₦${ledger.contributionAmount.toStringAsFixed(0)} per cycle',
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: isActive
                  ? Icons.check_circle_outline
                  : Icons.pause_circle_outline,
              label: 'Status',
              value: ledger.status,
              valueColor: isActive ? AjopayColors.primary : AjopayColors.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({required this.ledger});

  final LedgerResponse ledger;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AjopayColors.primaryTint,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite code',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AjopayColors.primaryDark,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ledger.inviteCode,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AjopayColors.primaryDark,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy_outlined,
                  color: AjopayColors.primaryDark),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: ledger.inviteCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite code copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
