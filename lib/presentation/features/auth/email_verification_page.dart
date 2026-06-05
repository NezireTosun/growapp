import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _canResend = false;
  int _resendCooldown = 60;
  Timer? _cooldownTimer;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final locale = Localizations.localeOf(context).languageCode;
      // Demo hesabı için de sendVerificationCode çağrılır — repo sabit 000000 kodunu Firestore'a yazar
      auth.sendVerificationCode(locale: locale);
      _startCooldown();
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _canResend = false;
      _resendCooldown = 60;
    });

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    if (!_canResend) return;
    final locale = Localizations.localeOf(context).languageCode;
    context.read<AuthProvider>().sendVerificationCode(locale: locale);
    _startCooldown();
    _clearCode();

    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.verificationResent),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _clearCode() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() => _errorText = null);
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verifyCode() async {
    final code = _code;
    if (code.length != 6) return;

    final auth = context.read<AuthProvider>();
    final verified = await auth.verifyCode(code);

    if (!mounted) return;

    if (verified) {
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    } else {
      final l = AppLocalizations.of(context)!;
      setState(() => _errorText = l.invalidCode);
      _clearCode();
    }
  }

  void _onCodeChanged(int index, String value) {
    setState(() => _errorText = null);

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Auto-verify when all 6 digits entered
    if (_code.length == 6) {
      _verifyCode();
    }
  }

  void _onKeyDown(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final email = auth.user?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: AppColors.textPrimary),
          onPressed: () {
            context.read<AuthProvider>().signOut();
            Navigator.pushReplacementNamed(context, AppRouter.register);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(),
              // Mail icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 40,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l.verifyYourEmail,
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.verificationCodeSent,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthProvider>().signOut();
                      Navigator.pushReplacementNamed(context, AppRouter.register);
                    },
                    child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
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
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 6-digit code input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 48,
                    height: 56,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : 8,
                      right: index == 2 ? 12 : 0,
                    ),
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) => _onKeyDown(index, event),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: _errorText != null
                              ? AppColors.dangerLight
                              : AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _errorText != null
                                  ? AppColors.danger
                                  : AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _errorText != null
                                  ? AppColors.danger
                                  : AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onCodeChanged(index, value),
                      ),
                    ),
                  );
                }),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: AppTypography.body.copyWith(
                    color: AppColors.danger,
                    fontSize: 13,
                  ),
                ),
              ],

              if (auth.isLoading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: AppColors.primary),
              ],

              const Spacer(),

              // Resend code
              GestureDetector(
                onTap: _canResend ? _resendCode : null,
                child: Text(
                  _canResend
                      ? l.resendCode
                      : '${l.resendCode} ($_resendCooldown)',
                  style: AppTypography.body.copyWith(
                    color: _canResend ? AppColors.primary : AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
