import 'package:growapp/core/utils/app_logger.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/task_repository.dart';
import '../services/task_localization_service.dart';
import '../services/task_history_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _db;
  final TaskLocalizationService _localization;
  final TaskHistoryService _history;

  TaskRepositoryImpl({
    FirebaseFirestore? db,
    TaskLocalizationService? localization,
    TaskHistoryService? history,
  })  : _db = db ?? FirebaseFirestore.instance,
        _localization = localization ?? TaskLocalizationService(),
        _history = history ?? TaskHistoryService();

  String _todayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _assignmentDocId(String userId, String businessId, String date) =>
      '${userId}_${businessId}_$date';

  // ─── GET TASKS ───

  @override
  Future<List<DailyTask>> getDailyTasks({
    String locale = 'tr',
    int? businessType,
  }) async {
    final snapshot = await _db
        .collection('tasks')
        .where('is_active', isEqualTo: true)
        .get();

    final tasks = <DailyTask>[];
    for (final doc in snapshot.docs) {
      tasks.add(await _localization.buildTask(doc, doc.data(), locale));
    }
    return tasks;
  }

  @override
  Future<List<DailyTask>> getTodayAssignments({
    required String userId,
    required String businessId,
    required int businessType,
    String locale = 'tr',
    String? industry,
  }) async {
    final today = _todayDate();
    final docId = _assignmentDocId(userId, businessId, today);
    final doc = await _db.collection('daily_assignments').doc(docId).get();

    AppLogger.d('[TaskRepo]', 'docId=$docId exists=${doc.exists}');
    if (doc.exists) {
      final taskEntries = List<Map<String, dynamic>>.from(doc.data()?['tasks'] ?? []);
      AppLogger.d('[TaskRepo]', 'taskEntries=$taskEntries');
      final tasks = await _loadAssignedTasks(taskEntries, locale);
      AppLogger.d('[TaskRepo]', 'loaded ${tasks.length} tasks from Firestore');
      return tasks;
    }

    return _createTodayFromYesterday(
      userId: userId,
      businessId: businessId,
      businessType: businessType,
      industry: industry,
      today: today,
      docId: docId,
      locale: locale,
    );
  }

  Future<List<DailyTask>> _createTodayFromYesterday({
    required String userId,
    required String businessId,
    required int businessType,
    String? industry,
    required String today,
    required String docId,
    required String locale,
  }) async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayDate =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    final yesterdayDoc = await _db
        .collection('daily_assignments')
        .doc(_assignmentDocId(userId, businessId, yesterdayDate))
        .get();

    final carryOverEntries = <Map<String, dynamic>>[];
    final carryOverTaskIds = <String>{};

    if (yesterdayDoc.exists) {
      for (final entry in List<Map<String, dynamic>>.from(yesterdayDoc.data()?['tasks'] ?? [])) {
        final status = entry['status'] as String? ?? 'pending';
        if (status != 'completed' && status != 'blacklisted') {
          carryOverEntries.add({'task_id': entry['task_id'], 'status': 'pending'});
          carryOverTaskIds.add(entry['task_id'].toString());
        }
      }
    }

    final newTasksNeeded = 3 - carryOverEntries.length;

    if (newTasksNeeded > 0) {
      final snapshot = await _db
          .collection('tasks')
          .where('is_active', isEqualTo: true)
          .get();

      // industry string'i varsa ona göre filtrele ('rest' → 'restaurant' da eşleşir)
      final industryAliases = industry == 'rest' ? {'rest', 'restaurant'} : {industry};
      var filteredDocs = industry != null && industry.isNotEmpty
          ? snapshot.docs.where((d) => industryAliases.contains(d.data()['industry'])).toList()
          : snapshot.docs.where((d) => d.data()['business_type'] == businessType).toList();
      if (filteredDocs.isEmpty) {
        filteredDocs = snapshot.docs.toList();
      }

      if (filteredDocs.isNotEmpty) {
        final historyDoc = await _db
            .collection('task_history')
            .doc('${userId}_$businessId')
            .get();
        final historyData = historyDoc.data();
        final blockedIds = (historyData?['blocked'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toSet();
        final tasksMap = Map<String, dynamic>.from(historyData?['tasks'] ?? {});

        final available = filteredDocs.where((d) {
          final taskId = (d.data()['task_id'] ?? d.id).toString();
          if (blockedIds.contains(taskId)) return false;
          if (carryOverTaskIds.contains(taskId)) return false;
          final taskData = d.data();
          final cooldown =
              taskData['cool_down_days'] as int? ?? taskData['cooldown_days'] as int? ?? 0;
          final history = tasksMap[taskId] as Map<String, dynamic>?;
          if (history != null && cooldown > 0) {
            final lastAt = history['last_at'] as Timestamp?;
            if (lastAt != null) {
              if (now.difference(lastAt.toDate()).inDays < cooldown) return false;
            }
          }
          return true;
        }).toList();

        available.shuffle(Random());
        for (final d in available.take(newTasksNeeded)) {
          final rawId = d.data()['task_id'] ?? d.id;
          carryOverEntries.add({'task_id': rawId, 'status': 'pending'});
        }
      }
    }

    await _db.collection('daily_assignments').doc(docId).set({
      'user_id': userId,
      'business_id': businessId,
      'date': today,
      'tasks': carryOverEntries,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });

    final tasks = await _loadAssignedTasks(carryOverEntries, locale);

    if (tasks.isNotEmpty) {
      final notifTitle = _localizedNotifTitle(locale);
      final notifBody = _localizedNotifBody(locale, tasks.length);
      await _db.collection('notifications').add({
        'user_id': userId,
        'business_id': businessId,
        'type': NotificationType.taskAssigned.name,
        'title': notifTitle,
        'body': notifBody,
        'is_read': false,
        'created_at': FieldValue.serverTimestamp(),
        'data': null,
      });
    }

    return tasks;
  }

  Future<List<DailyTask>> _loadAssignedTasks(
    List<Map<String, dynamic>> taskEntries,
    String locale,
  ) async {
    final tasks = <DailyTask>[];
    for (final entry in taskEntries) {
      final rawId = entry['task_id'];
      final taskId = rawId.toString();
      final statusStr = entry['status'] as String? ?? 'pending';

      // Önce direkt doc ID ile dene
      var taskDoc = await _db.collection('tasks').doc(taskId).get();

      // Bulunamazsa task_id field'ı ile sorgula (string veya int olabilir)
      if (!taskDoc.exists) {
        QuerySnapshot<Map<String, dynamic>> query;

        // String olarak dene ("task_rest_001" gibi)
        query = await _db
            .collection('tasks')
            .where('task_id', isEqualTo: taskId)
            .limit(1)
            .get();

        // Bulunamazsa numeric int olarak dene ("cafe_124" → 124)
        if (query.docs.isEmpty) {
          final numericId = int.tryParse(RegExp(r'\d+').firstMatch(taskId)?.group(0) ?? '');
          if (numericId != null) {
            query = await _db
                .collection('tasks')
                .where('task_id', isEqualTo: numericId)
                .limit(1)
                .get();
          }
        }

        if (query.docs.isNotEmpty) {
          taskDoc = query.docs.first;
        }
      }

      if (!taskDoc.exists) {
        AppLogger.d('[TaskRepository]', 'task $taskId bulunamadı, atlanıyor');
        continue;
      }

      final task = await _localization.buildTask(taskDoc, taskDoc.data()!, locale);
      // taskId'yi Firestore'a kaydedildiği gibi koru (API string formatı: "cafe_124")
      tasks.add(task.copyWith(id: taskId, status: _parseStatus(statusStr)));
    }
    return tasks;
  }

  // ─── UPDATE STATUS + TASK_HISTORY ───

  @override
  Future<void> updateTaskStatus({
    required String userId,
    required String businessId,
    required String taskId,
    required TaskStatus status,
  }) async {
    final today = _todayDate();
    final docId = _assignmentDocId(userId, businessId, today);

    final doc = await _db.collection('daily_assignments').doc(docId).get();
    if (!doc.exists) return;

    final taskEntries = List<Map<String, dynamic>>.from(doc.data()!['tasks'] ?? []);
    for (var i = 0; i < taskEntries.length; i++) {
      if (taskEntries[i]['task_id'].toString() == taskId) {
        taskEntries[i] = {'task_id': taskId, 'status': status.name};
        break;
      }
    }

    await _db.collection('daily_assignments').doc(docId).update({
      'tasks': taskEntries,
      'updated_at': FieldValue.serverTimestamp(),
    });

    await _history.writeTaskHistory(
      userId: userId,
      businessId: businessId,
      taskId: taskId,
      status: status,
      date: today,
    );
  }

  // ─── 1. COMPLETE TASK ───

  @override
  Future<int> completeTask({
    required String userId,
    required String businessId,
    required String taskId,
    String? roiNote,
  }) async {
    await updateTaskStatus(
      userId: userId,
      businessId: businessId,
      taskId: taskId,
      status: TaskStatus.completed,
    );

    // taskId "cafe_124" gibi string — önce doc ID, sonra int query ile ara
    var taskDoc = await _db.collection('tasks').doc(taskId).get();
    if (!taskDoc.exists) {
      final numericId = int.tryParse(RegExp(r'\d+').firstMatch(taskId)?.group(0) ?? '');
      if (numericId != null) {
        final q = await _db.collection('tasks').where('task_id', isEqualTo: numericId).limit(1).get();
        if (q.docs.isNotEmpty) taskDoc = q.docs.first;
      }
    }
    final taskData = taskDoc.exists ? taskDoc.data() : null;
    final impactScore = taskData?['impact_score'] as int? ?? taskData?['impact'] as int? ?? 5;
    final points = impactScore * 10;

    final historyRef = _db.collection('task_history').doc('${userId}_$businessId');
    final historyDoc = await historyRef.get();
    final tasksMap = Map<String, dynamic>.from(historyDoc.data()?['tasks'] ?? {});
    final existing = tasksMap[taskId] as Map<String, dynamic>?;

    tasksMap[taskId] = {
      ...?existing,
      'points': (existing?['points'] as int? ?? 0) + points,
    };

    await historyRef.set({
      'tasks': tasksMap,
      'total_points': FieldValue.increment(points),
    }, SetOptions(merge: true));

    return points;
  }

  // ─── 2. SNOOZE TASK ───

  @override
  Future<void> snoozeTask({
    required String userId,
    required String businessId,
    required String taskId,
    required Duration snoozeDuration,
  }) async {
    await updateTaskStatus(
      userId: userId,
      businessId: businessId,
      taskId: taskId,
      status: TaskStatus.snoozed,
    );

    final snoozeUntil = DateTime.now().add(snoozeDuration);
    final historyRef = _db.collection('task_history').doc('${userId}_$businessId');
    final historyDoc = await historyRef.get();
    final tasksMap = Map<String, dynamic>.from(historyDoc.data()?['tasks'] ?? {});
    final existing = tasksMap[taskId] as Map<String, dynamic>?;

    tasksMap[taskId] = {
      ...?existing,
      'snooze_until': Timestamp.fromDate(snoozeUntil),
    };

    await historyRef.set({'tasks': tasksMap}, SetOptions(merge: true));
  }

  // ─── 3. DISMISS TASK ───

  @override
  Future<void> dismissTask({
    required String userId,
    required String businessId,
    required String taskId,
    required DismissReason reason,
    String? note,
  }) async {
    await updateTaskStatus(
      userId: userId,
      businessId: businessId,
      taskId: taskId,
      status: TaskStatus.dismissed,
    );

    final historyRef = _db.collection('task_history').doc('${userId}_$businessId');
    final historyDoc = await historyRef.get();
    final tasksMap = Map<String, dynamic>.from(historyDoc.data()?['tasks'] ?? {});
    final existing = tasksMap[taskId] as Map<String, dynamic>?;

    tasksMap[taskId] = {
      ...?existing,
      'dismiss_reason': reason.name,
      'note': ?note,
    };

    await historyRef.set({'tasks': tasksMap}, SetOptions(merge: true));
  }

  // ─── 4. BLACKLIST TASK ───

  @override
  Future<void> blacklistTask({
    required String userId,
    required String businessId,
    required String taskId,
    required String category,
  }) async {
    await updateTaskStatus(
      userId: userId,
      businessId: businessId,
      taskId: taskId,
      status: TaskStatus.blacklisted,
    );

    await _history.addToBlacklist(
      userId: userId,
      businessId: businessId,
      taskId: taskId,
    );
  }

  // ─── EXCLUDED TASK IDS ───

  @override
  Future<Set<String>> getExcludedTaskIds({
    required String userId,
    required String businessId,
  }) => _history.getExcludedTaskIds(userId: userId, businessId: businessId);

  // ─── GET TASK BY ID ───

  @override
  Future<DailyTask?> getTaskById(String taskId, {String locale = 'tr'}) async {
    // 1. Direkt doc ID ile dene
    var doc = await _db.collection('tasks').doc(taskId).get();
    if (doc.exists) return _localization.buildTask(doc, doc.data()!, locale);

    // 2. task_id field'ı string olarak dene ("task_rest_001" gibi)
    var query = await _db
        .collection('tasks')
        .where('task_id', isEqualTo: taskId)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return _localization.buildTask(query.docs.first, query.docs.first.data(), locale);
    }

    // 3. task_id field'ı int olarak dene (eski format)
    final numericId = int.tryParse(RegExp(r'\d+').firstMatch(taskId)?.group(0) ?? '');
    if (numericId != null) {
      query = await _db
          .collection('tasks')
          .where('task_id', isEqualTo: numericId)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        return _localization.buildTask(query.docs.first, query.docs.first.data(), locale);
      }
    }

    return null;
  }

  // ─── HAS TODAY ASSIGNMENTS ───

  @override
  Future<bool> hasTodayAssignments({
    required String userId,
    required String businessId,
  }) async {
    final docId = _assignmentDocId(userId, businessId, _todayDate());
    final doc = await _db.collection('daily_assignments').doc(docId).get();
    if (!doc.exists) return false;
    // tasks array'i boşsa sıfırlanmış/bozuk kayıt — yeniden oluşturulmalı
    final tasks = doc.data()?['tasks'] as List<dynamic>? ?? [];
    return tasks.isNotEmpty;
  }

  // ─── DELETE TODAY ASSIGNMENTS ───

  @override
  Future<void> deleteTodayAssignments({
    required String userId,
    required String businessId,
  }) async {
    // Firestore kuralı delete'e izin vermez — tasks array'ini boşaltıyoruz
    // böylece hasTodayAssignments=true ama tasks=[] olur ve API'ye gider
    final docId = _assignmentDocId(userId, businessId, _todayDate());
    await _db.collection('daily_assignments').doc(docId).update({
      'tasks': [],
      'updated_at': FieldValue.serverTimestamp(),
    });
    AppLogger.d('[TaskRepo]', 'Bugünün assignment doc\'u sıfırlandı: $docId');
  }

  // ─── SAVE DAILY ASSIGNMENTS ───

  @override
  Future<void> saveDailyAssignments({
    required String userId,
    required String businessId,
    required List<DailyTask> tasks,
  }) async {
    final today = _todayDate();
    final docId = _assignmentDocId(userId, businessId, today);

    final taskList = tasks.map((t) => {'task_id': t.id, 'status': 'pending'}).toList();
    AppLogger.d('[TaskRepo]', 'saveDailyAssignments docId=$docId tasks=$taskList');
    await _db.collection('daily_assignments').doc(docId).set({
      'user_id': userId,
      'business_id': businessId,
      'date': today,
      'tasks': taskList,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    AppLogger.d('[TaskRepo]', 'saveDailyAssignments başarılı');
  }

  // ─── HELPERS ───

  TaskStatus _parseStatus(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TaskStatus.pending,
    );
  }

  String _localizedNotifTitle(String locale) => switch (locale) {
    'tr' => 'Yeni görevler atandı!',
    'de' => 'Neue Aufgaben zugewiesen!',
    'es' => '¡Nuevas tareas asignadas!',
    'cs' => 'Nové úkoly přiřazeny!',
    _    => 'New tasks assigned!',
  };

  String _localizedNotifBody(String locale, int count) => switch (locale) {
    'tr' => '$count görevin var. Hadi işletmeni büyütelim!',
    'de' => 'Du hast $count neue Aufgaben. Lass uns dein Unternehmen wachsen lassen!',
    'es' => 'Tienes $count tareas nuevas. ¡Hagamos crecer tu negocio!',
    'cs' => 'Máš $count nových úkolů. Pojďme rozvíjet tvoje podnikání!',
    _    => 'You have $count new tasks. Let\'s grow your business!',
  };
}
