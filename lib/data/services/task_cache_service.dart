import 'package:growapp/core/utils/app_logger.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/task.dart';

/// Günlük görevleri encrypted secure storage'a yazar ve okur.
/// Sadece bugünün verisini cache'ler; farklı gün için cache geçersizdir.
class TaskCacheService {
  static const _keyPrefix = 'task_cache_';
  static const _keyDate = 'task_cache_date_';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static String _cacheKey(String userId, String businessId) =>
      '$_keyPrefix${userId}_$businessId';

  static String _dateKey(String userId, String businessId) =>
      '$_keyDate${userId}_$businessId';

  static String _today() {
    // toLocal() ile DST geçişlerinde yanlış gün hesabını önle
    final now = DateTime.now().toLocal();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Görevleri encrypted cache'e yaz
  static Future<void> saveTasks({
    required String userId,
    required String businessId,
    required List<DailyTask> tasks,
  }) async {
    try {
      final json = jsonEncode(tasks.map(_taskToMap).toList());
      await _storage.write(key: _cacheKey(userId, businessId), value: json);
      await _storage.write(key: _dateKey(userId, businessId), value: _today());
      AppLogger.d('[TaskCacheService]', '${tasks.length} görev cache\'e yazıldı');
    } catch (e) {
      AppLogger.e('[TaskCacheService]', 'saveTasks error', e);
    }
  }

  /// Bugünün cache'ini oku — yoksa veya tarih geçmişse null döner
  static Future<List<DailyTask>?> loadTasks({
    required String userId,
    required String businessId,
  }) async {
    try {
      final cachedDate = await _storage.read(key: _dateKey(userId, businessId));
      if (cachedDate != _today()) return null;

      final json = await _storage.read(key: _cacheKey(userId, businessId));
      if (json == null) return null;

      final list = jsonDecode(json) as List<dynamic>;
      final tasks = list.map((e) => _taskFromMap(e as Map<String, dynamic>)).toList();
      AppLogger.d('[TaskCacheService]', '${tasks.length} görev cache\'den yüklendi');
      return tasks;
    } catch (e) {
      AppLogger.e('[TaskCacheService]', 'loadTasks error', e);
      return null;
    }
  }

  /// Cache'i temizle
  static Future<void> clearTasks({
    required String userId,
    required String businessId,
  }) async {
    await _storage.delete(key: _cacheKey(userId, businessId));
    await _storage.delete(key: _dateKey(userId, businessId));
  }

  static Map<String, dynamic> _taskToMap(DailyTask t) => {
        'id': t.id,
        'title': t.title,
        'description': t.description,
        'impact': t.impact.name,
        'duration': t.durationMinutes,
        'categoryId': t.categoryId,
        'businessType': t.businessType,
        'status': t.status.name,
      };

  static DailyTask _taskFromMap(Map<String, dynamic> m) => DailyTask(
        id: m['id'] as String,
        title: m['title'] as String,
        description: m['description'] as String,
        impact: TaskImpact.values.firstWhere(
          (e) => e.name == m['impact'],
          orElse: () => TaskImpact.medium,
        ),
        durationMinutes: m['duration'] as int,
        categoryId: m['categoryId'] as String,
        businessType: m['businessType'] as int,
        status: TaskStatus.values.firstWhere(
          (e) => e.name == m['status'],
          orElse: () => TaskStatus.pending,
        ),
      );
}
