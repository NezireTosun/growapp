enum OnboardingStepType { businessName, businessType, survey, painPoints, aiAnalysis }

class OnboardingStep {
  final String id;
  final OnboardingStepType type;
  final String title;
  final String? subtitle;
  final int order;

  const OnboardingStep({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.order,
  });
}
