import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/task.dart';
import '../../../l10n/app_localizations.dart';
import '../../../presentation/providers/dashboard_provider.dart';
import '../../features/profile/contact_page.dart';

class TaskDetailPage extends StatelessWidget {
  final DailyTask task;
  final int taskIndex;
  final int totalTasks;
  final void Function(TaskStatus status) onStatusChanged;

  const TaskDetailPage({
    super.key,
    required this.task,
    required this.taskIndex,
    required this.totalTasks,
    required this.onStatusChanged,
  });

  // ─── 1. DONE — puan göster, ROI sor ───
  void _onDone(BuildContext context) async {
    final provider = context.read<DashboardProvider>();
    final points = await provider.markCompleted(task.id);

    if (!context.mounted) return;
    Navigator.pop(context);

    // Pozitif pekiştirme + puan göster
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final dl = AppLocalizations.of(dialogCtx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.warning, size: 28),
              const SizedBox(width: 8),
              Text(l.pointsEarned(points), style: AppTypography.hero.copyWith(fontSize: 20)),
            ],
          ),
          content: Text(dl.taskCompletedMsg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(dl.ok),
            ),
          ],
        );
      },
    ).then((_) {
      // Dialog kapandıktan sonra confetti tetikle
      onStatusChanged(TaskStatus.completed);
    });
  }

  // ─── 2. SNOOZE — direkt kaydet ───
  void _onSnooze(BuildContext context) async {
    final provider = context.read<DashboardProvider>();
    await provider.markSnoozed(task.id, duration: const Duration(days: 1));
    if (context.mounted) Navigator.pop(context);
  }

  // ─── 3. BLACKLIST — direkt kaydet ───
  void _onBlacklist(BuildContext context) async {
    final provider = context.read<DashboardProvider>();
    await provider.markBlacklisted(task.id);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurface, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          l.taskDetails,
          style: AppTypography.cardTitle.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      l.dailyTaskCounter(taskIndex + 1, totalTasks),
                      style: AppTypography.badge.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    task.title,
                    style: AppTypography.hero.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (task.whyImportant != null) ...[
                    _WhyCard(text: task.whyImportant!, label: l.whyItMakesMoney),
                    const SizedBox(height: 20),
                  ],
                  if (task.steps.isNotEmpty) ...[
                    Text(l.howToDoIt,
                        style: AppTypography.cardTitle.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    ...List.generate(task.steps.length, (index) {
                      final step = task.steps[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _StepCard(stepNumber: index + 1, title: step.text, description: ''),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                  if (task.shareTemplate != null) ...[
                    Text(l.readyMadeTemplate,
                        style: AppTypography.cardTitle.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    _ShareTemplateCard(template: task.shareTemplate!),
                    const SizedBox(height: 20),
                  ],
                  const _SupportCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Bottom action buttons
          _BottomActions(
            onDone: () => _onDone(context),
            onSnooze: () => _onSnooze(context),
            onBlacklist: () => _onBlacklist(context),
          ),
        ],
      ),
    );
  }
}

// ─── WHY CARD ───

class _WhyCard extends StatelessWidget {
  final String text;
  final String label;

  const _WhyCard({required this.text, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: AppTypography.badge.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: AppTypography.body.copyWith(
              fontSize: 14,
              height: 1.65,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── STEP CARD ───

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;

  const _StepCard({required this.stepNumber, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text('$stepNumber',
                  style: AppTypography.badge.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.cardTitle.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(description, style: AppTypography.body.copyWith(fontSize: 12, height: 1.5)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SHARE TEMPLATE CARD ───

class _ShareTemplateCard extends StatelessWidget {
  final String template;

  const _ShareTemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(template, style: AppTypography.body.copyWith(fontSize: 13, height: 1.5, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: template));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.copied), duration: const Duration(seconds: 2)),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: Text(l.copy),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SUPPORT CARD ───

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.textPrimary, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Icon(Icons.headset_mic_rounded, size: 32, color: Colors.white),
          const SizedBox(height: 10),
          Text(l.wereHereToHelp,
              style: AppTypography.cardTitle.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(l.needHelpTask,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactPage()));
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: Text(l.contactUs),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── BOTTOM ACTIONS ───

class _BottomActions extends StatelessWidget {
  final VoidCallback onDone;
  final VoidCallback onSnooze;
  final VoidCallback onBlacklist;

  const _BottomActions({
    required this.onDone,
    required this.onSnooze,
    required this.onBlacklist,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Yaptım (Done)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onDone,
              icon: const Icon(Icons.check_circle_rounded, size: 20),
              label: Text(l.done),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
                textStyle: AppTypography.button.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // 2. Daha Sonra (Snooze)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onSnooze,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: AppTypography.button.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              child: Text(l.snooze),
            ),
          ),
          const SizedBox(height: 8),
          // 3. Bir Daha Önerme (Blacklist)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onBlacklist,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: AppTypography.button.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              child: Text(l.dontSuggest),
            ),
          ),
        ],
      ),
    );
  }
}
