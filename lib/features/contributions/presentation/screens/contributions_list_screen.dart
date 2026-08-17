import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../circles/application/circle_controller.dart';
import '../../../ledgers/application/ledger_controller.dart';
import '../../application/contributions_pager.dart';
import '../../data/models/contribution_models.dart';

class ContributionsListScreen extends ConsumerStatefulWidget {
  const ContributionsListScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  ConsumerState<ContributionsListScreen> createState() =>
      _ContributionsListScreenState();
}

class _ContributionsListScreenState
    extends ConsumerState<ContributionsListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ledgerAsync = ref.watch(ledgerDetailProvider(widget.ledgerId));
    final isAdmin = ledgerAsync.valueOrNull?.callerRole == 'ADMIN';

    // Tab count depends on role — only build the controller once we
    // actually know it, and rebuild it if role becomes known later
    // (e.g. ledger data was still loading on first build).
    final tabCount = isAdmin ? 2 : 1;
    if (_tabController == null || _tabController!.length != tabCount) {
      _tabController?.dispose();
      _tabController = TabController(length: tabCount, vsync: this);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contributions'),
        bottom: tabCount > 1
            ? TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [Tab(text: 'All'), Tab(text: 'Mine')],
              )
            : null,
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context
                  .push('/ledgers/${widget.ledgerId}/contributions/schedule'),
            ),
        ],
      ),
      body: AppBackdrop(
        stops: const [0.0, 0.15],
        child: tabCount > 1
            ? TabBarView(
                controller: _tabController,
                children: [
                  _ContributionsListView(
                    ledgerId: widget.ledgerId,
                    scope: ContributionScope.all,
                    isAdmin: isAdmin,
                  ),
                  _ContributionsListView(
                    ledgerId: widget.ledgerId,
                    scope: ContributionScope.own,
                    isAdmin: isAdmin,
                  ),
                ],
              )
            : _ContributionsListView(
                ledgerId: widget.ledgerId,
                scope: ContributionScope.own,
                isAdmin: isAdmin,
              ),
      ),
    );
  }
}

class _ContributionsListView extends ConsumerStatefulWidget {
  const _ContributionsListView({
    required this.ledgerId,
    required this.scope,
    required this.isAdmin,
  });

  final String ledgerId;
  final ContributionScope scope;
  final bool isAdmin;

  @override
  ConsumerState<_ContributionsListView> createState() =>
      _ContributionsListViewState();
}

class _ContributionsListViewState
    extends ConsumerState<_ContributionsListView> {
  final _scrollController = ScrollController();

  ContributionsPagerKey get _key =>
      (ledgerId: widget.ledgerId, scope: widget.scope);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger the next page a bit before actually hitting the bottom,
    // for a smoother feel. Safe to call repeatedly while scrolling near
    // the threshold — ContributionsPager.loadMore() guards against
    // concurrent/duplicate fetches internally.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(contributionsPagerProvider(_key).notifier).loadMore(_key);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageAsync = ref.watch(contributionsPagerProvider(_key));

    // The generate-cycle banner is Admin-only and only ever makes sense
    // on the "All" tab — a plain member on "Mine" has no generate action
    // available server-side either. Only watch the circle at all here
    // (rather than always, for every viewer) to avoid a pointless fetch
    // for the common case (non-admin, or the Mine tab).
    final showGenerateBanner =
        widget.isAdmin && widget.scope == ContributionScope.all;
    final circleAsync = showGenerateBanner
        ? ref.watch(currentCircleProvider(widget.ledgerId))
        : null;
    final isCircleActive = circleAsync?.valueOrNull?.status == 'ACTIVE';

    // Same proactive-disable signal circle_home_screen's own Generate
    // button uses — only fetched once we already know there's an ACTIVE
    // circle to check against. Without this the banner stayed tappable
    // forever and just surfaced the backend's 400 after the fact.
    final payoutAsync = isCircleActive
        ? ref.watch(currentPayoutProvider(
            (ledgerId: widget.ledgerId, circleId: circleAsync!.value!.id)))
        : null;
    final alreadyGenerated =
        payoutAsync?.valueOrNull?.alreadyGeneratedThisCycle ?? false;
    final noPendingSlot = payoutAsync != null &&
        payoutAsync.hasError &&
        payoutAsync.error is ApiException &&
        (payoutAsync.error as ApiException).isNotFound;

    return pageAsync.when(
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
              const Text('Could not load contributions.'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () =>
                    ref.invalidate(contributionsPagerProvider(_key)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (pageState) {
        // Surface a load-more failure once, without blocking the
        // already-loaded list behind it.
        if (pageState.loadMoreError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            AppFeedback.showError(context, pageState.loadMoreError!);
          });
        }

        final circleBanner = (showGenerateBanner && isCircleActive)
            ? _GenerateCycleBanner(
                ledgerId: widget.ledgerId,
                circleId: circleAsync!.value!.id,
                alreadyGenerated: alreadyGenerated,
                noPendingSlot: noPendingSlot,
              )
            : null;
        // Independent of circle state entirely — deliberately always
        // available to an Admin, circle or no circle, PENDING/ACTIVE/
        // COMPLETED alike. ContributionService.scheduleContribution has
        // no circle-awareness at all (see backend design decision), so
        // this action never needs to check circle status to decide
        // whether to show itself.
        final scheduleBanner = showGenerateBanner
            ? _ScheduleContributionBanner(ledgerId: widget.ledgerId)
            : null;
        final banners = [
          if (circleBanner != null) circleBanner,
          if (scheduleBanner != null) scheduleBanner,
        ];

        if (pageState.items.isEmpty) {
          return Column(
            children: [
              if (banners.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      for (final b in banners) ...[
                        b,
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.receipt_long_outlined,
                            size: 48, color: AjopayColors.primary),
                        const SizedBox(height: 12),
                        Text(
                          widget.scope == ContributionScope.all
                              ? 'No contributions scheduled yet.'
                              : 'You have no contributions yet.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AjopayColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(contributionsPagerProvider(_key).notifier).refresh(_key),
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: banners.length +
                pageState.items.length +
                (pageState.hasMore ? 1 : 0),
            separatorBuilder: (context, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              var i = index;
              if (i < banners.length) return banners[i];
              i -= banners.length;
              if (i >= pageState.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _ContributionTile(
                ledgerId: widget.ledgerId,
                contribution: pageState.items[i],
              );
            },
          ),
        );
      },
    );
  }
}

/// Admin-only nudge shown at the top of the "All" tab whenever the ledger
/// has an ACTIVE circle — lets an Admin open this cycle's contributions
/// right from where they'd naturally look for them, instead of only from
/// the Circle tab. The backend itself already guards against double
/// generation (400 if this cycle's rows already exist), so this stays
/// safely visible even after generating — a repeat tap just surfaces
/// that friendly error rather than doing anything harmful.
class _GenerateCycleBanner extends ConsumerStatefulWidget {
  const _GenerateCycleBanner({
    required this.ledgerId,
    required this.circleId,
    required this.alreadyGenerated,
    required this.noPendingSlot,
  });

  final String ledgerId;
  final String circleId;
  final bool alreadyGenerated;
  final bool noPendingSlot;

  @override
  ConsumerState<_GenerateCycleBanner> createState() =>
      _GenerateCycleBannerState();
}

class _GenerateCycleBannerState extends ConsumerState<_GenerateCycleBanner> {
  bool _isGenerating = false;

  Future<void> _generate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate this cycle\'s contributions?'),
        content: const Text(
          'Creates one contribution row per hand, for every participant, '
          'for whichever cycle is next due. This can only be done once '
          'per cycle.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _isGenerating = true);
    final created = await ref
        .read(circleControllerProvider.notifier)
        .generateCycleContributions(widget.ledgerId, widget.circleId);

    if (!mounted) return;
    setState(() => _isGenerating = false);

    if (created != null) {
      AppFeedback.showSuccess(
        context,
        created.length == 1
            ? '1 contribution generated for this cycle'
            : '${created.length} contributions generated for this cycle',
      );
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(
        context,
        message ??
            'Could not generate contributions for this cycle — it may '
                'already have been done.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate =
        !_isGenerating && !widget.alreadyGenerated && !widget.noPendingSlot;
    final subtitle = widget.alreadyGenerated
        ? 'Already generated for this cycle.'
        : widget.noPendingSlot
            ? 'Every hand in this circle has been paid — nothing left to generate.'
            : 'Open this cycle\'s contributions for its participants.';
    final buttonLabel = widget.alreadyGenerated
        ? 'Done'
        : widget.noPendingSlot
            ? 'Done'
            : 'Generate';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AjopayColors.primaryTint,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.alreadyGenerated || widget.noPendingSlot
                    ? Icons.check_circle_outline
                    : Icons.receipt_long_outlined,
                color: AjopayColors.primaryDark,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This ledger has an active circle',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AjopayColors.primaryDark,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AjopayColors.primaryDark,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _isGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : SizedBox(
                    width: 96,
                    child: AppPrimaryButton(
                      label: buttonLabel,
                      height: 36,
                      onPressed: canGenerate ? _generate : null,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

/// Independent of any circle — the plain, per-member scheduling path
/// (ContributionService.scheduleContribution has no circle-awareness at
/// all by design; see the earlier decoupling work). Always visible to
/// an Admin regardless of whether this ledger has a circle at all, or
/// what state it's in. Previously the only way to reach this was a bare
/// `+` icon in the AppBar — easy to miss, and gave no indication this
/// path exists independently of the circle banner above it.
class _ScheduleContributionBanner extends StatelessWidget {
  const _ScheduleContributionBanner({required this.ledgerId});

  final String ledgerId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AjopayColors.primaryTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.event_available_outlined,
                  color: AjopayColors.primaryDark, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule a contribution',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    'Open a one-off contribution for a member\'s cycle — '
                    'works with or without a circle.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AjopayColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 96,
              child: OutlinedButton(
                onPressed: () =>
                    context.push('/ledgers/$ledgerId/contributions/schedule'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContributionTile extends StatelessWidget {
  const _ContributionTile({required this.ledgerId, required this.contribution});

  final String ledgerId;
  final ContributionResponse contribution;

  Color get _statusColor {
    switch (contribution.status) {
      case 'PAID':
        return AjopayColors.primary;
      case 'MISSED':
        return AjopayColors.error;
      case 'REPORTED':
        return AjopayColors.gold;
      default:
        return AjopayColors.textMuted;
    }
  }

  IconData get _statusIcon {
    switch (contribution.status) {
      case 'PAID':
        return Icons.check_circle;
      case 'MISSED':
        return Icons.error;
      case 'REPORTED':
        return Icons.hourglass_top;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only surfaced for a multi-hand (circle-generated) contribution — a
    // handNumber of 1 (the vast majority of rows) is the unlabeled
    // default and needs no callout.
    final subtitle = contribution.handNumber > 1
        ? '${contribution.cycleDate} · ₦${contribution.amount.toStringAsFixed(0)} · Hand ${contribution.handNumber}'
        : '${contribution.cycleDate} · ₦${contribution.amount.toStringAsFixed(0)}';

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(
          '/ledgers/$ledgerId/contributions/${contribution.id}',
          extra: contribution,
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 20),
          ),
          title: Text(contribution.memberFullName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle,
              style: const TextStyle(color: AjopayColors.textMuted)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              contribution.status,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
