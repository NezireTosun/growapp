class NotificationSettings {
  final bool dailyReminders;
  final bool offPeakDeals;
  final bool weeklyReport;
  final bool newFeatures;

  const NotificationSettings({
    this.dailyReminders = true,
    this.offPeakDeals = true,
    this.weeklyReport = false,
    this.newFeatures = true,
  });

  NotificationSettings copyWith({
    bool? dailyReminders,
    bool? offPeakDeals,
    bool? weeklyReport,
    bool? newFeatures,
  }) {
    return NotificationSettings(
      dailyReminders: dailyReminders ?? this.dailyReminders,
      offPeakDeals: offPeakDeals ?? this.offPeakDeals,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      newFeatures: newFeatures ?? this.newFeatures,
    );
  }

  Map<String, dynamic> toMap() => {
        'daily_reminders': dailyReminders,
        'off_peak_deals': offPeakDeals,
        'weekly_report': weeklyReport,
        'new_features': newFeatures,
      };

  factory NotificationSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const NotificationSettings();
    return NotificationSettings(
      dailyReminders: map['daily_reminders'] as bool? ?? true,
      offPeakDeals: map['off_peak_deals'] as bool? ?? true,
      weeklyReport: map['weekly_report'] as bool? ?? false,
      newFeatures: map['new_features'] as bool? ?? true,
    );
  }
}
