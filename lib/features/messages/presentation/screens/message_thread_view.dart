import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';
import '../../../account/application/account_controller.dart';
import '../../../subscriptions/application/subscription_controller.dart';
import '../../application/message_thread_pager.dart';
import '../../data/message_repository.dart';
import '../../data/models/message_models.dart';

/// The shared chat UI — reversed message list + input bar. Used both
/// embedded in MessagesHomeScreen's Group tab and as the body of
/// PrivateMessageThreadScreen; only the `MessageThreadKey` and whether
/// avatars/sender names are shown differ between the two contexts.
class MessageThreadView extends ConsumerStatefulWidget {
  const MessageThreadView({
    super.key,
    required this.threadKey,
    required this.showSenderNames,
  });

  final MessageThreadKey threadKey;

  /// true for the group thread (multiple participants — names matter),
  /// false for a private thread (exactly two people, alignment alone
  /// already says who sent what).
  final bool showSenderNames;

  @override
  ConsumerState<MessageThreadView> createState() => _MessageThreadViewState();
}

class _MessageThreadViewState extends ConsumerState<MessageThreadView> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  bool _isSending = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Drives the composer's send-button enabled state without rebuilding
    // the whole screen on every keystroke — only _ComposerBar listens to
    // this via ValueListenableBuilder-equivalent (see build below).
    _inputController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _inputController.removeListener(_onTextChanged);
    _inputController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _inputController.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _onScroll() {
    // reverse: true means "near the top of the screen" (older history)
    // is expressed as approaching maxScrollExtent, not 0 — the opposite
    // of every other infinite-scroll list in this app.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref
          .read(messageThreadPagerProvider(widget.threadKey).notifier)
          .loadMoreOlder(widget.threadKey);
    }
  }

  Future<void> _send() async {
    final body = _inputController.text.trim();
    if (body.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      final sent = await ref.read(messageRepositoryProvider).sendMessage(
            widget.threadKey.ledgerId,
            recipientUserId: widget.threadKey.otherUserId,
            body: body,
          );
      // Optimistic insert — don't wait for the SSE echo, which arrives
      // a moment later and is de-duplicated by id when it does (see
      // MessageThreadPager.prependIncoming).
      ref
          .read(messageThreadPagerProvider(widget.threadKey).notifier)
          .prependIncoming(sent);
      _inputController.clear();
    } on ApiException catch (e) {
      if (!mounted) return;
      AppFeedback.showError(context, e.message);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageAsync = ref.watch(messageThreadPagerProvider(widget.threadKey));
    final profileAsync = ref.watch(accountControllerProvider);
    final myUserId = profileAsync.valueOrNull?.id;
    // Was: profileAsync.valueOrNull?.subscriptionTier == 'PREMIUM' — a
    // guessed field on the account profile that was never confirmed to
    // exist. Subscription status has its own dedicated endpoint
    // (GET /api/subscriptions/status) and its own controller; this was
    // wrong from when this screen was first written, before that existed.
    final subscriptionAsync = ref.watch(subscriptionControllerProvider);
    final isPremium = subscriptionAsync.valueOrNull?.isPremium ?? false;

    return Column(
      children: [
        Expanded(
          child: AppBackdrop(
            stops: const [0.0, 0.12],
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
                      const Text('Could not load this conversation.'),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => ref.invalidate(
                            messageThreadPagerProvider(widget.threadKey)),
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
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: AjopayColors.primaryTint,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chat_bubble_outline_rounded,
                                size: 32, color: AjopayColors.primaryDark),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Say hello and start the conversation.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AjopayColors.textMuted,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final items = pageState.items;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  // Perf: the list can grow at either end (older pages
                  // appended at the tail, live messages prepended at the
                  // head via SSE/optimistic-send) — a plain index-based
                  // ListView.builder would let Flutter reuse elements
                  // across the wrong messages when that happens, causing
                  // visible flicker/incorrect state on a chat screen
                  // people scroll constantly. Keying each row by the
                  // message's own id fixes that at negligible cost.
                  itemCount: items.length + (pageState.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    final message = items[index];
                    final isMine = message.senderId == myUserId;

                    // The OLDER neighbor in time (higher index, since
                    // items are newest-first) — used both for the date
                    // separator (does the day change here?) and for
                    // whether to repeat the sender's name (is this a new
                    // run, or a continuation of the same sender?).
                    final olderNeighbor =
                        index + 1 < items.length ? items[index + 1] : null;
                    final isFirstOfDay = olderNeighbor == null ||
                        !_isSameDay(olderNeighbor.sentAt, message.sentAt);
                    final isFirstOfRun = olderNeighbor == null ||
                        olderNeighbor.senderId != message.senderId ||
                        isFirstOfDay;
                    // The NEWER neighbor (lower index) — whether this
                    // bubble is the last one in its run, which is what
                    // should carry the tight "tail" corner. Without this,
                    // every bubble in a multi-message run gets a tail,
                    // which is the visual noise real chat apps avoid.
                    final newerNeighbor = index > 0 ? items[index - 1] : null;
                    final isLastOfRun = newerNeighbor == null ||
                        newerNeighbor.senderId != message.senderId ||
                        !_isSameDay(message.sentAt, newerNeighbor.sentAt);

                    return RepaintBoundary(
                      key: ValueKey(message.id),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isFirstOfDay)
                            _DateSeparator(sentAt: message.sentAt),
                          _MessageBubble(
                            message: message,
                            isMine: isMine,
                            showSenderName: widget.showSenderNames &&
                                !isMine &&
                                isFirstOfRun,
                            showTail: isLastOfRun,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        _ComposerBar(
          controller: _inputController,
          isSending: _isSending,
          isPremium: isPremium,
          canSend: _hasText,
          onSend: _send,
        ),
      ],
    );
  }

  bool _isSameDay(String a, String b) {
    final dateA = DateTime.tryParse(a)?.toLocal();
    final dateB = DateTime.tryParse(b)?.toLocal();
    if (dateA == null || dateB == null) return false;
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }
}

// Perf: `DateFormat` does non-trivial locale setup internally — hoisted
// out of the per-bubble/per-separator getters below so it's built once
// per app run instead of once per widget per rebuild. On a screen that
// re-renders on every incoming SSE message, that's the difference
// between "once" and "constantly."
final _timeFormat = DateFormat('h:mm a');
final _dateFormat = DateFormat('MMM d, yyyy');

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.sentAt});

  final String sentAt;

  String get _label {
    final date = DateTime.tryParse(sentAt)?.toLocal();
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return _dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AjopayColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.showSenderName,
    required this.showTail,
  });

  final MessageResponse message;
  final bool isMine;
  final bool showSenderName;

  /// Only the last bubble in a consecutive run from the same sender gets
  /// the tight "tail" corner — every other bubble in the run is fully
  /// rounded on both bottom corners, same convention as iMessage/WhatsApp.
  /// Cuts visual noise on a screen where people send multi-message bursts
  /// constantly.
  final bool showTail;

  String get _initials {
    final parts = message.senderFullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  String get _time {
    final date = DateTime.tryParse(message.sentAt)?.toLocal();
    if (date == null) return '';
    return _timeFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final tailRadius = const Radius.circular(4);
    final roundRadius = const Radius.circular(18);

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.74,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: isMine
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AjopayColors.primary, AjopayColors.primaryDark],
              )
            : null,
        color: isMine ? null : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: roundRadius,
          topRight: roundRadius,
          bottomLeft: isMine || !showTail ? roundRadius : tailRadius,
          bottomRight: isMine && showTail ? tailRadius : roundRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: (isMine ? AjopayColors.primary : Colors.black)
                .withValues(alpha: isMine ? 0.18 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSenderName)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                message.senderFullName,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AjopayColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          Text(
            message.body,
            style: TextStyle(
              color: isMine ? Colors.white : AjopayColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            _time,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isMine
                      ? Colors.white.withValues(alpha: 0.75)
                      : AjopayColors.textMuted,
                  fontSize: 10.5,
                ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: 2,
        bottom: showTail ? 6 : 2,
      ),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            // Reserve the avatar's width even when it's hidden (not the
            // last bubble in a run), so every bubble in the run still
            // lines up under the one that does show an avatar — the
            // same layout trick real chat apps use.
            SizedBox(
              width: 28,
              child: showTail
                  ? CircleAvatar(
                      radius: 14,
                      backgroundColor: AjopayColors.primaryTint,
                      child: Text(
                        _initials,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AjopayColors.primaryDark,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(child: bubble),
        ],
      ),
    );
  }
}

/// The input bar — swapped for an upsell banner when the caller isn't
/// Premium, per API.md/MessageService: sending is Premium-gated,
/// reading never is. Thread history stays fully visible either way;
/// only the ability to compose is affected.
class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.controller,
    required this.isSending,
    required this.isPremium,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final bool isPremium;

  /// Whether the input currently has non-whitespace text — drives the
  /// send button's enabled/visual state without needing a full
  /// setState-per-keystroke rebuild of the whole thread view.
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    if (!isPremium) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AjopayColors.goldTint,
          border: Border(
            top: BorderSide(color: AjopayColors.border),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: AjopayColors.gold, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Sending messages is a Premium feature.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AjopayColors.textPrimary,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AjopayColors.primaryDark,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => context.push('/subscription'),
                child: const Text('Upgrade',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AjopayColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AjopayColors.border),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 15.5),
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: AjopayColors.textMuted),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: canSend
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AjopayColors.primary,
                          AjopayColors.primaryDark
                        ],
                      )
                    : null,
                color: canSend ? null : AjopayColors.border,
                boxShadow: canSend
                    ? [
                        BoxShadow(
                          color: AjopayColors.primary.withValues(alpha: 0.32),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: (isSending || !canSend) ? null : onSend,
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(
                            Icons.arrow_upward_rounded,
                            color:
                                canSend ? Colors.white : AjopayColors.textMuted,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
