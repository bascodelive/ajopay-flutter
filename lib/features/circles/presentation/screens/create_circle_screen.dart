import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../application/circle_controller.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');

class CreateCircleScreen extends ConsumerStatefulWidget {
  const CreateCircleScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  ConsumerState<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends ConsumerState<CreateCircleScreen> {
  DateTime? _startDate;
  bool _isSubmitting = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _submit() async {
    final startDate = _startDate;
    if (startDate == null) {
      AppFeedback.showInfo(context, 'Pick a start date first');
      return;
    }

    setState(() => _isSubmitting = true);
    final circle = await ref.read(circleControllerProvider.notifier).create(
          widget.ledgerId,
          _dateFormat.format(startDate),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (circle != null) {
      ref.invalidate(currentCircleProvider(widget.ledgerId));
      if (!mounted) return;
      context.pushReplacement('/ledgers/${widget.ledgerId}/circle');
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not start circle. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start a circle')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'When does this rotation start?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ll add participants and set the payout order next — '
                'the end date is calculated automatically once the rotation '
                'is set and the circle starts, based on how many hands are '
                'in it.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  _startDate == null
                      ? 'Pick a start date'
                      : _dateFormat.format(_startDate!),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Start circle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
