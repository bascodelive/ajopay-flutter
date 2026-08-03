import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// A modernized, reusable text field for the Auth flow (Login, Register,
/// Verify Email, Forgot Password) — softly rounded, icon-led, with an
/// animated focus glow so the active field is unmistakable at a glance.
///
/// Deliberately styled locally (own borders/colors) rather than by editing
/// the app-wide `InputDecorationTheme` in `app_theme.dart` — that theme is
/// shared by every other screen in the app (Ledgers, Circles, Contributions),
/// and this is a purely visual treatment scoped to auth.
///
/// Purely presentational: validation, controllers, and submit logic all
/// stay owned by the screen that uses this widget — nothing here talks to
/// a controller or provider.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.validator,
    this.autocorrect = true,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.autovalidateMode,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool autocorrect;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus != _isFocused) {
        setState(() => _isFocused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color, {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AjopayColors.primary.withValues(alpha: 0.14),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        autocorrect: widget.autocorrect,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AjopayColors.textPrimary,
              fontSize: 16,
            ),
        decoration: InputDecoration(
          isDense: false,
          labelText: widget.label,
          hintText: widget.hintText,
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color:
                _isFocused ? AjopayColors.primary : AjopayColors.textSecondary,
          ),
          hintStyle: const TextStyle(color: AjopayColors.textMuted),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          prefixIcon: widget.icon == null
              ? null
              : Icon(
                  widget.icon,
                  size: 20,
                  color: _isFocused
                      ? AjopayColors.primary
                      : AjopayColors.textMuted,
                ),
          suffixIcon: widget.suffixIcon,
          border: _border(AjopayColors.border),
          enabledBorder: _border(AjopayColors.border),
          disabledBorder: _border(AjopayColors.border.withValues(alpha: 0.6)),
          focusedBorder: _border(AjopayColors.primary, width: 1.6),
          errorBorder: _border(AjopayColors.error),
          focusedErrorBorder: _border(AjopayColors.error, width: 1.6),
          errorStyle:
              const TextStyle(color: AjopayColors.error, fontSize: 12.5),
        ),
      ),
    );
  }
}
