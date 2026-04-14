import 'package:flutter_test/flutter_test.dart';
import 'package:growapp/domain/entities/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:growapp/data/services/task_cache_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TaskCacheService', () {
    const userId = 'user1';
    const businessId = 'biz1';

    final tasks = [
      const DailyTask(
        id: '42',
        title: 'Test Task',
        description: 'Description',
        impact: TaskImpact.high,
        durationMinutes: 15,
        categoryId: 'acquisition',
        businessType: 1,
      ),
    ];

    test('saveTasks then loadTasks returns same tasks', () async {
      await TaskCacheService.saveTasks(
        userId: userId,
        businessId: businessId,
        tasks: tasks,
      );

      final loaded = await TaskCacheService.loadTasks(
        userId: userId,
        businessId: businessId,
      );

      expect(loaded, isNotNull);
      expect(loaded!.length, 1);
      expect(loaded.first.id, '42');
      expect(loaded.first.title, 'Test Task');
      expect(loaded.first.impact, TaskImpact.high);
      expect(loaded.first.status, TaskStatus.pending);
    });

    test('loadTasks returns null when nothing saved', () async {
      final loaded = await TaskCacheService.loadTasks(
        userId: userId,
        businessId: businessId,
      );
      expect(loaded, isNull);
    });

    test('clearTasks makes loadTasks return null', () async {
      await TaskCacheService.saveTasks(
        userId: userId,
        businessId: businessId,
        tasks: tasks,
      );
      await TaskCacheService.clearTasks(
        userId: userId,
        businessId: businessId,
      );

      final loaded = await TaskCacheService.loadTasks(
        userId: userId,
        businessId: businessId,
      );
      expect(loaded, isNull);
    });

    test('tasks with completed status survive round-trip', () async {
      final completedTasks = [
        tasks.first.copyWith(status: TaskStatus.completed),
      ];
      await TaskCacheService.saveTasks(
        userId: userId,
        businessId: businessId,
        tasks: completedTasks,
      );

      final loaded = await TaskCacheService.loadTasks(
        userId: userId,
        businessId: businessId,
      );

      expect(loaded!.first.status, TaskStatus.completed);
    });
  });
}
