import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_feedback.dart';
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
            child: Text('Log out everywhere',
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
      appBar: AppBar(
        title: const Text('Profile'),
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
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: AjopayColors.error),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(profile: profile),
                const SizedBox(height: 24),
                if (_isEditing)
                  _EditForm(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    phoneController: _phoneController,
                    isSaving: _isSaving,
                    onSave: _save,
                    onCancel: () => setState(() => _isEditing = false),
                  )
                else ...[
                  _InfoCard(profile: profile),
                  const SizedBox(height: 24),
                  _ActionsCard(
                      onLogout: _confirmLogout, onLogoutAll: _confirmLogoutAll),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final ProfileResponse profile;

  String get _initials {
    final parts = profile.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = profile.subscriptionTier == 'PREMIUM';

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AjopayColors.primaryTint,
          child: Text(
            _initials,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AjopayColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.fullName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(profile.email, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        if (isPremium)
          const PremiumBadge()
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AjopayColors.surface,
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
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
            const Divider(height: 1),
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
          Icon(icon, size: 20, color: AjopayColors.primary),
          const SizedBox(width: 16),
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

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({required this.onLogout, required this.onLogoutAll});

  final VoidCallback onLogout;
  final VoidCallback onLogoutAll;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/change-password'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: AjopayColors.error),
            title: Text('Log out', style: TextStyle(color: AjopayColors.error)),
            onTap: onLogout,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.phonelink_erase, color: AjopayColors.error),
            title: Text('Log out of all devices',
                style: TextStyle(color: AjopayColors.error)),
            onTap: onLogoutAll,
          ),
        ],
      ),
    );
  }
}

class _EditForm extends StatelessWidget {
  const _EditForm({
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Edit profile',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: fullNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Full name is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
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
                      onPressed: isSaving ? null : onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving ? null : onSave,
                      child: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save'),
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
