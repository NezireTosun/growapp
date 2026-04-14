import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/task.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/notification_list_provider.dart';
import 'task_detail_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardContent();
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<DashboardProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currentLocale = context.select<LocaleProvider, String>((p) => p.locale);

    // Show load error to user
    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final msg = switch (provider.errorMessage) {
          'rate_limit' => l.errorRateLimit,
          'network_error' => l.errorNetwork,
          _ => l.errorGeneric,
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
        );
        provider.clearError();
      });
    }

    // Show feedback sync error to user
    if (provider.feedbackError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.errorGeneric),
            behavior: SnackBarBehavior.floating,
          ),
        );
        provider.clearFeedbackError();
      });
    }

    // Reload tasks when locale changes
    if (provider.locale != currentLocale && !provider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.loadTasks(
          locale: currentLocale,
          businessType: provider.businessType,
        );
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: provider.isLoading
            ? const DashboardSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildHeader(context, provider, businessProvider, l),
                    const SizedBox(height: 20),
                    _buildProgressCard(provider, l),
                    const SizedBox(height: 20),
                    ...provider.tasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TaskCard(task: task),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context, DashboardProvider provider, BusinessProvider businessProvider, AppLocalizations l) {
    final hasMultiple = businessProvider.hasMultipleBusinesses;

    return Row(
      children: [
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: Color(0x303DCD78),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: hasMultiple ? () => _showBusinessSwitcher(context, businessProvider, provider, l) : null,
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.welcome,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        l.helloName(provider.businessName),
                        style: AppTypography.cardTitle.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (hasMultiple)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Notification bell
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.notifications),
          child: Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
              if (context.watch<NotificationListProvider>().unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.danger,
                    ),
                    child: Center(
                      child: Text(
                        '${context.read<NotificationListProvider>().unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBusinessSwitcher(BuildContext context, BusinessProvider businessProvider, DashboardProvider dashboardProvider, AppLocalizations l) {
    final activeBusiness = businessProvider.activeBusiness;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.75;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar + başlık — sabit
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l.myBusinesses,
                      style: AppTypography.cardTitle.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              // Scrollable liste
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  children: [
                    ...businessProvider.businesses.map((business) {
                      final isActive = business.id == activeBusiness?.id;
                      return _BusinessTile(
                        name: business.name,
                        isActive: isActive,
                        activeLabel: l.currentBusiness,
                        onTap: () async {
                          if (!isActive) {
                            businessProvider.switchBusiness(business.id);
                            final active = businessProvider.activeBusiness;
                            if (active == null) return;
                            final userId = context.read<AuthProvider>().user?.id ?? '';
                            dashboardProvider.setBusinessName(active.name);
                            dashboardProvider.setUserAndBusiness(userId, active.id);
                            final typeId = int.tryParse(active.sector ?? '') ?? 0;
                            dashboardProvider.setBusinessType(typeId);
                            dashboardProvider.setApiParams(
                              industry: active.sector ?? 'rest',
                              answers: active.apiAnswers,
                            );
                            await dashboardProvider.loadTasks(businessType: typeId);
                          }
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      );
                    }),
                    if (businessProvider.canAddBusiness) ...[
                      const SizedBox(height: 4),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.pushNamed(context, AppRouter.onboarding);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                ),
                                child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l.addBusiness,
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(DashboardProvider provider, AppLocalizations l) {
    final percent = provider.progressPercent;
    final completed = provider.completedTasks;
    final total = provider.totalTasks;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst etiket
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l.dailyGoalsProgress(completed, total),
                    style: AppTypography.badge.copyWith(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l.boostSales,
                  style: AppTypography.hero.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _CircularProgress(percent: percent),
        ],
      ),
    );
  }
}

class _CircularProgress extends StatelessWidget {
  final double percent;
  const _CircularProgress({required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _CircularProgressPainter(percent),
        child: Center(
          child: Text(
            '${(percent * 100).round()}%',
            style: AppTypography.cardTitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percent;
  _CircularProgressPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) =>
      old.percent != percent;
}

class _TaskCard extends StatelessWidget {
  final DailyTask task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final statusColor = _statusColor(task.status);
    final hasStatusBadge = task.status != TaskStatus.pending;

    final accentColor = hasStatusBadge ? statusColor : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Sol accent çizgisi
          Container(
            width: 4,
            color: accentColor.withValues(alpha: hasStatusBadge ? 0.9 : 0.5),
          ),
          Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (hasStatusBadge) _buildStatusBadge(task.status, l),
                    _buildImpactBadge(task.impact, l),
                    _buildTimeBadge(task.durationMinutes, l),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  task.title,
                  style: AppTypography.cardTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.description,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _onDetailTap(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l.details, style: AppTypography.button.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),  // Expanded
        ],
        ),  // Row
        ),  // IntrinsicHeight
      ),  // ClipRRect
    );
  }

  void _onDetailTap(BuildContext context) {
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
          onStatusChanged: (status) {
            // Dialog-based actions (done, snooze, dismiss, blacklist)
            // are handled inside TaskDetailPage directly via provider.
            // This callback handles simple status updates only.
            if (status == TaskStatus.viewed) {
              provider.markViewed(task.id);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TaskStatus status, AppLocalizations l) {
    final (label, icon, color) = switch (status) {
      TaskStatus.completed => (l.statusCompleted, Icons.check_circle, AppColors.success),
      TaskStatus.viewed => (l.statusViewed, Icons.visibility, AppColors.warning),
      TaskStatus.snoozed => (l.statusWontDo, Icons.snooze, AppColors.warning),
      TaskStatus.dismissed => (l.statusWontDo, Icons.cancel, AppColors.danger),
      TaskStatus.blacklisted => (l.statusDontSuggest, Icons.block_rounded, AppColors.textMuted),
      TaskStatus.pending => ('', Icons.circle, AppColors.textMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.badge.copyWith(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactBadge(TaskImpact impact, AppLocalizations l) {
    final (label, color) = switch (impact) {
      TaskImpact.high => (l.highImpact, AppColors.danger),
      TaskImpact.medium => (l.medImpact, AppColors.warning),
      TaskImpact.low => (l.lowImpact, AppColors.textMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.badge.copyWith(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildTimeBadge(int minutes, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            l.minutesBadge(minutes),
            style: AppTypography.badge.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(TaskStatus status) {
    return switch (status) {
      TaskStatus.completed => AppColors.success,
      TaskStatus.viewed => AppColors.warning,
      TaskStatus.snoozed => AppColors.warning,
      TaskStatus.dismissed => AppColors.danger,
      TaskStatus.blacklisted => AppColors.textMuted,
      TaskStatus.pending => AppColors.border,
    };
  }
}

class _BusinessTile extends StatelessWidget {
  final String name;
  final bool isActive;
  final String activeLabel;
  final VoidCallback onTap;

  const _BusinessTile({
    required this.name,
    required this.isActive,
    required this.activeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.store_rounded,
                color: isActive ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  activeLabel,
                  style: AppTypography.badge.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return const AppBottomNav(activeTab: BottomNavTab.home);
  }
}
