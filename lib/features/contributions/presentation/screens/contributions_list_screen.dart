import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
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
      body: tabCount > 1
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

    return pageAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AjopayColors.error),
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

        final banner = (showGenerateBanner && isCircleActive)
            ? _GenerateCycleBanner(
                ledgerId: widget.ledgerId,
                circleId: circleAsync!.value!.id,
              )
            : null;

        if (pageState.items.isEmpty) {
          return Column(
            children: [
              if (banner != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: banner,
                ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.scope == ContributionScope.all
                        ? 'No contributions scheduled yet.'
                        : 'You have no contributions yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
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
            itemCount: (banner != null ? 1 : 0) +
                pageState.items.length +
                (pageState.hasMore ? 1 : 0),
            separatorBuilder: (context, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              var i = index;
              if (banner != null) {
                if (i == 0) return banner;
                i -= 1;
              }
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
  const _GenerateCycleBanner({required this.ledgerId, required this.circleId});

  final String ledgerId;
  final String circleId;

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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AjopayColors.primaryTint,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, color: AjopayColors.primaryDark),
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
                    'Open this cycle\'s contributions for its participants.',
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
                : TextButton(
                    onPressed: _generate,
                    child: const Text('Generate'),
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
        return Colors.black45;
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
      child: ListTile(
        leading: Icon(_statusIcon, color: _statusColor),
        title: Text(contribution.memberFullName),
        subtitle: Text(subtitle),
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
        onTap: () => context.push(
          '/ledgers/$ledgerId/contributions/${contribution.id}',
          extra: contribution,
        ),
      ),
    );
  }
}
