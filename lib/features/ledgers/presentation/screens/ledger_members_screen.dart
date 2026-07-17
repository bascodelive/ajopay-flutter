import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../application/ledger_controller.dart';
import '../../data/models/ledger_models.dart';

class LedgerMembersScreen extends ConsumerWidget {
  const LedgerMembersScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(ledgerMembersProvider(ledgerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          // API.md: 403 for a non-Admin caller — a real, expected outcome
          // here, not just a generic failure, worth its own message.
          final message = error is ApiException && error.isForbidden
              ? 'Only ledger Admins can view the full member list.'
              : 'Could not load members.';
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AjopayColors.error),
                  const SizedBox(height: 12),
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        ref.invalidate(ledgerMembersProvider(ledgerId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (members) => RefreshIndicator(
          onRefresh: () => ref.refresh(ledgerMembersProvider(ledgerId).future),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            separatorBuilder: (context, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _MemberTile(member: members[index]),
          ),
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final LedgerMemberResponse member;

  String get _initials {
    final parts = member.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = member.status == 'ACTIVE';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AjopayColors.primaryTint,
          child: Text(
            _initials,
            style: const TextStyle(
              color: AjopayColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(member.fullName),
        subtitle: Text(isActive ? 'Active member' : 'Removed'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AjopayColors.primaryTint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            member.role,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AjopayColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
