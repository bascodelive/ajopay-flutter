import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../application/ledger_reviews_pager.dart';
import '../../data/models/ledger_models.dart';

class LedgerReviewsScreen extends ConsumerStatefulWidget {
  const LedgerReviewsScreen({super.key, required this.ledgerId});

  final String ledgerId;

  @override
  ConsumerState<LedgerReviewsScreen> createState() =>
      _LedgerReviewsScreenState();
}

class _LedgerReviewsScreenState extends ConsumerState<LedgerReviewsScreen> {
  final _scrollController = ScrollController();

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref
          .read(ledgerReviewsPagerProvider(widget.ledgerId).notifier)
          .loadMore(widget.ledgerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageAsync = ref.watch(ledgerReviewsPagerProvider(widget.ledgerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: AppBackdrop(
        stops: const [0.0, 0.15],
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
                  const Text('Could not load reviews.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(
                        ledgerReviewsPagerProvider(widget.ledgerId)),
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
                      const Icon(Icons.rate_review_outlined,
                          size: 56, color: AjopayColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        'No written reviews yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ratings without a comment don\'t show up here — '
                        'only ones with something written.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AjopayColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => ref
                  .read(ledgerReviewsPagerProvider(widget.ledgerId).notifier)
                  .refresh(widget.ledgerId),
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: pageState.items.length + (pageState.hasMore ? 1 : 0),
                separatorBuilder: (context, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index >= pageState.items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _ReviewTile(review: pageState.items[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final LedgerReviewResponse review;

  String get _initials {
    final parts = review.reviewerFullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(review.createdAt)?.toLocal();
    final dateLabel = date == null
        ? ''
        : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AjopayColors.gold.withValues(alpha: 0.18),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: AjopayColors.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerFullName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      // Reuses StarRatingDisplay for a single review's
                      // whole-number rating (passed as a 1-item
                      // "average") rather than a third star widget —
                      // no rounding ambiguity on a whole int, so it
                      // renders identically to a dedicated one would.
                      StarRatingDisplay(
                        averageRating: review.stars.toDouble(),
                        ratingCount: 1,
                        size: 14,
                        showCount: false,
                      ),
                    ],
                  ),
                ),
                if (dateLabel.isNotEmpty)
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AjopayColors.textMuted,
                        ),
                  ),
              ],
            ),
            if (review.reviewText != null && review.reviewText!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                review.reviewText!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
