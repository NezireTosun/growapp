import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<NotificationProvider>().load(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.notificationSettings,
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return ShimmerEffect(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: List.generate(4, (i) => const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: SkeletonBox(height: 56, borderRadius: 16),
                  )),
                ),
              ),
            );
          }

          final s = provider.settings;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                _toggleItem(
                  l.dailyTaskReminders,
                  s.dailyReminders,
                  (_) => provider.toggle('daily_reminders'),
                ),
                const SizedBox(height: 20),
                _toggleItem(
                  l.offPeakDeals,
                  s.offPeakDeals,
                  (_) => provider.toggle('off_peak_deals'),
                ),
                const SizedBox(height: 20),
                _toggleItem(
                  l.weeklyProgressReport,
                  s.weeklyReport,
                  (_) => provider.toggle('weekly_report'),
                ),
                const SizedBox(height: 20),
                _toggleItem(
                  l.newFeaturesUpdates,
                  s.newFeatures,
                  (_) => provider.toggle('new_features'),
                ),
                const SizedBox(height: 24),
                Text(
                  l.notificationWarning,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _toggleItem(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
        ),
      ],
    );
  }
}
