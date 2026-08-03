import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/message_stream_controller.dart';
import '../../application/message_thread_pager.dart';
import 'message_thread_view.dart';

class PrivateMessageThreadScreen extends ConsumerStatefulWidget {
  const PrivateMessageThreadScreen({
    super.key,
    required this.ledgerId,
    required this.otherUserId,
    required this.otherUserFullName,
  });

  final String ledgerId;
  final String otherUserId;

  /// Passed via go_router's `extra` from the Direct tab's member list —
  /// there's no "get one member by id" endpoint, so this is the only
  /// way this screen knows who it's showing without an extra fetch.
  final String otherUserFullName;

  @override
  ConsumerState<PrivateMessageThreadScreen> createState() =>
      _PrivateMessageThreadScreenState();
}

class _PrivateMessageThreadScreenState
    extends ConsumerState<PrivateMessageThreadScreen> {
  @override
  void initState() {
    super.initState();
    // Idempotent — MessagesHomeScreen (the screen this is always pushed
    // from today) already opened this ledger's one shared connection;
    // this call is a no-op in that case. Harmless safety net if this
    // screen is ever reached another way later (e.g. a future deep
    // link straight into a specific conversation).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messageStreamControllerProvider.notifier)
          .connect(widget.ledgerId);
    });
  }

  String get _initials {
    final parts = widget.otherUserFullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                _initials,
                style: const TextStyle(
                  color: AjopayColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.otherUserFullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: MessageThreadView(
        threadKey: (
          ledgerId: widget.ledgerId,
          type: MessageThreadType.private,
          otherUserId: widget.otherUserId,
        ),
        showSenderNames: false,
      ),
    );
  }
}
