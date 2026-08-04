import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../application/subscription_controller.dart';
import '../../data/models/subscription_models.dart';

final _dateFormat = DateFormat('MMM d, yyyy');

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen>
    with WidgetsBindingObserver {
  bool _isStartingCheckout = false;

  /// True from the moment checkout is opened until either payment is
  /// confirmed or the bounded poll below gives up — drives the "waiting
  /// for confirmation" state in the UI.
  bool _isAwaitingConfirmation = false;
  Timer? _pollTimer;
  int _pollAttempts = 0;

  // The backend doesn't set a callback_url when initializing the
  // Paystack transaction (confirmed against the real
  // SubscriptionService.initiateUpgrade), so there's no redirect back
  // into the app to catch — polling on a timer, plus on app-resume
  // below, is the only way to find out payment finished without the
  // person manually tapping refresh.
  static const _pollInterval = Duration(seconds: 4);
  static const _maxPollAttempts = 15; // ~60 seconds

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The person switched back into the app — almost certainly right
    // after finishing (or abandoning) checkout in the browser. Worth an
    // immediate check regardless of where the timed poll below is.
    if (state == AppLifecycleState.resumed && _isAwaitingConfirmation) {
      _checkStatusOnce();
    }
  }

  Future<void> _startUpgrade() async {
    setState(() => _isStartingCheckout = true);
    final result =
        await ref.read(subscriptionControllerProvider.notifier).upgrade();
    if (!mounted) return;
    setState(() => _isStartingCheckout = false);

    if (result == null) {
      final message =
          ref.read(subscriptionControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not start checkout. Please try again.');
      return;
    }

    final uri = Uri.tryParse(result.checkoutUrl);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      AppFeedback.showError(context, 'Could not open the checkout page.');
      return;
    }

    setState(() {
      _isAwaitingConfirmation = true;
      _pollAttempts = 0;
    });
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _checkStatusOnce());
  }

  Future<void> _checkStatusOnce() async {
    if (!_isAwaitingConfirmation) return;

    _pollAttempts++;
    await ref.read(subscriptionControllerProvider.notifier).refresh();
    if (!mounted) return;

    final isPremium =
        ref.read(subscriptionControllerProvider).valueOrNull?.isPremium ??
            false;

    if (isPremium) {
      _pollTimer?.cancel();
      setState(() => _isAwaitingConfirmation = false);
      AppFeedback.showSuccess(context, "You're Premium now — welcome!");
      return;
    }

    if (_pollAttempts >= _maxPollAttempts) {
      _pollTimer?.cancel();
      setState(() => _isAwaitingConfirmation = false);
      // Not a failure — payment confirmation is genuinely async
      // (webhook-driven) and can lag behind checkout completing.
      // Nothing wrong happened; just stop guessing on a timer and let
      // the person check back manually.
      AppFeedback.showInfo(
        context,
        "Still processing — this can take a minute. Pull down to check "
        "again if it doesn't update shortly.",
      );
    }
  }

  Future<void> _manualRefresh() async {
    await ref.read(subscriptionControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(subscriptionControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: AppBackdrop(
        child: RefreshIndicator(
          onRefresh: _manualRefresh,
          child: statusAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AjopayColors.error),
                      const SizedBox(height: 12),
                      const Text('Could not load subscription status.'),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () =>
                            ref.invalidate(subscriptionControllerProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            data: (status) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                if (status.isPremium)
                  _PremiumStatusCard(status: status)
                else
                  _FreeStatusCard(
                    isAwaitingConfirmation: _isAwaitingConfirmation,
                    isStartingCheckout: _isStartingCheckout,
                    onUpgrade: _startUpgrade,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumStatusCard extends StatelessWidget {
  const _PremiumStatusCard({required this.status});

  final SubscriptionStatusResponse status;

  @override
  Widget build(BuildContext context) {
    final expiresAt = status.expiresAt;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
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
              "You're Premium",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (expiresAt != null) ...[
              const SizedBox(height: 6),
              Text(
                'Renews/expires ${_dateFormat.format(expiresAt)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AjopayColors.textSecondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FreeStatusCard extends StatelessWidget {
  const _FreeStatusCard({
    required this.isAwaitingConfirmation,
    required this.isStartingCheckout,
    required this.onUpgrade,
  });

  final bool isAwaitingConfirmation;
  final bool isStartingCheckout;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
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
              child: const Icon(Icons.workspace_premium_outlined,
                  color: AjopayColors.primaryDark, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Upgrade to Premium',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            const _BenefitRow(text: 'Send messages in your ledgers'),
            const _BenefitRow(text: 'Create or join more than one ledger'),
            const SizedBox(height: 24),
            if (isAwaitingConfirmation) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Waiting for payment confirmation…'),
                    ],
                  ),
                ),
              ),
            ] else
              AppPrimaryButton(
                label: 'Upgrade to Premium',
                isLoading: isStartingCheckout,
                onPressed: isStartingCheckout ? null : onUpgrade,
              ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AjopayColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
