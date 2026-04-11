import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/task.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/dashboard_provider.dart';
import '../dashboard/task_detail_page.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l.navHome,
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : provider.tasks.isEmpty
              ? _buildEmpty(l)
              : _buildList(context, provider, l),
      bottomNavigationBar: _BottomNavBar(),
    );
  }

  Widget _buildEmpty(AppLocalizations l) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 36,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.noTasksYet,
              style: AppTypography.cardTitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.noTasksYetSubtitle,
              style: AppTypography.body.copyWith(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, DashboardProvider provider, AppLocalizations l) {
    final completed = provider.tasks
        .where((t) => t.status == TaskStatus.completed)
        .toList();
    final active = provider.tasks
        .where((t) => t.status != TaskStatus.completed)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        if (active.isNotEmpty) ...[
          _sectionHeader(l.dailyTaskReminders),
          const SizedBox(height: 12),
          ...active.map((task) => _TaskRow(task: task)),
        ],
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 24),
          _sectionHeader(l.statusCompleted),
          const SizedBox(height: 12),
          ...completed.map((task) => _TaskRow(task: task)),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.badge.copyWith(
        color: AppColors.textMuted,
        letterSpacing: 1,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final DailyTask task;
  const _TaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    final isDismissed = task.status == TaskStatus.dismissed ||
        task.status == TaskStatus.blacklisted;

    return GestureDetector(
      onTap: () {
        final provider = context.read<DashboardProvider>();
        provider.markViewed(task.id);
        final tasks = provider.tasks;
        final index = tasks.indexWhere((t) => t.id == task.id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TaskDetailPage(
              task: tasks[index],
              taskIndex: index,
              totalTasks: tasks.length,
              onStatusChanged: (_) {},
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.success
                    : isDismissed
                        ? AppColors.border
                        : Colors.transparent,
                border: isCompleted || isDismissed
                    ? null
                    : Border.all(color: AppColors.border, width: 1.5),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                task.title,
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDismissed
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                  decoration: isDismissed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, Icons.home_rounded, l.navHome, false,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, AppRouter.dashboard)),
              _navItem(context, Icons.bar_chart_rounded, l.navAnalytics, false,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, AppRouter.analytics)),
              _navItem(context, Icons.article_rounded, l.navBlog, false,
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, AppRouter.blog)),
              _navItem(
                  context, Icons.person_outline_rounded, l.navProfile, false,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, AppRouter.profile)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    final color = isActive ? AppColors.primary : AppColors.iconInactive;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
