import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/contribution_action_controller.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');

class ScheduleContributionScreen extends ConsumerStatefulWidget {
  const ScheduleContributionScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  ConsumerState<ScheduleContributionScreen> createState() =>
      _ScheduleContributionScreenState();
}

class _ScheduleContributionScreenState
    extends ConsumerState<ScheduleContributionScreen> {
  String? _selectedUserId;
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

  Future<void> _submit() async {
    final userId = _selectedUserId;
    final cycleDate = _cycleDate;
    if (userId == null) {
      AppFeedback.showInfo(context, 'Pick a member first');
      return;
    }
    if (cycleDate == null) {
      AppFeedback.showInfo(context, 'Pick a cycle date first');
      return;
    }

    setState(() => _isSubmitting = true);
    final result =
        await ref.read(contributionActionControllerProvider.notifier).schedule(
              widget.ledgerId,
              userId,
              _dateFormat.format(cycleDate),
            );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      AppFeedback.showSuccess(context, 'Contribution scheduled');
      context.pop();
    } else {
      final message =
          ref.read(contributionActionControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not schedule contribution.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(ledgerMembersProvider(widget.ledgerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule contribution')),
      body: AppBackdrop(
        child: SafeArea(
          child: membersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                const Center(child: Text('Could not load ledger members.')),
            data: (members) {
              final activeMembers =
                  members.where((m) => m.status == 'ACTIVE').toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AjopayColors.primaryTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.event_available_outlined,
                          color: AjopayColors.primaryDark, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Open a pending contribution for one member\'s cycle.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AjopayColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              initialValue: _selectedUserId,
                              decoration: const InputDecoration(
                                labelText: 'Member',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              items: activeMembers
                                  .map((m) => DropdownMenuItem(
                                        value: m.userId,
                                        child: Text(m.fullName),
                                      ))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedUserId = value),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_today_outlined),
                              label: Text(
                                _cycleDate == null
                                    ? 'Pick cycle date'
                                    : _dateFormat.format(_cycleDate!),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                alignment: Alignment.centerLeft,
                                side: const BorderSide(
                                    color: AjopayColors.border),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppPrimaryButton(
                      label: 'Schedule',
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting ? null : _submit,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
