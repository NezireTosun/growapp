import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../../data/services/purchase_service.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String? _proPrice;

  @override
  void initState() {
    super.initState();
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    final price = await PurchaseService().getProMonthlyPrice();
    if (mounted) setState(() => _proPrice = price);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final businessProvider = context.watch<BusinessProvider>();
    final isPro = businessProvider.isPremium;
    final isPurchasing = businessProvider.isPurchasing;

    final purchaseError = businessProvider.purchaseError;
    if (purchaseError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(purchaseError), backgroundColor: AppColors.danger),
        );
        businessProvider.clearPurchaseError();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.subscription),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Pro card — premium
                _ProCard(
                  price: _proPrice ?? l.proPlanPrice,
                  description: l.proPlanDesc,
                  features: [
                    l.featureProAnalysis,
                    l.featureProPainPoint,
                    l.featureProFullLibrary,
                    l.featureProDashboard,
                    l.featureProUpdatedContent,
                    l.featureProWhatsApp,
                    l.featureProIdTracking,
                    l.featureProTemplates,
                    l.featureProSession,
                  ],
                  isCurrentPlan: isPro,
                  currentPlanLabel: l.yourCurrentPlan,
                  buttonLabel: !isPro ? l.upgradeNow : null,
                  onTap: !isPro && !isPurchasing
                      ? () => _purchase(context, businessProvider)
                      : null,
                  planTitle: l.proPlan,
                ),
                const SizedBox(height: 16),

                // Free card
                _FreeCard(
                  title: l.freePlan,
                  price: l.freePlanPrice,
                  description: l.freePlanDesc,
                  features: [
                    l.featureFreeAnalysis,
                    l.featureFreePainPoint,
                    l.featureFreeTasks,
                    l.featureFreeUpdatedContent,
                    l.featureFreeTemplates,
                  ],
                  isCurrentPlan: !isPro,
                  currentPlanLabel: l.yourCurrentPlan,
                ),
                const SizedBox(height: 12),

                if (!isPro)
                  TextButton(
                    onPressed: isPurchasing
                        ? null
                        : () => _restore(context, businessProvider),
                    child: Text(
                      l.restorePurchases,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.textMuted,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),

                // Auto-renew notice — Apple App Store requirement
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    l.subscriptionAutoRenewNotice,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse(AppConstants.getPrivacyPolicyUrl(
                            Localizations.localeOf(context).languageCode)),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        l.privacyPolicy,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text('  ·  ', style: AppTypography.body.copyWith(color: AppColors.textSecondary, fontSize: 14)),
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse(AppConstants.getTermsOfUseUrl(
                            Localizations.localeOf(context).languageCode)),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        l.termsOfUse,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (isPurchasing)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _purchase(BuildContext context, BusinessProvider businessProvider) async {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;
    final l = AppLocalizations.of(context)!;
    try {
      final success = await businessProvider.purchasePro(userId);
      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.purchaseSuccess), backgroundColor: AppColors.success),
        );
      } else if (businessProvider.purchaseError == null) {
        // Kullanıcı iptal etti — sessiz snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.purchaseCancelled),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.textSecondary,
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.errorGeneric), backgroundColor: AppColors.danger),
      );
    }
  }

  Future<void> _restore(BuildContext context, BusinessProvider businessProvider) async {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;
    final l = AppLocalizations.of(context)!;
    final restored = await businessProvider.restorePurchases(userId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(restored ? l.restoreSuccess : l.restoreNoPurchases),
          backgroundColor: restored ? AppColors.success : AppColors.textSecondary,
        ),
      );
    }
  }
}

class _ProCard extends StatelessWidget {
  final String planTitle;
  final String price;
  final String description;
  final List<String> features;
  final bool isCurrentPlan;
  final String currentPlanLabel;
  final String? buttonLabel;
  final VoidCallback? onTap;

  const _ProCard({
    required this.planTitle,
    required this.price,
    required this.description,
    required this.features,
    required this.isCurrentPlan,
    required this.currentPlanLabel,
    this.buttonLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Top gradient banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planTitle,
                        style: AppTypography.cardTitle.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        description,
                        style: AppTypography.body.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentPlan)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      currentPlanLabel,
                      style: AppTypography.badge.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price — Apple requires subscription title, length, and price to be visible
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: AppTypography.hero.copyWith(
                        color: AppColors.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.perMonth,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.monthlySubscriptionLabel,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),

                // Features
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 13,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              f,
                              style: AppTypography.body.copyWith(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                if (buttonLabel != null) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonLabel!,
                        style: AppTypography.button.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Apple requires both Terms of Use and Privacy Policy links near the purchase button
                  Text(
                    AppLocalizations.of(context)!.subscribeAgreeTerms,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => launchUrl(
                          Uri.parse(AppConstants.getTermsOfUseUrl(
                              Localizations.localeOf(context).languageCode)),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.termsOfUse,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '  ·  ',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(
                          Uri.parse(AppConstants.getPrivacyPolicyUrl(
                              Localizations.localeOf(context).languageCode)),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.privacyPolicy,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FreeCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final bool isCurrentPlan;
  final String currentPlanLabel;

  const _FreeCard({
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.isCurrentPlan,
    required this.currentPlanLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrentPlan ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
          width: isCurrentPlan ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner — Pro ile tutarlı yapı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              color: AppColors.background,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    size: 22,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        price,
                        style: AppTypography.body.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentPlan)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      currentPlanLabel,
                      style: AppTypography.badge.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: const Divider(color: AppColors.border, height: 1),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 17,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f,
                          style: AppTypography.body.copyWith(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
