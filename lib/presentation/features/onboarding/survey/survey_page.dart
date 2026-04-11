import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../domain/entities/survey_question.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_scaffold.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final questions = provider.surveyQuestions;
    final currentIndex = provider.currentSurveyIndex;
    final question = provider.currentSurveyQuestion;

    if (question == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: OnboardingSkeleton(),
      );
    }

    final selectedIndex = provider.getSelectedOptionIndex(question.id);
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  OnboardingBackButton(
                    onTap: () {
                      if (!provider.previousSurveyQuestion()) {
                        provider.previousStep();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${currentIndex + 1} / ${questions.length}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: OnboardingTitle(
                  key: ValueKey(question.id),
                  title: question.question,
                ),
              ),
              const SizedBox(height: 32),
              ...List.generate(question.options.length, (index) {
                final option = question.options[index];
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OnboardingOptionCard(
                    label: option.label,
                    isSelected: isSelected,
                    leading: option.mood != null
                        ? Icon(
                            switch (option.mood!) {
                              SurveyMood.happy =>
                                Icons.sentiment_satisfied_rounded,
                              SurveyMood.neutral =>
                                Icons.sentiment_neutral_rounded,
                              SurveyMood.sad =>
                                Icons.sentiment_dissatisfied_rounded,
                            },
                            size: 28,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          )
                        : null,
                    onTap: () {
                      provider.answerSurveyQuestion(question.id, option.id);

                      Future.delayed(const Duration(milliseconds: 400), () {
                        if (!mounted) return;
                        final isComplete = provider.nextSurveyQuestion();
                        if (isComplete) {
                          provider.nextStep();
                        }
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
