import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class BusinessNamePage extends StatefulWidget {
  const BusinessNamePage({super.key});

  @override
  State<BusinessNamePage> createState() => _BusinessNamePageState();
}

class _BusinessNamePageState extends State<BusinessNamePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<OnboardingProvider>();
    _controller.text = provider.businessName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.read<OnboardingProvider>();
    final step = provider.currentStep;

    return OnboardingScaffold(
      title: step?.title ?? l.businessNameFallback,
      onBack: () => Navigator.of(context).pop(),
      bottomButton: OnboardingPrimaryButton(
        text: l.continueButton,
        onPressed: () {
          final name = _controller.text.trim();
          if (name.isEmpty) return;
          provider.setBusinessName(name);
          provider.nextStep();
        },
      ),
      children: [
        OnboardingTextField(
          controller: _controller,
          hintText: l.enterBusinessName,
        ),
      ],
    );
  }
}
