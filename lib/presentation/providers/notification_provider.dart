import 'package:growapp/core/utils/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/notification_settings.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  NotificationSettings _settings = const NotificationSettings();
  bool _isLoading = false;
  String? _userId;

  NotificationSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> load(String userId) async {
    _userId = userId;
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _db.collection('users').doc(userId).get();
      final data = doc.data();
      _settings = NotificationSettings.fromMap(
        data?['notification_settings'] as Map<String, dynamic>?,
      );
    } catch (e) {
      AppLogger.e('[NotificationProvider]', 'load error', e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> update(NotificationSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();

    if (_userId != null) {
      await _db.collection('users').doc(_userId).set({
        'notification_settings': newSettings.toMap(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> toggle(String key) async {
    switch (key) {
      case 'daily_reminders':
        await update(_settings.copyWith(dailyReminders: !_settings.dailyReminders));
      case 'off_peak_deals':
        await update(_settings.copyWith(offPeakDeals: !_settings.offPeakDeals));
      case 'weekly_report':
        await update(_settings.copyWith(weeklyReport: !_settings.weeklyReport));
      case 'new_features':
        await update(_settings.copyWith(newFeatures: !_settings.newFeatures));
    }
  }
}
