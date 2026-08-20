import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../../ledgers/data/models/ledger_models.dart';
import '../../application/contribution_action_controller.dart';
import '../../data/models/contribution_models.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');

/// Admin picks one, several, or all active members plus a single cycle
/// date, and opens a contribution for each of them at once —
/// independent of any Circle entirely (see
/// ContributionService.scheduleContributionBatch's Javadoc). This is a
/// genuinely different action from the single-member "+" flow
/// (ScheduleContributionScreen), which stays for retroactively opening
/// ONE contribution for a member who was missed.
class ScheduleContributionBatchScreen extends ConsumerStatefulWidget {
  const ScheduleContributionBatchScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  ConsumerState<ScheduleContributionBatchScreen> createState() =>
      _ScheduleContributionBatchScreenState();
}

class _ScheduleContributionBatchScreenState
    extends ConsumerState<ScheduleContributionBatchScreen> {
  final Set<String> _selectedUserIds = {};
  DateTime? _cycleDate;
  bool _isSubmitting = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _cycleDate = picked);
  }

  void _toggleAll(List<String> allUserIds) {
    setState(() {
      if (_selectedUserIds.length == allUserIds.length) {
        _selectedUserIds.clear();
      } else {
        _selectedUserIds
          ..clear()
          ..addAll(allUserIds);
      }
    });
  }

  Future<void> _submit() async {
    final cycleDate = _cycleDate;
    if (_selectedUserIds.isEmpty) {
      AppFeedback.showInfo(context, 'Select at least one member');
      return;
    }
    if (cycleDate == null) {
      AppFeedback.showInfo(context, 'Pick a cycle date first');
      return;
    }

    setState(() => _isSubmitting = true);
    final result =
        await ref.read(contributionActionControllerProvider.notifier).scheduleBatch(
              widget.ledgerId,
              _selectedUserIds.toList(),
              _dateFormat.format(cycleDate),
            );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result == null) {
      final message =
          ref.read(contributionActionControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not schedule contributions.');
      return;
    }

    if (result.skipped.isEmpty) {
      AppFeedback.showSuccess(
        context,
        result.created.length == 1
            ? '1 contribution scheduled'
            : '${result.created.length} contributions scheduled',
      );
      context.pop();
      return;
    }

    // Some were skipped — show exactly what happened rather than a
    // generic success toast that would hide it. Every requested member
    // ends up in created or skipped, never silently dropped.
    if (!mounted) return;
    final members =
        ref.read(ledgerMembersProvider(widget.ledgerId)).valueOrNull ??
            const [];
    await showDialog<void>(
      context: context,
      builder: (context) => _BatchResultDialog(result: result, members: members),
    );
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(ledgerMembersProvider(widget.ledgerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Start a contribution round')),
      body: AppBackdrop(
        child: SafeArea(
          child: membersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                const Center(child: Text('Could not load ledger members.')),
            data: (members) {
              final activeMembers =
                  members.where((m) => m.status == 'ACTIVE').toList();
              final allUserIds = activeMembers.map((m) => m.userId).toList();
              final allSelected = _selectedUserIds.length == allUserIds.length &&
                  allUserIds.isNotEmpty;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      'Opens one contribution per selected member for the '
                      'date you pick — independent of any Circle. Works the '
                      'same whether this ledger has a Circle running or not.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AjopayColors.textSecondary,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        _cycleDate == null
                            ? 'Pick cycle date'
                            : _dateFormat.format(_cycleDate!),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.centerLeft,
                        side: const BorderSide(color: AjopayColors.border),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Members (${_selectedUserIds.length} of ${allUserIds.length} selected)',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        TextButton(
                          onPressed: allUserIds.isEmpty
                              ? null
                              : () => _toggleAll(allUserIds),
                          child: Text(allSelected ? 'Deselect all' : 'Select all'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: activeMembers.isEmpty
                        ? const Center(child: Text('No active members yet.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: activeMembers.length,
                            itemBuilder: (context, index) {
                              final member = activeMembers[index];
                              final selected =
                                  _selectedUserIds.contains(member.userId);
                              return CheckboxListTile(
                                value: selected,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      _selectedUserIds.add(member.userId);
                                    } else {
                                      _selectedUserIds.remove(member.userId);
                                    }
                                  });
                                },
                                title: Text(member.fullName),
                                subtitle: Text(member.role),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: AppPrimaryButton(
                      label: 'Schedule',
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting ? null : _submit,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BatchResultDialog extends StatelessWidget {
  const _BatchResultDialog({required this.result, required this.members});

  final BatchScheduleContributionResponse result;
  final List<LedgerMemberResponse> members;

  String _nameFor(String userId) {
    for (final member in members) {
      if (member.userId == userId) return member.fullName;
    }
    return userId; // fallback — should not normally happen
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Batch schedule complete'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.created.length == 1
                  ? '1 contribution scheduled.'
                  : '${result.created.length} contributions scheduled.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              '${result.skipped.length} skipped:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            for (final skipped in result.skipped)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '• ${_nameFor(skipped.memberUserId)} — ${skipped.reason}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}