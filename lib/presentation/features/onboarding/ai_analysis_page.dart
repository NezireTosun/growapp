import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/notification_list_provider.dart';
import '../../providers/onboarding_provider.dart';

class AiAnalysisPage extends StatefulWidget {
  const AiAnalysisPage({super.key});

  @override
  State<AiAnalysisPage> createState() => _AiAnalysisPageState();
}

class _AiAnalysisPageState extends State<AiAnalysisPage>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  double _progress = 0.0;
  Timer? _stepTimer;
  Timer? _progressTimer;

  late AnimationController _pulseController;
  late AnimationController _rotateController;

  List<String> _getSteps(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.analysisStep1,
      l.analysisStep2,
      l.analysisStep3,
      l.analysisStep4,
      l.analysisStep5,
    ];
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _startAnalysis();
  }

  void _startAnalysis() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _progress += 0.005;
        if (_progress >= 1.0) { _progress = 1.0; t.cancel(); }
      });
    });
    _stepTimer = Timer.periodic(const Duration(milliseconds: 1800), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_currentStep < 4) {
        setState(() => _currentStep++);
      } else {
        t.cancel();
        _onAnalysisComplete();
      }
    });
  }

  int _sectorToTypeId(String sector) {
    return switch (sector.toLowerCase()) {
      'cafe' => 1,
      'rest' || 'restaurant' => 2,
      _ => 1,
    };
  }

  void _onAnalysisComplete() {
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (!mounted) return;
      final onboarding = context.read<OnboardingProvider>();
      final userId = context.read<AuthProvider>().user?.id ?? '';
      final planId = context.read<AuthProvider>().user?.planId ?? 'free';

      // Hata olsa bile dashboard'a geç — veri kısmen kaydedilmiş olabilir
      try {
        await onboarding.completeOnboarding(userId);
      } catch (e) {
        debugPrint('[AiAnalysis] completeOnboarding error (devam ediliyor): $e');
      }

      if (!mounted) return;
      final businessProvider = context.read<BusinessProvider>();
      await businessProvider.initialize(userId, planId);
      if (!mounted) return;
      context.read<NotificationProvider>().load(userId);
      context.read<NotificationListProvider>().load(userId);
      final dashboard = context.read<DashboardProvider>();
      final active = businessProvider.activeBusiness;
      if (active != null) {
        dashboard.setBusinessName(active.name);
        dashboard.setUserAndBusiness(userId, active.id);
        final sectorStr = active.sector ?? '';
        final typeId = int.tryParse(sectorStr) ?? _sectorToTypeId(sectorStr);
        dashboard.setBusinessType(typeId);
        // api_answers önce Firestore'dan al, yoksa onboarding provider'dan al
        final answers = active.apiAnswers.isNotEmpty
            ? active.apiAnswers
            : onboarding.apiAnswers;
        dashboard.setApiParams(
          industry: sectorStr.isNotEmpty ? sectorStr : 'rest',
          answers: answers,
        );
        await dashboard.loadTasks(locale: onboarding.locale, businessType: typeId);
        if (!mounted) return;
      }
      Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.dashboard, (r) => false);
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _progressTimer?.cancel();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final steps = _getSteps(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // Logo + başlık
              Center(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, child) => Opacity(
                        opacity: 0.7 + _pulseController.value * 0.3,
                        child: child,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l.aiAnalyzingTitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.hero.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.aiAnalyzingSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Adımlar
              ...List.generate(steps.length, (i) {
                final isDone = i < _currentStep;
                final isCurrent = i == _currentStep;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: i > _currentStep ? 0.25 : 1.0,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: isDone
                              ? const Icon(Icons.check_circle_rounded,
                                  size: 20, color: AppColors.success)
                              : isCurrent
                                  ? AnimatedBuilder(
                                      animation: _rotateController,
                                      builder: (_, _) => Transform.rotate(
                                        angle: _rotateController.value * 6.28,
                                        child: const Icon(Icons.sync_rounded,
                                            size: 20, color: AppColors.primary),
                                      ),
                                    )
                                  : const Icon(Icons.radio_button_unchecked,
                                      size: 20, color: AppColors.border),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: AppTypography.body.copyWith(
                              fontSize: 14,
                              color: isCurrent
                                  ? AppColors.textPrimary
                                  : isDone
                                      ? AppColors.textSecondary
                                      : AppColors.textMuted,
                              fontWeight: isCurrent
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 8),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 4,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
