import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/task.dart';

/// Firestore'daki task_history koleksiyonuna yazma/okuma sorumluluğu.
class TaskHistoryService {
  final FirebaseFirestore _db;

  TaskHistoryService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  static const int statusCompleted = 0;
  static const int statusViewed = 1;
  static const int statusDismissed = 2;
  static const int statusBlacklisted = 3;

  static int statusToCode(TaskStatus status) {
    return switch (status) {
      TaskStatus.completed => statusCompleted,
      TaskStatus.viewed => statusViewed,
      TaskStatus.dismissed => statusDismissed,
      TaskStatus.blacklisted => statusBlacklisted,
      TaskStatus.pending => -1,
      TaskStatus.snoozed => 1,
    };
  }

  String _historyDocId(String userId, String businessId) =>
      '${userId}_$businessId';

  /// Görev aksiyonunu history'ye yazar (completed, dismissed, blacklisted vb.)
  Future<void> writeTaskHistory({
    required String userId,
    required String businessId,
    required String taskId,
    required TaskStatus status,
    required String date,
  }) async {
    final historyId = _historyDocId(userId, businessId);
    final historyRef = _db.collection('task_history').doc(historyId);

    final historyDoc = await historyRef.get();
    final tasksMap = Map<String, dynamic>.from(historyDoc.data()?['tasks'] ?? {});
    final existing = tasksMap[taskId] as Map<String, dynamic>?;
    final prevCount = existing?['count'] as int? ?? 0;

    tasksMap[taskId] = {
      'task_id': taskId,
      'status_type': statusToCode(status),
      'count': prevCount + 1,
      'last_at': Timestamp.now(),
      'date': date,
      if (existing?['points'] != null) 'points': existing!['points'],
      if (existing?['dismiss_reason'] != null)
        'dismiss_reason': existing!['dismiss_reason'],
    };

    await historyRef.set({
      'tasks': tasksMap,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Blacklist'e ekle
  Future<void> addToBlacklist({
    required String userId,
    required String businessId,
    required String taskId,
  }) async {
    final historyId = _historyDocId(userId, businessId);
    await _db.collection('task_history').doc(historyId).set({
      'blocked': FieldValue.arrayUnion([taskId]),
    }, SetOptions(merge: true));
  }

  /// Blacklisted + cooldown içindeki excluded task id'lerini döner
  Future<Set<String>> getExcludedTaskIds({
    required String userId,
    required String businessId,
  }) async {
    final historyId = _historyDocId(userId, businessId);
    final historyDoc = await _db.collection('task_history').doc(historyId).get();
    if (!historyDoc.exists) return {};

    final data = historyDoc.data()!;
    final excluded = <String>{};

    // Kalıcı blacklist — sadece yeni format ID'leri (prefix'li: "cafe_124")
    // Eski format ("124") API'nin döndürdüğü "cafe_124" ile eşleşmediğinden göz ardı edilir
    final blocked = data['blocked'] as List<dynamic>? ?? [];
    for (final id in blocked) {
      final idStr = id.toString();
      final numericOnly = RegExp(r'^\d+$').hasMatch(idStr);
      if (!numericOnly) excluded.add(idStr);
    }

    // Cooldown içindeki completed görevler (3 gün) + snooze süresi dolmamış görevler
    final tasksMap = data['tasks'] as Map<String, dynamic>? ?? {};
    final now = DateTime.now();
    for (final entry in tasksMap.entries) {
      final taskData = entry.value as Map<String, dynamic>?;
      if (taskData == null) continue;
      final statusType = taskData['status_type'] as int?;
      final lastAt = taskData['last_at'] as Timestamp?;

      // Completed: 3 gün cooldown
      if (statusType == statusCompleted && lastAt != null) {
        final daysSince = now.difference(lastAt.toDate()).inDays;
        if (daysSince < 3) {
          excluded.add(entry.key);
          // Eski int-format ID ile kaydedilmişse ("124") numeric eşdeğerini de ekle
          final numericMatch = RegExp(r'^\d+$').hasMatch(entry.key);
          if (numericMatch) {
            // Sadece numeric key — bu eski format, ignore et (yeni format "cafe_124" ile match etmez)
            // Excluded'a eklemiyoruz çünkü API artık "cafe_124" döndürüyor
            excluded.remove(entry.key);
          }
        }
      }

      // Snoozed: snooze_until dolmamışsa exclude et
      final snoozeUntil = taskData['snooze_until'] as Timestamp?;
      if (snoozeUntil != null && snoozeUntil.toDate().isAfter(now)) {
        final numericOnly = RegExp(r'^\d+$').hasMatch(entry.key);
        if (!numericOnly) excluded.add(entry.key); // sadece yeni format ID'leri exclude et
      }
    }

    debugPrint('[TaskHistory] excludedIds=$excluded');
    return excluded;
  }
}
