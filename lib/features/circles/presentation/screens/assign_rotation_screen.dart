import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../application/circle_controller.dart';
import '../../data/models/circle_models.dart';

/// One draggable row = one hand. A 2-hand participant appears as two
/// separate entries. `_localKey` is purely a stable Flutter Key for
/// ReorderableListView during drag interaction — it's never sent to the
/// backend, which only cares about the final ordered list of userIds
/// (API.md: "a 2-hand participant's ID appears TWICE, once per hand").
class _HandEntry {
  _HandEntry(
      {required this.userId,
      required this.userFullName,
      required this.localKey});

  final String userId;
  final String userFullName;
  final String localKey;
}

class AssignRotationScreen extends ConsumerStatefulWidget {
  const AssignRotationScreen({
    super.key,
    required this.ledgerId,
    required this.circleId,
  });

  final String ledgerId;
  final String circleId;

  @override
  ConsumerState<AssignRotationScreen> createState() =>
      _AssignRotationScreenState();
}

class _AssignRotationScreenState extends ConsumerState<AssignRotationScreen> {
  List<_HandEntry>? _hands;
  bool _isSubmitting = false;

  /// Builds the default declaration-order hand list — one entry per hand,
  /// in the order participants were added.
  List<_HandEntry> _buildFromParticipants(
      List<CircleParticipantResponse> participants) {
    final entries = <_HandEntry>[];
    for (final p in participants) {
      for (var hand = 0; hand < p.handCount; hand++) {
        entries.add(_HandEntry(
          userId: p.userId,
          userFullName: p.userFullName,
          localKey: '${p.userId}#$hand',
        ));
      }
    }
    return entries;
  }

  List<_HandEntry> _buildFromExistingRotation(
    List<RotationSlotResponse> slots,
    List<CircleParticipantResponse> currentParticipants,
  ) {
    // Reconciliation, not blind trust — the backend does NOT automatically
    // invalidate/re-sync rotation slots when participants or hand counts
    // change after assignRotation is called (documented limitation in
    // CircleService's own Javadoc). Without this, a removed participant
    // stays visible here, gets dragged around, and the eventual save
    // fails with a 400 the screen can't explain cleanly. So: reconcile
    // against the CURRENT participant list every time, not just once.
    final currentByUserId = {for (final p in currentParticipants) p.userId: p};

    final ordered = [...slots]
      ..sort((a, b) => a.position.compareTo(b.position));
    final reconciled = <_HandEntry>[];
    final keptCountByUser = <String, int>{};

    // Keep existing hands, in their existing order, but ONLY for users
    // who are still actual participants, and only up to their CURRENT
    // declared hand count (in case it was reduced).
    for (final slot in ordered) {
      final participant = currentByUserId[slot.userId];
      if (participant == null) continue; // no longer a participant — drop
      final keptSoFar = keptCountByUser[slot.userId] ?? 0;
      if (keptSoFar >= participant.handCount) {
        continue; // hand count reduced — drop excess
      }
      keptCountByUser[slot.userId] = keptSoFar + 1;
      reconciled.add(_HandEntry(
        userId: slot.userId,
        userFullName: slot.userFullName,
        localKey: slot.id,
      ));
    }

    // Append hands for anyone under-represented — either a brand-new
    // participant since the rotation was last saved, or an existing one
    // whose hand count increased.
    for (final participant in currentParticipants) {
      final keptSoFar = keptCountByUser[participant.userId] ?? 0;
      for (var i = keptSoFar; i < participant.handCount; i++) {
        reconciled.add(_HandEntry(
          userId: participant.userId,
          userFullName: participant.userFullName,
          localKey: '${participant.userId}#new$i',
        ));
      }
    }

    return reconciled;
  }

  Future<void> _submit() async {
    final hands = _hands;
    if (hands == null || hands.isEmpty) return;

    setState(() => _isSubmitting = true);
    final ok = await ref.read(circleControllerProvider.notifier).assignRotation(
          widget.ledgerId,
          widget.circleId,
          hands.map((h) => h.userId).toList(),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ok) {
      AppFeedback.showSuccess(context, 'Rotation order saved');
      context.pop();
    } else {
      final message = ref.read(circleControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not save rotation order.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = (ledgerId: widget.ledgerId, circleId: widget.circleId);
    final participantsAsync = ref.watch(circleParticipantsProvider(key));
    final rotationAsync = ref.watch(circleRotationProvider(key));

    return Scaffold(
      appBar: AppBar(title: const Text('Assign rotation')),
      body: participantsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: AjopayColors.error),
                SizedBox(height: 12),
                Text('Could not load participants.'),
              ],
            ),
          ),
        ),
        data: (participants) {
          if (participants.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Add participants first — there\'s nothing to order yet.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          // Seed _hands exactly ONCE, from whichever source is correct,
          // only after BOTH participants and rotation status are known —
          // never re-seed afterward, so a later-arriving response can
          // never clobber an in-progress drag reorder.
          if (_hands == null) {
            if (rotationAsync.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final existingRotation = rotationAsync.valueOrNull;
            if (existingRotation != null && existingRotation.isNotEmpty) {
              final reconciled =
                  _buildFromExistingRotation(existingRotation, participants);
              _hands = reconciled;
              // Detect whether reconciliation actually changed anything
              // (a removed participant dropped, a hand count changed) so
              // the Admin is told — not left to silently wonder why the
              // order looks different from what they last saved.
              final originalIds =
                  existingRotation.map((s) => s.userId).toList();
              final reconciledIds = reconciled.map((h) => h.userId).toList();
              final changed = originalIds.length != reconciledIds.length ||
                  Iterable.generate(originalIds.length)
                      .any((i) => originalIds[i] != reconciledIds[i]);
              if (changed) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  AppFeedback.showInfo(
                    context,
                    'The rotation order was adjusted — a participant or hand '
                    'count changed since it was last saved. Review before saving.',
                    duration: const Duration(seconds: 5),
                  );
                });
              }
            } else {
              _hands = _buildFromParticipants(participants);
            }
          }
          final hands = _hands!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Drag to set the payout order. Each hand is a separate turn — '
                  'a participant with 2 hands gets 2 entries below.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: hands.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = hands.removeAt(oldIndex);
                      hands.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final hand = hands[index];
                    // Count which hand number this is FOR THIS user up to
                    // this point in the list, for a "hand 2 of 2"-style
                    // display label matching API.md's handNumber concept.
                    final handNumberForUser = hands
                        .sublist(0, index + 1)
                        .where((h) => h.userId == hand.userId)
                        .length;
                    final totalHandsForUser =
                        hands.where((h) => h.userId == hand.userId).length;

                    return Card(
                      key: ValueKey(hand.localKey),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AjopayColors.primaryTint,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: AjopayColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        title: Text(hand.userFullName),
                        subtitle: totalHandsForUser > 1
                            ? Text(
                                'Hand $handNumberForUser of $totalHandsForUser')
                            : null,
                        trailing: const Icon(Icons.drag_handle),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
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
                      : const Text('Save rotation order'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
