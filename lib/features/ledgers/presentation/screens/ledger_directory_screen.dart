import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../application/ledger_controller.dart';
import '../../application/ledger_directory_pager.dart';
import '../../data/models/ledger_models.dart';

class LedgerDirectoryScreen extends ConsumerStatefulWidget {
  const LedgerDirectoryScreen({super.key});

  @override
  ConsumerState<LedgerDirectoryScreen> createState() =>
      _LedgerDirectoryScreenState();
}

class _LedgerDirectoryScreenState extends ConsumerState<LedgerDirectoryScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;
  String _activeSearch = '';
  DirectorySort _orderBy = DirectorySort.newest;

  LedgerDirectoryPagerKey get _key =>
      (search: _activeSearch, orderBy: _orderBy);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(ledgerDirectoryPagerProvider(_key).notifier).loadMore(_key);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _activeSearch = value.trim());
    });
  }

  void _openRatingSheet(LedgerDirectoryEntryResponse ledger) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _RateLedgerSheet(ledger: ledger),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageAsync = ref.watch(ledgerDirectoryPagerProvider(_key));

    return Scaffold(
      appBar: AppBar(title: const Text('Browse ledgers')),
      body: AppBackdrop(
        stops: const [0.0, 0.15],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search ledgers by name',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _debounce?.cancel();
                            setState(() => _activeSearch = '');
                          },
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _SortChip(
                      label: 'Newest',
                      icon: Icons.schedule,
                      selected: _orderBy == DirectorySort.newest,
                      onTap: () =>
                          setState(() => _orderBy = DirectorySort.newest),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SortChip(
                      label: 'Top rated',
                      icon: Icons.star_rounded,
                      selected: _orderBy == DirectorySort.topRated,
                      onTap: () =>
                          setState(() => _orderBy = DirectorySort.topRated),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: pageAsync.when(
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
                        const Text('Could not load the ledger directory.'),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => ref
                              .invalidate(ledgerDirectoryPagerProvider(_key)),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (pageState) {
                  if (pageState.loadMoreError != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      AppFeedback.showError(context, pageState.loadMoreError!);
                    });
                  }

                  if (pageState.items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.travel_explore_outlined,
                                size: 56, color: AjopayColors.primary),
                            const SizedBox(height: 16),
                            Text(
                              _activeSearch.isEmpty
                                  ? (_orderBy == DirectorySort.topRated
                                      ? 'No ledgers have enough ratings yet.'
                                      : 'No ledgers to show yet.')
                                  : 'No ledgers match "$_activeSearch".',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(ledgerDirectoryPagerProvider(_key).notifier)
                        .refresh(_key),
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount:
                          pageState.items.length + (pageState.hasMore ? 1 : 0),
                      separatorBuilder: (context, _) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (index >= pageState.items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _LedgerDirectoryTile(
                          ledger: pageState.items[index],
                          onTap: () => _openRatingSheet(pageState.items[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Newest/Top rated toggle chip — a simple selectable pill rather
/// than a SegmentedButton, matching this app's existing pill-shaped
/// button/chip language (AppPrimaryButton, ChipTheme) instead of
/// introducing Material's own segmented-control look for the first time
/// in one place.
class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AjopayColors.primaryTint : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AjopayColors.primary : AjopayColors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  selected ? AjopayColors.primaryDark : AjopayColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected
                        ? AjopayColors.primaryDark
                        : AjopayColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerDirectoryTile extends StatelessWidget {
  const _LedgerDirectoryTile({required this.ledger, required this.onTap});

  final LedgerDirectoryEntryResponse ledger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AjopayColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.savings_rounded,
                    color: AjopayColors.primaryDark),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ledger.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${ledger.contributionFrequency[0]}${ledger.contributionFrequency.substring(1).toLowerCase()} · ₦${ledger.contributionAmount.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AjopayColors.textMuted,
                          ),
                    ),
                    const SizedBox(height: 6),
                    StarRatingDisplay(
                      averageRating: ledger.averageRating,
                      ratingCount: ledger.ratingCount,
                      size: 14,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AjopayColors.goldTint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.star_rounded,
                    size: 18, color: AjopayColors.gold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RateLedgerSheet extends ConsumerStatefulWidget {
  const _RateLedgerSheet({required this.ledger});

  final LedgerDirectoryEntryResponse ledger;

  @override
  ConsumerState<_RateLedgerSheet> createState() => _RateLedgerSheetState();
}

class _RateLedgerSheetState extends ConsumerState<_RateLedgerSheet> {
  int? _selectedStars;
  bool _isSaving = false;

  Future<void> _save() async {
    final stars = _selectedStars;
    if (stars == null) return;

    setState(() => _isSaving = true);
    final ok = await ref
        .read(ledgerControllerProvider.notifier)
        .rateLedger(widget.ledger.id, stars);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      Navigator.of(context).pop();
      AppFeedback.showSuccess(context, 'Rating saved');
    } else {
      final message = ref.read(ledgerControllerProvider.notifier).lastError;
      AppFeedback.showError(context, message ?? 'Could not save your rating.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final myRatingAsync = ref.watch(myLedgerRatingProvider(widget.ledger.id));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: myRatingAsync.when(
          loading: () => const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => _buildContent(context, initialStars: null),
          data: (myRating) {
            // Seed the picker from the caller's existing rating exactly
            // once — never on a rebuild after they've already tapped a
            // star, or their in-progress selection would keep getting
            // clobbered back to whatever was originally fetched.
            _selectedStars ??= myRating?.stars;
            return _buildContent(context, initialStars: myRating?.stars);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required int? initialStars}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AjopayColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          widget.ledger.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        StarRatingDisplay(
          averageRating: widget.ledger.averageRating,
          ratingCount: widget.ledger.ratingCount,
        ),
        const SizedBox(height: 24),
        Text(
          initialStars != null ? 'Update your rating' : 'Rate this ledger',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        StarRatingInput(
          initialStars: _selectedStars,
          onChanged: (stars) => setState(() => _selectedStars = stars),
        ),
        const SizedBox(height: 24),
        AppPrimaryButton(
          label: initialStars != null ? 'Update rating' : 'Save rating',
          isLoading: _isSaving,
          onPressed: (_selectedStars == null || _isSaving) ? null : _save,
        ),
      ],
    );
  }
}
