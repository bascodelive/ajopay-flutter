import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_backdrop.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & User Guide')),
      body: AppBackdrop(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: const [
            _HelpTopic(
              icon: Icons.savings_outlined,
              title: 'What is Ajopay?',
              body: 'Ajopay is a mobile app for AJO and ESUSU — the rotating '
                  'savings tradition trusted by communities across Nigeria and '
                  'beyond. It brings your savings circle online: organized, '
                  'transparent, and accessible from your phone.\n\n'
                  'Whether you are starting a new group or joining one, '
                  'Ajopay gives everyone in the circle a clear picture of who '
                  'has paid, whose turn is next, and how the rotation is '
                  'progressing — in real time.',
            ),
            _HelpTopic(
              icon: Icons.person_add_outlined,
              title: 'Creating your account',
              body: 'Tap "Create one" on the login screen. You need your full '
                  'name, email address, phone number, and a password with at '
                  'least 8 characters (including uppercase, lowercase, and a '
                  'number).\n\n'
                  'After registering, a 6-digit code is sent to your email. '
                  'Enter it to activate your account. The code expires after '
                  '24 hours — if it does not arrive, check your spam folder '
                  'or tap Resend code.\n\n'
                  'If you forget your password, tap "Forgot password?" on the '
                  'login screen to receive a reset code by email.',
            ),
            _HelpTopic(
              icon: Icons.groups_outlined,
              title: 'Ledgers — your savings groups',
              body: 'A ledger is a savings group. Everything in Ajopay — '
                  'contributions, circles, messages — lives inside a ledger.\n\n'
                  'Creating a ledger: tap New / Join on the home screen, then '
                  '"Create a new ledger." Set a name, contribution frequency '
                  '(Daily, Weekly, or Monthly), and a fixed contribution '
                  'amount. You become the Admin automatically and receive an '
                  '8-character invite code to share with members.\n\n'
                  'Joining a ledger: tap New / Join, then "Join with an invite '
                  'code." Your request goes to the Admin for approval — you '
                  'will see a "Request sent" screen. You will be notified once '
                  'approved.\n\n'
                  'Free accounts: 1 active ledger at a time.\n'
                  'Premium accounts: up to 10 active ledgers.',
            ),
            _HelpTopic(
              icon: Icons.how_to_reg_outlined,
              title: 'Managing members (Admins)',
              body: 'From a ledger, tap Members → Pending tab to see join '
                  'requests. Tap Approve to let someone in, or Decline to '
                  'reject the request. Both actions send the applicant an '
                  'email notification.\n\n'
                  'All active members can view the full member list, including '
                  'everyone\'s role.',
            ),
            _HelpTopic(
              icon: Icons.autorenew,
              title: 'Circles — the payout rotation',
              body: 'A circle is one complete rotation within a ledger. It has '
                  'three stages:\n\n'
                  '• Setting up (PENDING) — The Admin adds participants, sets '
                  'hand counts, and assigns the rotation order. Everything is '
                  'still editable.\n\n'
                  '• Active (ACTIVE) — The Admin taps "Start circle." The '
                  'rotation locks permanently. Payout slots are assigned in '
                  'the agreed order.\n\n'
                  '• Completed (COMPLETED) — Every slot has been paid out. '
                  'Full history is available to export.\n\n'
                  'Hand counts: a member with 2 hands gets paid twice during '
                  'the circle and contributes double each cycle.\n\n'
                  'The Circle screen shows a live countdown to the scheduled '
                  'start date while the circle is still in the Setting up '
                  'stage.',
            ),
            _HelpTopic(
              icon: Icons.receipt_long_outlined,
              title: 'Contributions',
              body: 'A contribution is one payment record for a specific cycle '
                  'date. The Admin generates contributions each cycle, then '
                  'members report payment, and the Admin confirms it.\n\n'
                  'States:\n'
                  '• PENDING — Waiting for the member to pay\n'
                  '• REPORTED — Member has reported payment; Admin to confirm\n'
                  '• PAID — Admin confirmed; contribution settled\n'
                  '• MISSED — Admin marked as missed; can be reopened\n\n'
                  'Once PAID, you can export the contribution\'s full history '
                  'as a CSV file — tap the share icon in the top-right of the '
                  'Contribution Detail screen.',
            ),
            _HelpTopic(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Messages',
              body: 'Every ledger has a Group chat (visible to all active '
                  'members) and Direct messages (private, one-to-one).\n\n'
                  'Reading messages is always free. Sending messages is a '
                  'Premium feature.\n\n'
                  'A gold badge on the Messages tile and on the Group tab '
                  'shows how many new group messages have arrived since you '
                  'last opened the thread. It clears the moment you open the '
                  'Group tab.',
            ),
            _HelpTopic(
              icon: Icons.workspace_premium_outlined,
              title: 'Free vs Premium',
              body: 'Free accounts:\n'
                  '• 1 active ledger at a time\n'
                  '• Can read messages\n'
                  '• Full access to circles, contributions, ratings, and CSV export\n\n'
                  'Premium accounts:\n'
                  '• Up to 10 active ledgers\n'
                  '• Can send messages (Group and Direct)\n'
                  '• Everything Free includes\n\n'
                  'To upgrade: open your Profile → Subscription → Upgrade to '
                  'Premium. Payment is handled securely through Paystack in '
                  'your browser. Your account upgrades automatically once '
                  'payment is confirmed (may take up to a minute — pull down '
                  'to refresh if it has not updated yet).',
            ),
            _HelpTopic(
              icon: Icons.star_outline_rounded,
              title: 'Ratings & reviews',
              body: 'Any member with at least one active ledger membership can '
                  'browse the public directory and rate or review any ledger '
                  'they have been part of.\n\n'
                  'Tap the compass icon on the home screen to open the '
                  'directory. Use the Newest / Top Rated toggle to sort. '
                  'Ledgers need at least 3 ratings to appear in Top Rated.\n\n'
                  'To rate: tap any ledger tile in the directory, choose your '
                  'stars, and optionally write a review. Reviews are shown '
                  'with your name attached — not anonymous.\n\n'
                  'Admins cannot rate their own ledger.',
            ),
            _HelpTopic(
              icon: Icons.lock_outline,
              title: 'Safety & privacy tips',
              body: '• Your invite code is the key to your ledger. Only share '
                  'it with people you want to join.\n\n'
                  '• If someone joins you did not invite, decline their '
                  'request — they cannot see any ledger content until '
                  'approved.\n\n'
                  '• All contribution records and circle history are logged '
                  'and exportable. Keep your CSV exports somewhere safe.\n\n'
                  '• Never share your password with anyone, including people '
                  'claiming to be Ajopay support. Ajopay staff will never ask '
                  'for your password.',
            ),
            SizedBox(height: 8),
            _FaqSection(),
          ],
        ),
      ),
    );
  }
}

class _HelpTopic extends StatefulWidget {
  const _HelpTopic({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  State<_HelpTopic> createState() => _HelpTopicState();
}

class _HelpTopicState extends State<_HelpTopic> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AjopayColors.primaryTint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon,
                        size: 19, color: AjopayColors.primaryDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AjopayColors.textMuted,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const Divider(height: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Text(
                  widget.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AjopayColors.textSecondary,
                        height: 1.6,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Common questions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AjopayColors.primaryDark,
                ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: const [
              _FaqTile(
                question: 'I verified my email but still cannot log in.',
                answer:
                    'Wait a moment and try again — verification can occasionally '
                    'take a few seconds to propagate. If it persists, tap "Forgot '
                    'password?" to reset and verify you are using the right email.',
              ),
              _FaqDivider(),
              _FaqTile(
                question: 'I sent a join request but nothing happened.',
                answer:
                    'Your request is pending the Admin\'s approval. The Admin '
                    'receives a notification when you apply. If you have been '
                    'waiting a long time, reach out to them directly.',
              ),
              _FaqDivider(),
              _FaqTile(
                question:
                    'The circle start date has passed but the circle has not started.',
                answer:
                    'Starting a circle is always a manual action by the Admin — '
                    'the app shows a countdown and a "ready when you are" message '
                    'but will not start automatically. Contact your Admin.',
              ),
              _FaqDivider(),
              _FaqTile(
                question:
                    'My payment was reported but the Admin has not confirmed it.',
                answer:
                    'The Admin needs to confirm all reported payments. If it has '
                    'been a while, send a message in the Group chat to follow up.',
              ),
              _FaqDivider(),
              _FaqTile(
                question: 'I cannot see the send button in Messages.',
                answer:
                    'Sending messages is a Premium feature. You can read all '
                    'messages on a Free account, but you need Premium to send. '
                    'Tap the Upgrade prompt in the composer area.',
              ),
              _FaqDivider(),
              _FaqTile(
                question: 'The unread badge is still showing.',
                answer:
                    'Just tap the Group tab inside Messages. The badge clears '
                    'the moment you open the Group thread.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.help_outline,
                      size: 18, color: AjopayColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.question,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: AjopayColors.textMuted,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  widget.answer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AjopayColors.textSecondary,
                        height: 1.5,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaqDivider extends StatelessWidget {
  const _FaqDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}
