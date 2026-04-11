import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

const _iconMap = <String, IconData>{
  'restaurant': Icons.restaurant,
  'coffee': Icons.coffee,
  'shopping_bag': Icons.shopping_bag_outlined,
  'build': Icons.build_outlined,
};

class BusinessTypePage extends StatefulWidget {
  const BusinessTypePage({super.key});

  @override
  State<BusinessTypePage> createState() => _BusinessTypePageState();
}

class _BusinessTypePageState extends State<BusinessTypePage> {
  int? _selectedIndex;

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);

    final provider = context.read<OnboardingProvider>();
    provider.selectBusinessType(index).then((_) {
      if (!mounted) return;

      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        provider.nextStep();
      });
    });
  }

  Widget _buildIconBox({
    required IconData icon,
    required bool isSelected,
    required bool isDisabled,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDisabled
            ? AppColors.background
            : isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 20,
        color: isDisabled
            ? AppColors.textMuted
            : isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<OnboardingProvider>();
    final step = provider.currentStep;
    final types = provider.businessTypes;

    return OnboardingScaffold(
      title: step?.title ?? l.businessTypeFallback,
      subtitle: step?.subtitle,
      onBack: () => provider.previousStep(),
      children: List.generate(types.length, (index) {
        final option = types[index];
        final isSelected = _selectedIndex == index;
        final icon = _iconMap[option.icon] ?? Icons.business;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OnboardingOptionCard(
            label: option.name,
            isSelected: isSelected,
            isDisabled: !option.isAvailable,
            disabledBadge: l.comingSoon,
            onTap: () => _onSelect(index),
            leading: _buildIconBox(
              icon: icon,
              isSelected: isSelected,
              isDisabled: !option.isAvailable,
            ),
          ),
        );
      }),
    );
  }
}
