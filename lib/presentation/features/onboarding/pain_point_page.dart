import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class PainPointPage extends StatelessWidget {
  const PainPointPage({super.key});

  static const _iconMap = <String, IconData>{
    'groups': Icons.groups_rounded,
    'trending_down': Icons.trending_down_rounded,
    'inventory_2': Icons.inventory_2_rounded,
    'schedule': Icons.schedule_rounded,
    'restaurant_menu': Icons.restaurant_menu_rounded,
    'help': Icons.help_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<OnboardingProvider>();
    final step = provider.currentStep;
    final options = provider.painPoints;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    OnboardingBackButton(
                      onTap: () => provider.previousStep(),
                    ),
                    const SizedBox(height: 24),
                    OnboardingTitle(title: step?.title ?? ''),
                    if (step?.subtitle != null) ...[
                      const SizedBox(height: 8),
                      OnboardingSubtitle(text: step?.subtitle ?? ''),
                    ],
                    const SizedBox(height: 32),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.15,
                      ),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected =
                            provider.isPainPointSelected(option.id);
                        final icon =
                            _iconMap[option.icon] ?? Icons.help_outline;

                        return GestureDetector(
                          onTap: () => provider.togglePainPoint(option.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                            .withValues(alpha: 0.08)
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    icon,
                                    size: 24,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  option.label,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.cardTitle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Fixed bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: OnboardingPrimaryButton(
                text: l.painPointContinue,
                onPressed: provider.selectedPainPointIds.isNotEmpty
                    ? () => provider.nextStep()
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
