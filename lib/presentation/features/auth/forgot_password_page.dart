import 'package:growapp/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

enum _Step { email, code, newPassword, success }

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  _Step _step = _Step.email;

  final _emailFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());

  final _passwordFormKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  String get _email => _emailController.text.trim();
  String get _code => _codeControllers.map((c) => c.text).join();

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _codeControllers) { c.dispose(); }
    for (final f in _codeFocusNodes) { f.dispose(); }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSendCode() async {
    if (!(_emailFormKey.currentState?.validate() ?? false)) return;
    final provider = context.read<AuthProvider>();
    final locale = Localizations.localeOf(context).languageCode;
    await provider.sendPasswordResetCode(_email, locale: locale);
    if (!mounted) return;
    if (provider.error != null) {
      _showError(_mapError(provider.error!, AppLocalizations.of(context)!));
      return;
    }
    setState(() => _step = _Step.code);
  }

  Future<void> _onVerifyCode() async {
    if (_code.length < 6) return;
    final provider = context.read<AuthProvider>();
    final valid = await provider.verifyPasswordResetCode(_email, _code);
    if (!mounted) return;
    if (!valid) {
      final l = AppLocalizations.of(context)!;
      _showError(provider.error?.contains('expired') == true
          ? l.passwordResetExpired
          : l.invalidCode);
      return;
    }
    setState(() => _step = _Step.newPassword);
  }

  Future<void> _onConfirmPassword() async {
    if (!(_passwordFormKey.currentState?.validate() ?? false)) return;
    final provider = context.read<AuthProvider>();
    await provider.confirmNewPassword(_email, _code, _newPasswordController.text);
    if (!mounted) return;
    if (provider.error != null) {
      _showError(_mapError(provider.error!, AppLocalizations.of(context)!));
      return;
    }
    setState(() => _step = _Step.success);
  }

  String _mapError(String error, AppLocalizations l) {
    final e = error.replaceFirst(RegExp(r'^Exception:\s*'), '').toLowerCase();
    if (e.contains('user-not-found') || e.contains('user_not_found')) return l.userNotFound;
    if (e.contains('account_deactivated') || e.contains('account-deactivated')) return l.accountDeactivated;
    if (e.contains('expired')) return l.passwordResetExpired;
    if (e.contains('too-many-requests') || e.contains('too_many_requests')) return l.tooManyRequests;
    if (e.contains('invalid-code') || e.contains('invalid_code')) return l.invalidCode;
    if (e.contains('unauthenticated') || e.contains('permission-denied')) return l.loginError;
    if (e.contains('network') || e.contains('unavailable') || e.contains('deadline-exceeded')) return l.errorNetwork;
    if (e.contains('internal') || e.contains('unknown')) return l.errorGeneric;
    AppLogger.w('[ForgotPassword]', 'unhandled error: $error');
    return l.invalidCode;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 28),
          onPressed: _step == _Step.success ? null : () {
            if (_step == _Step.email) {
              Navigator.pop(context);
            } else {
              setState(() => _step = _Step.values[_step.index - 1]);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: switch (_step) {
            _Step.email => _buildEmailStep(l),
            _Step.code => _buildCodeStep(l),
            _Step.newPassword => _buildNewPasswordStep(l),
            _Step.success => _buildSuccess(l),
          },
        ),
      ),
    );
  }

  // ── Step 1: Email ──────────────────────────────────────────────────────────

  Widget _buildEmailStep(AppLocalizations l) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _iconBox(Icons.lock_reset_rounded, AppColors.secondary),
          const SizedBox(height: 24),
          _centeredTitle(l.forgotPassword),
          const SizedBox(height: 8),
          _centeredSubtitle(l.forgotPasswordDesc),
          const SizedBox(height: 32),
          _fieldLabel(l.email),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l.enterEmail;
              if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) {
                return l.validEmail;
              }
              return null;
            },
            style: AppTypography.body.copyWith(color: AppColors.textPrimary, fontSize: 15),
            decoration: _inputDecoration(hint: l.emailHint, prefixIcon: Icons.email_outlined),
          ),
          const SizedBox(height: 32),
          Consumer<AuthProvider>(
            builder: (_, auth, _) => _primaryButton(
              label: l.resetPasswordButton,
              loading: auth.isLoading,
              onPressed: _onSendCode,
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 2: Code ───────────────────────────────────────────────────────────

  Widget _buildCodeStep(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _iconBox(Icons.pin_outlined, AppColors.primary),
        const SizedBox(height: 24),
        _centeredTitle(l.verifyYourEmail),
        const SizedBox(height: 8),
        _centeredSubtitle(l.enterResetCode),
        const SizedBox(height: 8),
        // Girilen email + geri dön linki
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                _email,
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _step = _Step.email),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l.changeEmail,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l.checkSpamFolder,
                    style: AppTypography.body.copyWith(
                      fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) => _codeBox(i)),
        ),
        const SizedBox(height: 32),
        Consumer<AuthProvider>(
          builder: (_, auth, _) => _primaryButton(
            label: l.verifyCode,
            loading: auth.isLoading,
            onPressed: _onVerifyCode,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _step = _Step.email),
            child: Text(
              l.resendCode,
              style: AppTypography.body.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w500, fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _codeBox(int index) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextFormField(
        controller: _codeControllers[index],
        focusNode: _codeFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppTypography.cardTitle.copyWith(
          fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.background,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && index < 5) {
            _codeFocusNodes[index + 1].requestFocus();
          } else if (v.isEmpty && index > 0) {
            _codeFocusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  // ── Step 3: New Password ───────────────────────────────────────────────────

  Widget _buildNewPasswordStep(AppLocalizations l) {
    return Form(
      key: _passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _iconBox(Icons.lock_outline_rounded, AppColors.primary),
          const SizedBox(height: 24),
          _centeredTitle(l.createNewPassword),
          const SizedBox(height: 8),
          _centeredSubtitle(l.createNewPasswordDesc),
          const SizedBox(height: 32),
          _fieldLabel(l.newPassword),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newPasswordController,
            obscureText: !_showNewPassword,
            validator: (v) {
              if (v == null || v.isEmpty) return l.enterPassword;
              if (v.length < 6) return l.passwordMinLength;
              return null;
            },
            style: AppTypography.body.copyWith(color: AppColors.textPrimary, fontSize: 15),
            decoration: _inputDecoration(
              hint: l.newPasswordHint,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _showNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted, size: 20,
                ),
                onPressed: () => setState(() => _showNewPassword = !_showNewPassword),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _fieldLabel(l.confirmNewPassword),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_showConfirmPassword,
            validator: (v) {
              if (v == null || v.isEmpty) return l.enterPassword;
              if (v != _newPasswordController.text) return l.passwordsNotMatch;
              return null;
            },
            style: AppTypography.body.copyWith(color: AppColors.textPrimary, fontSize: 15),
            decoration: _inputDecoration(
              hint: l.confirmNewPasswordHint,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted, size: 20,
                ),
                onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Consumer<AuthProvider>(
            builder: (_, auth, _) => _primaryButton(
              label: l.saveChanges,
              loading: auth.isLoading,
              onPressed: _onConfirmPassword,
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 4: Success ────────────────────────────────────────────────────────

  Widget _buildSuccess(AppLocalizations l) {
    return Column(
      children: [
        const SizedBox(height: 60),
        _iconBox(Icons.check_circle_rounded, AppColors.success, size: 80),
        const SizedBox(height: 24),
        Text(
          l.resetPasswordSuccess,
          style: AppTypography.cardTitle.copyWith(
            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l.resetPasswordSuccessDesc,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary, fontSize: 14, height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text(
              l.backToLogin,
              style: AppTypography.button.copyWith(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _iconBox(IconData icon, Color color, {double size = 72}) {
    return Center(
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(size * 0.28),
        ),
        child: Icon(icon, size: size * 0.5, color: color),
      ),
    );
  }

  Widget _centeredTitle(String text) => Center(
        child: Text(text,
            style: AppTypography.cardTitle.copyWith(
              fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
            )),
      );

  Widget _centeredSubtitle(String text) => Center(
        child: Text(text,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary, fontSize: 14, height: 1.5,
            )),
      );

  Widget _fieldLabel(String text) => Text(text,
      style: AppTypography.body.copyWith(
        fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontSize: 13,
      ));

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted, fontSize: 15),
      prefixIcon: Icon(prefixIcon, color: AppColors.textMuted, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.danger, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.danger, width: 1.5)),
    );
  }

  Widget _primaryButton({
    required String label,
    required bool loading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Text(label, style: AppTypography.button.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}
