import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/business_repository_impl.dart';
import '../../../data/repositories/onboarding_repository_impl.dart';
import '../../../domain/entities/onboarding_step.dart';
import '../../providers/locale_provider.dart';
import 'ai_analysis_page.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../providers/onboarding_provider.dart';
import 'business_name_page.dart';
import 'business_type_page.dart';
import 'pain_point_page.dart';
import 'survey/survey_page.dart';

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.read<LocaleProvider>().locale;
    final isAddingBusiness = ModalRoute.of(context)?.settings.arguments == true;
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(OnboardingRepositoryImpl(), BusinessRepositoryImpl())..initialize(locale: locale),
      child: _OnboardingContent(isAddingBusiness: isAddingBusiness),
    );
  }
}


class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({required this.isAddingBusiness});

  final bool isAddingBusiness;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    final step = provider.currentStep;

    // İlk yükleme: henüz step yok
    if (step == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: OnboardingSkeleton(),
      );
    }

    if (provider.error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Error: ${provider.error}')),
      );
    }

    // isLoading sırasında skeleton gösterme — aiAnalysis adımındayken
    // skeleton AiAnalysisPage'i dispose eder ve timer'lar sıfırlanır
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildStep(step),
    );
  }

  Widget _buildStep(OnboardingStep step) {
    switch (step.type) {
      case OnboardingStepType.businessName:
        return const BusinessNamePage(key: ValueKey('businessName'));
      case OnboardingStepType.businessType:
        return const BusinessTypePage(key: ValueKey('businessType'));
      case OnboardingStepType.survey:
        return const SurveyPage(key: ValueKey('survey'));
      case OnboardingStepType.painPoints:
        return const PainPointPage(key: ValueKey('painPoints'));
      case OnboardingStepType.aiAnalysis:
        return AiAnalysisPage(key: const ValueKey('aiAnalysis'), isAddingBusiness: isAddingBusiness);
    }
  }
}
