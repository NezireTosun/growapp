import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';
import '../router/app_router.dart';
import '../../l10n/app_localizations.dart';

enum BottomNavTab { home, analytics, blog, profile }

class AppBottomNav extends StatelessWidget {
  final BottomNavTab activeTab;

  const AppBottomNav({super.key, required this.activeTab});

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
              _navItem(context, Icons.home_rounded, l.navHome, activeTab == BottomNavTab.home,
                  onTap: () => Navigator.pushReplacementNamed(context, AppRouter.dashboard)),
              _navItem(context, Icons.bar_chart_rounded, l.navAnalytics, activeTab == BottomNavTab.analytics,
                  onTap: () => Navigator.pushReplacementNamed(context, AppRouter.analytics)),
              _navItem(context, Icons.article_rounded, l.navBlog, activeTab == BottomNavTab.blog,
                  onTap: () => Navigator.pushReplacementNamed(context, AppRouter.blog)),
              _navItem(context, Icons.person_outline_rounded, l.navProfile, activeTab == BottomNavTab.profile,
                  onTap: () => Navigator.pushReplacementNamed(context, AppRouter.profile)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
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
