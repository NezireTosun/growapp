import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      final biz = context.read<BusinessProvider>();
      final user = auth.user;
      final activeBiz = biz.activeBusiness;
      if (user != null && activeBiz != null) {
        context.read<AnalyticsProvider>().loadAnalytics(
              userId: user.id,
              businessId: activeBiz.id,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isPremium = context.select<BusinessProvider, bool>((b) => b.isPremium);
    final isLoading = context.select<AnalyticsProvider, bool>((a) => a.isLoading);
    final errorMessage = context.select<AnalyticsProvider, String?>((a) => a.errorMessage);
    final provider = context.read<AnalyticsProvider>();

    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final msg = switch (errorMessage) {
          'network_error' => l.errorNetwork,
          _ => l.errorGeneric,
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
        );
        provider.clearError();
      });
    }

    final content = Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(l),
      body: isLoading
          ? const AnalyticsSkeleton()
          : _buildWeeklyTab(l, provider),
      bottomNavigationBar: _buildBottomNav(context),
    );

    if (isPremium) return content;

    // Free kullanıcı: aynı sayfa blurlu + kilit overlay (screenshot'taki tasarım)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.dashboard),
        ),
        title: Text(l.successAnalytics, style: AppTypography.cardTitle.copyWith(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 22, color: AppColors.textPrimary),
            onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.dashboard),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Blurlu arka plan içerik
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStreakRow(l, provider),
                  const SizedBox(height: 28),
                  _buildChartSection(
                    title: l.weeklyPerformance,
                    total: 18,
                    changePercent: 12,
                    bars: const [5, 2, 6, 3, 7, 4, 0],
                    labels: _weekdayLabels(Localizations.localeOf(context).languageCode),
                    highlightIndex: 0,
                    l: l,
                    periodLabel: l.thisWeek,
                  ),
                ],
              ),
            ),
          ),
          // Hafif beyaz üst örtü
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.15)),
          ),
          // Ortalanmış kilit modal kartı
          Center(
            child: _buildFreeOverlay(context, l),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
        onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.dashboard),
      ),
      title: Text(l.successAnalytics, style: AppTypography.cardTitle.copyWith(fontSize: 18)),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: const Divider(height: 1, thickness: 0.5, color: AppColors.border),
      ),
    );
  }


  // ───────── Tabs ─────────

  Widget _buildWeeklyTab(AppLocalizations l, AnalyticsProvider p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStreakRow(l, p),
          const SizedBox(height: 16),
          _buildAllTimeSummary(l, p),
          const SizedBox(height: 28),
          _buildChartSection(
            title: l.weeklyPerformance,
            total: p.thisWeekTotal,
            changePercent: p.weekChangePercent,
            bars: p.thisWeekDaily,
            labels: _weekdayLabels(Localizations.localeOf(context).languageCode),
            highlightIndex: DateTime.now().weekday - 1,
            l: l,
            periodLabel: l.thisWeek,
          ),
          if (p.categories.isNotEmpty) ...[
            const SizedBox(height: 28),
            _buildCategorySection(l, p),
          ],
        ],
      ),
    );
  }

  // ───────── Streak Row ─────────

  Widget _buildStreakRow(AppLocalizations l, AnalyticsProvider p) {
    final isPositiveToday = p.completedToday > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Ateş ikonu — ortada daire içinde
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              size: 28,
              color: Color(0xFFF97316),
            ),
          ),
          const SizedBox(height: 12),
          // GÜNCEL SERİ caption
          Text(
            l.currentStreak.toUpperCase(),
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          // 15 Gün büyük sayı
          Text(
            l.streakDays(p.streakDays),
            style: AppTypography.cardTitle.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          // +2 bugün yeşil badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isPositiveToday
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositiveToday
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 12,
                  color: isPositiveToday ? AppColors.success : AppColors.danger,
                ),
                const SizedBox(width: 4),
                Text(
                  l.todayPlus(p.completedToday),
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositiveToday ? AppColors.success : AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────── All-Time Summary ─────────

  Widget _buildAllTimeSummary(AppLocalizations l, AnalyticsProvider p) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.allTimeTaskSummary,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      l.activeDaysCount(p.activeDays),
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l.activeDaysLabel,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildSummaryStatCard(
                icon: Icons.check_circle_rounded,
                color: AppColors.success,
                label: l.completed,
                value: p.totalCompleted,
              )),
              const SizedBox(width: 10),
              Expanded(child: _buildSummaryStatCard(
                icon: Icons.snooze_rounded,
                color: AppColors.warning,
                label: l.snoozed,
                value: p.totalSnoozed,
              )),
              const SizedBox(width: 10),
              Expanded(child: _buildSummaryStatCard(
                icon: Icons.cancel_rounded,
                color: AppColors.danger,
                label: l.dismissed,
                value: p.totalDismissed,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatCard({
    required IconData icon,
    required Color color,
    required String label,
    required int value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: AppTypography.cardTitle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ───────── Chart Section ─────────

  Widget _buildChartSection({
    required String title,
    required int total,
    required int changePercent,
    required List<int> bars,
    required List<String> labels,
    required int highlightIndex,
    required AppLocalizations l,
    String? periodLabel,
  }) {
    final maxVal = bars.fold<int>(0, (a, b) => a > b ? a : b);
    final isPositive = changePercent >= 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık satırı: "Haftalık Performans" bold siyah + "Bu Hafta" mavi sağda
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (periodLabel != null)
                Text(
                  periodLabel,
                  style: AppTypography.caption.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // "Tamamlanan Görevler" + sayı + badge
          Text(
            l.completedTasksCount,
            style: AppTypography.caption.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$total',
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              if (changePercent != 0) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        size: 11,
                        color: isPositive ? AppColors.success : AppColors.danger,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        isPositive
                            ? l.vsLastWeek(changePercent)
                            : l.vsLastWeekNeg(changePercent),
                        style: AppTypography.caption.copyWith(
                          color: isPositive ? AppColors.success : AppColors.danger,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // Bars
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (i) {
                final val = bars[i];
                final barH = maxVal > 0 ? (val / maxVal) * 80.0 : 0.0;
                final isHighlight = i == highlightIndex;
                final padding = bars.length > 10 ? 1.5 : 3.5;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          height: barH < 4 && val > 0 ? 4 : barH,
                          decoration: BoxDecoration(
                            color: isHighlight
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          labels.length > i ? labels[i] : '',
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: isHighlight ? AppColors.primary : AppColors.textMuted,
                            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Category Section ─────────

  Widget _buildCategorySection(AppLocalizations l, AnalyticsProvider p) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.categoryDistribution,
            style: AppTypography.cardTitle.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...p.categories.map((cat) {
            final label = _categoryLabel(l, cat.categoryId);
            final color = _categoryColor(cat.categoryId);
            final icon = _categoryIcon(cat.categoryId);
            final percent = (cat.percent * 100).round();

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // İkon daire
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 20, color: color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: AppTypography.caption.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: cat.percent,
                      backgroundColor: color.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ───────── Free Overlay ─────────

  Widget _buildFreeOverlay(BuildContext context, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 32, offset: const Offset(0, 8)),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kilit ikonu — daire içinde
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_rounded, size: 32, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              l.premiumContent,
              style: AppTypography.hero.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l.premiumContentDesc,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRouter.subscription),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 0,
                ),
                child: Text(
                  l.premiumBuyNow,
                  style: AppTypography.button.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── Helpers ─────────

  List<String> _weekdayLabels(String locale) {
    switch (locale) {
      case 'tr': return ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz'];
      case 'de': return ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
      case 'es': return ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
      case 'cs': return ['Po', 'Út', 'St', 'Čt', 'Pá', 'So', 'Ne'];
      default:   return ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    }
  }

  String _categoryLabel(AppLocalizations l, String id) {
    final n = id.toLowerCase().replaceAll(RegExp(r'[_\-\s]'), '');
    if (n.contains('acquisition') || n.contains('kazanim')) return l.catAcquisition;
    if (n.contains('conversion') || n.contains('donusum')) return l.catConversion;
    if (n.contains('retention') || n.contains('sadakat')) return l.catRetention;
    if (n.contains('operation') || n.contains('operasyon')) return l.catOperations;
    if (n.contains('b2b')) return l.catB2bSales;
    if (n.contains('analytics') || n.contains('analitik')) return l.catAnalytics;
    if (n.contains('staff') || n.contains('personel')) return l.catStaffManagement;
    if (n.contains('socialproof') || n.contains('sosyalkanit')) return l.catSocialProof;
    if (n.contains('profitab') || n.contains('karlilik')) return l.catProfitability;
    if (n.contains('salespower') || n.contains('satisgucu')) return l.catSalesPower;
    if (n.contains('experience') || n.contains('deneyim')) return l.catExperience;
    if (n.contains('local') || n.contains('yerel')) return l.catLocal;
    if (n.contains('upsell') || n.contains('capraz')) return l.catUpsell;
    return l.catOther;
  }

  IconData _categoryIcon(String id) {
    final n = id.toLowerCase().replaceAll(RegExp(r'[_\-\s]'), '');
    if (n.contains('acquisition') || n.contains('kazanim')) return Icons.person_add_rounded;
    if (n.contains('conversion') || n.contains('donusum')) return Icons.swap_horiz_rounded;
    if (n.contains('retention') || n.contains('sadakat')) return Icons.favorite_rounded;
    if (n.contains('operation') || n.contains('operasyon')) return Icons.settings_rounded;
    if (n.contains('b2b')) return Icons.handshake_rounded;
    if (n.contains('analytics') || n.contains('analitik')) return Icons.bar_chart_rounded;
    if (n.contains('staff') || n.contains('personel')) return Icons.group_rounded;
    if (n.contains('socialproof') || n.contains('sosyalkanit')) return Icons.star_rounded;
    if (n.contains('profitab') || n.contains('karlilik')) return Icons.trending_up_rounded;
    if (n.contains('salespower') || n.contains('satisgucu')) return Icons.campaign_rounded;
    if (n.contains('experience') || n.contains('deneyim')) return Icons.emoji_emotions_rounded;
    if (n.contains('local') || n.contains('yerel')) return Icons.location_on_rounded;
    if (n.contains('upsell') || n.contains('capraz')) return Icons.add_shopping_cart_rounded;
    if (n.contains('musteri') || n.contains('customer') || n.contains('hizmet') || n.contains('service')) return Icons.headset_mic_rounded;
    if (n.contains('satis') || n.contains('sales') || n.contains('sosyal') || n.contains('social')) return Icons.campaign_rounded;
    return Icons.category_rounded;
  }

  Color _categoryColor(String id) {
    final n = id.toLowerCase().replaceAll(RegExp(r'[_\-\s]'), '');
    if (n.contains('acquisition')) return AppColors.primary;
    if (n.contains('conversion')) return const Color(0xFF8B5CF6);
    if (n.contains('retention')) return const Color(0xFFEC4899);
    if (n.contains('operation')) return AppColors.warning;
    if (n.contains('b2b')) return const Color(0xFF1B2559);
    if (n.contains('analytics') || n.contains('analitik')) return const Color(0xFF06B6D4);
    if (n.contains('staff') || n.contains('personel')) return const Color(0xFF6366F1);
    if (n.contains('socialproof')) return const Color(0xFFF59E0B);
    if (n.contains('profitab')) return AppColors.success;
    if (n.contains('salespower')) return const Color(0xFFEF4444);
    if (n.contains('experience')) return const Color(0xFF14B8A6);
    if (n.contains('local')) return const Color(0xFFD97706);
    if (n.contains('upsell')) return const Color(0xFF7C3AED);
    return AppColors.textSecondary;
  }

  Widget _buildBottomNav(BuildContext context) {
    return const AppBottomNav(activeTab: BottomNavTab.analytics);
  }
}
