import 'package:ajopay/core/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
import '../../../../core/widgets/avatar_display.dart';
import '../../../../core/widgets/premium_badge.dart';
import '../../../auth/application/auth_controller.dart';
import '../../application/account_controller.dart';
import '../../data/models/account_models.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditing = false;
  bool _isSaving = false;
  bool _isChangingAvatar = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _startEditing(ProfileResponse profile) {
    _fullNameController.text = profile.fullName;
    _phoneController.text = profile.phone ?? '';
    setState(() => _isEditing = true);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final ok = await ref.read(accountControllerProvider.notifier).updateProfile(
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      if (ok) _isEditing = false;
    });

    if (!ok) {
      final message = ref.read(accountControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not save changes. Try again.');
    } else {
      AppFeedback.showSuccess(context, 'Profile updated');
    }
  }

  Future<void> _changeAvatar(ProfileResponse profile) async {
    final chosen = await showAvatarPickerSheet(
      context,
      currentAvatarId: profile.avatarId,
    );
    if (chosen == null || chosen == profile.avatarId) return;
    if (!mounted) return;

    setState(() => _isChangingAvatar = true);
    final ok =
        await ref.read(accountControllerProvider.notifier).updateAvatar(chosen);

    if (!mounted) return;
    setState(() => _isChangingAvatar = false);

    if (!ok) {
      final message = ref.read(accountControllerProvider.notifier).lastError;
      AppFeedback.showError(
          context, message ?? 'Could not update avatar. Try again.');
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
            'You can always log back in with your email and password.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out',
                style: TextStyle(color: AjopayColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  Future<void> _confirmLogoutAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out of all devices?'),
        content: const Text(
          'This signs out every device where you\'re logged in — not just '
          'this one. Use this if you think your account may have been '
          'accessed somewhere you don\'t recognize.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out everywhere',
                style: TextStyle(color: AjopayColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final ok = await ref.read(authControllerProvider.notifier).logoutAll();
    if (!mounted) return;
    if (!ok) {
      final message = ref.read(authControllerProvider).errorMessage;
      AppFeedback.showError(
          context, message ?? 'Could not log out of all devices. Try again.');
    }
    // On success, the router redirect handles navigation back to /login
    // on its own, same as regular logout.
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(accountControllerProvider);

    return Scaffold(
      backgroundColor: AjopayColors.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          profileAsync.maybeWhen(
            data: (profile) => _isEditing
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _startEditing(profile),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: profileAsync.when(
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
                const Text('Could not load your profile.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(accountControllerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () => ref.refresh(accountControllerProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(
                  profile: profile,
                  isChangingAvatar: _isChangingAvatar,
                  onTapAvatar: () => _changeAvatar(profile),
                  topInset: MediaQuery.of(context).padding.top + kToolbarHeight,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isEditing)
                        _EditForm(
                          formKey: _formKey,
                          fullNameController: _fullNameController,
                          phoneController: _phoneController,
                          originalFullName: profile.fullName,
                          originalPhone: profile.phone,
                          isSaving: _isSaving,
                          onSave: _save,
                          onCancel: () => setState(() => _isEditing = false),
                        )
                      else ...[
                        const _SectionLabel('Contact'),
                        const SizedBox(height: 10),
                        _InfoCard(profile: profile),
                        const SizedBox(height: 12),
                        Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: const Icon(Icons.help_outline_rounded,
                                color: AjopayColors.primary),
                            title: const Text('Help & User Guide'),
                            subtitle: const Text('How Ajopay works'),
                            trailing: const Icon(Icons.chevron_right,
                                color: AjopayColors.textMuted),
                            onTap: () => context.push('/help'),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const _SectionLabel('Account'),
                        const SizedBox(height: 10),
                        _AccountCard(
                            onChangePassword: () =>
                                context.push('/change-password')),
                        const SizedBox(height: 28),
                        const _SectionLabel(
                          'Danger zone',
                          color: AjopayColors.error,
                        ),
                        const SizedBox(height: 10),
                        _DangerCard(
                          onLogout: _confirmLogout,
                          onLogoutAll: _confirmLogoutAll,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color ?? Colors.black45,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.isChangingAvatar,
    required this.onTapAvatar,
    required this.topInset,
  });

  final ProfileResponse profile;
  final bool isChangingAvatar;
  final VoidCallback onTapAvatar;
  final double topInset;

  static const double _avatarRadius = 44;
  static const double _headerHeight = 180;

  @override
  Widget build(BuildContext context) {
    final isPremium = profile.subscriptionTier == 'PREMIUM';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: _headerHeight + topInset,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AjopayColors.primaryDark,
                    AjopayColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Stack(
                  children: [
                    // A quiet brand echo, not decoration for its own
                    // sake — the same savings motif used elsewhere
                    // (AVATAR_1's icon), very low opacity so it never
                    // competes with the name/email sitting on top of it.
                    Positioned(
                      top: -16,
                      right: -20,
                      child: Icon(
                        Icons.savings_rounded,
                        size: 150,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: topInset + _headerHeight - _avatarRadius,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: isChangingAvatar ? null : onTapAvatar,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isPremium ? 4 : 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: isPremium
                              ? Border.all(color: AjopayColors.gold, width: 3)
                              : null,
                        ),
                        child: Opacity(
                          opacity: isChangingAvatar ? 0.5 : 1,
                          child: AvatarCircle(
                            avatarId: profile.avatarId,
                            fullNameForFallback: profile.fullName,
                            radius: _avatarRadius,
                          ),
                        ),
                      ),
                      if (isChangingAvatar)
                        const Positioned.fill(
                          child: Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      else
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AjopayColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.edit,
                                size: 13, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: _avatarRadius + 12),
        Text(
          profile.fullName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
        ),
        const SizedBox(height: 12),
        Center(
          child: isPremium
              ? const PremiumBadge()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: Colors.black.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'FREE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.profile});

  final ProfileResponse profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.mail_outline,
              label: 'Email',
              value: profile.email,
              trailing: _VerifiedChip(verified: profile.emailVerified),
            ),
            const Divider(height: 1, indent: 68),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: profile.phone?.isNotEmpty == true
                  ? profile.phone!
                  : 'Not set',
              trailing: profile.phone?.isNotEmpty == true
                  ? _VerifiedChip(verified: profile.phoneVerified)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AjopayColors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AjopayColors.primaryDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip({required this.verified});

  final bool verified;

  @override
  Widget build(BuildContext context) {
    final color = verified ? AjopayColors.primary : AjopayColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.check_circle : Icons.error_outline,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            verified ? 'Verified' : 'Unverified',
            style:
                Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Neutral, everyday actions — visually distinct from _DangerCard below
/// on purpose. A logout action sitting in the exact same card style as
/// "change your password" gives both equal visual weight even though
/// one is far more consequential; separating them fixes that.
class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.onChangePassword});

  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AjopayColors.primaryTint,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock_outline,
              size: 18, color: AjopayColors.primaryDark),
        ),
        title: const Text('Change password'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onChangePassword,
      ),
    );
  }
}

/// A visually flagged "danger zone" — light red tint + border — same
/// pattern a lot of modern settings screens use to make consequential
/// actions read as consequential before you even reach for the text.
class _DangerCard extends StatelessWidget {
  const _DangerCard({required this.onLogout, required this.onLogoutAll});

  final VoidCallback onLogout;
  final VoidCallback onLogoutAll;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AjopayColors.error.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AjopayColors.error.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout, color: AjopayColors.error),
            title: const Text('Log out',
                style: TextStyle(color: AjopayColors.error)),
            onTap: onLogout,
          ),
          Divider(
              height: 1,
              indent: 68,
              color: AjopayColors.error.withValues(alpha: 0.15)),
          ListTile(
            leading:
                const Icon(Icons.phonelink_erase, color: AjopayColors.error),
            title: const Text('Log out of all devices',
                style: TextStyle(color: AjopayColors.error)),
            onTap: onLogoutAll,
          ),
        ],
      ),
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm({
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.originalFullName,
    required this.originalPhone,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final String originalFullName;
  final String? originalPhone;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    widget.fullNameController.addListener(_onChanged);
    widget.phoneController.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.fullNameController.removeListener(_onChanged);
    widget.phoneController.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    final nameChanged =
        widget.fullNameController.text.trim() != widget.originalFullName.trim();
    final phoneChanged = widget.phoneController.text.trim() !=
        (widget.originalPhone ?? '').trim();
    final dirty = nameChanged || phoneChanged;
    if (dirty != _isDirty) setState(() => _isDirty = dirty);
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _isDirty && !widget.isSaving;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Edit profile',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: widget.fullNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Full name is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: widget.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone (optional)',
                  hintText: '+2348012345678',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.isSaving ? null : widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppPrimaryButton(
                      label: 'Save',
                      height: 48,
                      isLoading: widget.isSaving,
                      onPressed: canSave ? widget.onSave : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
