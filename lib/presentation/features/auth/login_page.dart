import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/business_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final provider = context.read<AuthProvider>();
    await provider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (provider.error != null) {
      final l = AppLocalizations.of(context)!;
      final error = provider.error ?? '';
      String message;
      if (error.contains('account_deactivated')) {
        message = l.accountDeactivated;
      } else if (error.contains('user-not-found')) {
        message = l.userNotFound;
      } else if (error.contains('wrong-password') ||
          error.contains('invalid-credential')) {
        message = l.wrongPassword;
      } else if (error.contains('too-many-requests')) {
        message = l.tooManyRequests;
      } else {
        message = l.loginError;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.danger),
      );
      return;
    }

    if (provider.isAuthenticated) {
      final user = provider.user;
      if (user == null) return;
      if (!user.emailVerified) {
        Navigator.pushReplacementNamed(context, AppRouter.emailVerification);
        return;
      }
      final businessProvider = context.read<BusinessProvider>();
      await businessProvider.initialize(user.id, user.planId);
      if (!mounted) return;

      if (businessProvider.businesses.isEmpty) {
        Navigator.pushReplacementNamed(context, AppRouter.onboarding);
        return;
      }

      final active = businessProvider.activeBusiness;
      if (active == null) {
        Navigator.pushReplacementNamed(context, AppRouter.onboarding);
        return;
      }

      final typeId = int.tryParse(active.sector ?? '') ?? 0;
      final dashboard = context.read<DashboardProvider>();
      dashboard.setBusinessName(active.name);
      dashboard.setUserAndBusiness(user.id, active.id);
      dashboard.setBusinessType(typeId);
      dashboard.setApiParams(
        industry: active.sector ?? 'rest',
        answers: active.apiAnswers,
      );
      final locale = Localizations.localeOf(context).languageCode;
      dashboard.loadTasks(locale: locale, businessType: typeId);
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Logo + başlık
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l.signIn,
                        style: AppTypography.hero.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.welcomeBack,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Email
                _buildLabel(l.email),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: l.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l.enterEmail;
                    if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(v.trim())) { return l.validEmail; }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Password
                _buildLabel(l.password),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l.enterPassword;
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.forgotPassword),
                    child: Text(
                      l.forgotPassword,
                      style: AppTypography.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            l.signIn,
                            style: AppTypography.button.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // Ayraç
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l.dontHaveAccount,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 16),

                // Don't have account
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.register),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primaryBorder, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      l.signUp,
                      style: AppTypography.button.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: AppTypography.body.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 13,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: AppTypography.body.copyWith(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted, fontSize: 15),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
    );
  }
}
