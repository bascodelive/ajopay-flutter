import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/screens/change_password_screen.dart';
import '../../features/account/presentation/screens/forgot_password_screen.dart';
import '../../features/account/presentation/screens/profile_screen.dart';
import '../../features/account/presentation/screens/reset_password_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/ledgers/presentation/screens/ledger_directory_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/circles/presentation/screens/assign_rotation_screen.dart';
import '../../features/circles/presentation/screens/circle_history_screen.dart';
import '../../features/circles/presentation/screens/circle_home_screen.dart';
import '../../features/circles/presentation/screens/circle_participants_screen.dart';
import '../../features/circles/presentation/screens/create_circle_screen.dart';
import '../../features/circles/presentation/screens/current_payout_screen.dart';
import '../../features/circles/presentation/screens/past_circles_screen.dart';
import '../../features/circles/presentation/screens/rotation_queue_screen.dart';
import '../../features/contributions/data/models/contribution_models.dart';
import '../../features/contributions/presentation/screens/contribution_detail_screen.dart';
import '../../features/contributions/presentation/screens/contributions_list_screen.dart';
import '../../features/contributions/presentation/screens/schedule_contribution_screen.dart';
import '../../features/ledgers/presentation/screens/create_ledger_screen.dart';
import '../../features/ledgers/presentation/screens/edit_ledger_screen.dart';
import '../../features/ledgers/presentation/screens/join_ledger_screen.dart';
import '../../features/ledgers/presentation/screens/ledger_detail_screen.dart';
import '../../features/ledgers/presentation/screens/ledger_home_screen.dart';
import '../../features/ledgers/presentation/screens/ledger_members_screen.dart';
import '../../features/messages/presentation/screens/messages_home_screen.dart';
import '../../features/ledgers/presentation/screens/ledger_reviews_screen.dart';
import '../../features/messages/presentation/screens/private_message_thread_screen.dart';
import '../../features/subscriptions/presentation/screens/subscription_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';

/// go_router needs a Listenable to know when to re-run `redirect` — Riverpod
/// state changes aren't one by default, so this bridges AuthController's
/// state stream into a ChangeNotifier go_router can subscribe to.
class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (_, __) => notifyListeners());
  }
}

/// blueprint Section 5.3: a single `redirect` callback decides "does this
/// caller belong here," rather than each screen independently checking
/// "am I logged in?"
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _GoRouterRefreshNotifier(ref);

  const authRoutes = {
    '/login',
    '/register',
    '/verify-email',
    '/forgot-password',
    '/reset-password'
  };

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isOnAuthRoute = authRoutes.contains(state.matchedLocation);

      // Session status hasn't resolved yet (checking secure storage on
      // cold start) — don't redirect prematurely.
      if (authState.status == AuthStatus.unknown) return null;

      if (authState.status == AuthStatus.unauthenticated && !isOnAuthRoute) {
        return '/login';
      }
      if (authState.status == AuthStatus.authenticated && isOnAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LedgerHomeScreen(),
      ),
      // Real screens — Phase 1b.
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => VerifyEmailScreen(
          initialEmail: state.uri.queryParameters['email'] ?? '',
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => ResetPasswordScreen(
          initialEmail: state.uri.queryParameters['email'] ?? '',
        ),
      ),
      // Protected — Phase 2.
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      // Protected — Subscriptions. Registered here (not under Phase 2/3
      // sections above/below) since it's reached from multiple places —
      // Profile today, Messages' upsell banner already calling
      // context.push('/subscription') since the earlier Messages pass,
      // more premium-gated screens later — not owned by any one feature.
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      // Protected — Phase 3.
      GoRoute(
        path: '/ledgers/create',
        builder: (context, state) => const CreateLedgerScreen(),
      ),
      GoRoute(
        path: '/ledgers/join',
        builder: (context, state) => const JoinLedgerScreen(),
      ),
      GoRoute(
        path: '/ledgers/directory',
        builder: (context, state) => const LedgerDirectoryScreen(),
      ),
      GoRoute(
        path: '/ledgers/:id',
        builder: (context, state) => LedgerDetailScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/edit',
        builder: (context, state) => EditLedgerRoute(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/members',
        builder: (context, state) => LedgerMembersScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      // Protected — Circles (nested under a ledger).
      GoRoute(
        path: '/ledgers/:id/circle',
        builder: (context, state) => CircleHomeScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/circle/create',
        builder: (context, state) => CreateCircleScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/circle/:circleId/participants',
        builder: (context, state) => CircleParticipantsScreen(
          ledgerId: state.pathParameters['id']!,
          circleId: state.pathParameters['circleId']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/circle/:circleId/rotation/assign',
        builder: (context, state) => AssignRotationScreen(
          ledgerId: state.pathParameters['id']!,
          circleId: state.pathParameters['circleId']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/circle/:circleId/rotation',
        builder: (context, state) => RotationQueueScreen(
          ledgerId: state.pathParameters['id']!,
          circleId: state.pathParameters['circleId']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/circle/:circleId/current-payout',
        builder: (context, state) => CurrentPayoutScreen(
          ledgerId: state.pathParameters['id']!,
          circleId: state.pathParameters['circleId']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/circle/past',
        builder: (context, state) => PastCirclesScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/circle/:circleId/history',
        builder: (context, state) {
          // circleStatus is passed via `extra` by every screen that
          // navigates here (CircleHomeScreen's Active/Completed views,
          // PastCirclesScreen) — null only for a bare deep link with no
          // navigation context, in which case CircleHistoryScreen keeps
          // export hidden rather than guessing. See that screen's own
          // doc comment on why this is no longer re-derived from
          // currentCircleProvider.
          final extra = state.extra;
          final circleStatus = extra is String ? extra : null;
          return CircleHistoryScreen(
            ledgerId: state.pathParameters['id']!,
            circleId: state.pathParameters['circleId']!,
            circleStatus: circleStatus,
          );
        },
      ),
      // Protected — Contributions.
      GoRoute(
        path: '/ledgers/:id/contributions',
        builder: (context, state) => ContributionsListScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/contributions/schedule',
        builder: (context, state) => ScheduleContributionScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/contributions/:contributionId',
        builder: (context, state) {
          final ledgerId = state.pathParameters['id']!;
          // No "get contribution by ID" endpoint exists (confirmed
          // against real backend source) — this screen can only work
          // when reached from the list, which passes the full object via
          // `extra`. Defensive handling here, not a bad cast crash, for
          // the case that's NOT supposed to happen (deep link, hot
          // reload losing navigation state) — a graceful message rather
          // than pretending this path is fully supported when it isn't.
          final extra = state.extra;
          if (extra is! ContributionResponse) {
            return Scaffold(
              appBar: AppBar(title: const Text('Contribution')),
              body: const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Open this contribution from the list — direct links '
                    "aren't supported yet.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          return ContributionDetailScreen(
              ledgerId: ledgerId, initialContribution: extra);
        },
      ),
      GoRoute(
        path: '/ledgers/:id/messages',
        builder: (context, state) => MessagesHomeScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/ledgers/:id/messages/private/:otherUserId',
        builder: (context, state) {
          final extra = state.extra;
          final otherUserFullName = extra is String ? extra : 'Member';
          return PrivateMessageThreadScreen(
            ledgerId: state.pathParameters['id']!,
            otherUserId: state.pathParameters['otherUserId']!,
            otherUserFullName: otherUserFullName,
          );
        },
      ),
      GoRoute(
        path: '/ledgers/:id/reviews',
        builder: (context, state) => LedgerReviewsScreen(
          ledgerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpScreen(),
      ),
    ],
  );
});
