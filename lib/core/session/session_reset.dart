import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/account/application/account_controller.dart';
import '../../features/circles/application/circle_controller.dart';
import '../../features/contributions/application/contribution_action_controller.dart';
import '../../features/contributions/application/contributions_pager.dart';
import '../../features/ledgers/application/ledger_controller.dart';

/// The single, explicit place that knows about every session-scoped
/// provider across every feature.
///
/// This is the ONE deliberate exception to this codebase's "features
/// never leak into each other" rule (blueprint Section 9) — justified
/// because logout / session-expiry is inherently an app-wide event, not
/// something any single domain owns.
///
/// Rule going forward: any new provider that caches data fetched FOR a
/// specific logged-in user — a profile, a list, a role, anything keyed by
/// "who is currently logged in" — must be added here. Forgetting to is
/// exactly the state-leak bug this file exists to prevent. Mirrors
/// PROGRESS.md's "bug found, fixed, rule going forward" discipline on the
/// backend side.
void resetAllSessionProviders(Ref ref) {
  // Account
  ref.invalidate(accountControllerProvider);

  // Ledgers
  ref.invalidate(ledgerControllerProvider);
  ref.invalidate(myLedgersProvider);
  // Family providers: invalidating the family clears every keyed entry
  // fetched this session (every ledgerId ever looked at), not just one.
  ref.invalidate(ledgerDetailProvider);
  ref.invalidate(ledgerMembersProvider);
  ref.invalidate(myMembershipProvider);

  // Circles
  ref.invalidate(circleControllerProvider);
  ref.invalidate(currentCircleProvider);
  ref.invalidate(circleParticipantsProvider);
  ref.invalidate(circleRotationProvider);
  ref.invalidate(currentPayoutProvider);
  ref.invalidate(circleHistoryProvider);

  // Contributions
  ref.invalidate(contributionActionControllerProvider);
  ref.invalidate(contributionsPagerProvider);
  ref.invalidate(contributionHistoryProvider);

  // TODO: add Messages/Subscriptions session-scoped providers here as
  // each phase ships — see BUILD_PHASES.md.
}
