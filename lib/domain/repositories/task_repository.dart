import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<DailyTask>> getDailyTasks({
    String locale = 'tr',
    int? businessType,
  });

  /// Get today's 3 assigned tasks for a business.
  /// If no assignment exists for today, picks 3 tasks and creates assignments.
  Future<List<DailyTask>> getTodayAssignments({
    required String userId,
    required String businessId,
    required int businessType,
    String locale = 'tr',
  });

  /// Update task status in daily_assignments collection.
  Future<void> updateTaskStatus({
    required String userId,
    required String businessId,
    required String taskId,
    required TaskStatus status,
  });

  /// Mark task as completed — award points and record in task_history.
  Future<int> completeTask({
    required String userId,
    required String businessId,
    required String taskId,
    String? roiNote,
  });

  /// Snooze task — reschedule for later (4h or 1 day).
  Future<void> snoozeTask({
    required String userId,
    required String businessId,
    required String taskId,
    required Duration snoozeDuration,
  });

  /// Dismiss task — record reason and update profile.
  Future<void> dismissTask({
    required String userId,
    required String businessId,
    required String taskId,
    required DismissReason reason,
    String? note,
  });

  /// Blacklist task — never suggest again, reduce category weight.
  Future<void> blacklistTask({
    required String userId,
    required String businessId,
    required String taskId,
    required String category,
  });

  /// Get task history for filtering: blocked IDs + completed IDs still in cooldown.
  /// Returns a set of taskId strings that should NOT be shown to user.
  Future<Set<String>> getExcludedTaskIds({
    required String userId,
    required String businessId,
  });

  /// Get a single task by ID with full details (why, how, steps, template).
  Future<DailyTask?> getTaskById(String taskId, {String locale = 'tr'});

  /// Check if today's assignments already exist for this user+business.
  Future<bool> hasTodayAssignments({
    required String userId,
    required String businessId,
  });

  /// Clear today's tasks array (used when doc has corrupted/insufficient tasks).
  Future<void> deleteTodayAssignments({
    required String userId,
    required String businessId,
  });

  /// Save API recommendations as today's daily assignments.
  Future<void> saveDailyAssignments({
    required String userId,
    required String businessId,
    required List<DailyTask> tasks,
  });
}
