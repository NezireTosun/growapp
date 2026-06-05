import 'package:growapp/core/utils/app_logger.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../services/api_client.dart';
import '../services/task_cache_service.dart';

/// Görev yükleme zincirini yönetir: Firestore → API → cache fallback.
class TaskLoadingService {
  final TaskRepository _repository;
  final ApiClient _apiClient;

  TaskLoadingService(this._repository, this._apiClient);

  Future<List<DailyTask>> loadTasks({
    required String userId,
    required String businessId,
    required int businessType,
    required String locale,
    required String industry,
    required Map<String, int> apiAnswers,
    required TaskImpact Function(double) scoreToImpact,
  }) async {
    List<DailyTask> tasks = [];

    try {
      final hasToday = await _repository.hasTodayAssignments(
        userId: userId,
        businessId: businessId,
      );

      if (hasToday) {
        AppLogger.d('[TaskLoadingService]', 'Bugünün görevleri Firestore\'dan yükleniyor');
        tasks = await _repository.getTodayAssignments(
          userId: userId,
          businessId: businessId,
          businessType: businessType,
          locale: locale,
        );
      }

      // Firestore'da kayıt yoksa, boşsa veya 3'ten az görev içeriyorsa → API'den çek
      if (tasks.isEmpty || tasks.length < 3) {
        if (hasToday) {
          // Eksik/bozuk doc var, önce sil
          AppLogger.d('[TaskLoadingService]', 'Eksik Firestore kaydı (${tasks.length} görev) siliniyor, API\'den yeniden çekiliyor');
          await _repository.deleteTodayAssignments(userId: userId, businessId: businessId);
        }

        final effectiveAnswers = apiAnswers.isNotEmpty
            ? apiAnswers
            : {'q1': 5, 'q2': 5, 'q3': 5, 'q4': 5, 'q5': 5, 'q6': 5, 'q7': 5};

        AppLogger.d('[TaskLoadingService]', 'API\'den görev çekiliyor (industry=$industry, answers=${apiAnswers.isNotEmpty ? "kullanıcı" : "varsayılan"})');
        tasks = await _loadFromApi(
          userId: userId,
          businessId: businessId,
          businessType: businessType,
          locale: locale,
          industry: industry,
          apiAnswers: effectiveAnswers,
          scoreToImpact: scoreToImpact,
        );
      }
    } catch (e) {
      AppLogger.d('[TaskLoadingService]', 'Yükleme hatası: $e — cache\'e düşülüyor');
      final cached = await TaskCacheService.loadTasks(userId: userId, businessId: businessId);
      if (cached != null && cached.isNotEmpty) {
        AppLogger.d('[TaskLoadingService]', '${cached.length} görev cache\'den yüklendi');
        return cached;
      }
      rethrow;
    }

    if (tasks.isNotEmpty) {
      await TaskCacheService.saveTasks(userId: userId, businessId: businessId, tasks: tasks);
      AppLogger.d('[TaskLoadingService]', '${tasks.length} görev cache\'e yazıldı');
    }

    return tasks;
  }

  /// Hata durumunda: Firestore → cache sırasıyla dene.
  Future<List<DailyTask>> recoverTasks({
    required String userId,
    required String businessId,
    required int businessType,
    required String locale,
    required List<DailyTask> currentTasks,
  }) async {
    try {
      final tasks = await _repository.getTodayAssignments(
        userId: userId,
        businessId: businessId,
        businessType: businessType,
        locale: locale,
      );
      if (tasks.isNotEmpty) {
        await TaskCacheService.saveTasks(userId: userId, businessId: businessId, tasks: tasks);
      }
      return tasks;
    } catch (_) {
      if (currentTasks.isNotEmpty) return currentTasks;
      return await TaskCacheService.loadTasks(userId: userId, businessId: businessId) ?? [];
    }
  }

  Future<List<DailyTask>> _loadFromApi({
    required String userId,
    required String businessId,
    required int businessType,
    required String locale,
    required String industry,
    required Map<String, int> apiAnswers,
    required TaskImpact Function(double) scoreToImpact,
  }) async {
    // API kendi tarafında feedback geçmişini biliyor (Done/Snooze/Blacklist cooldown'ları)
    // ve buna göre filtrelenmiş liste döndürüyor — client-side exclude'a gerek yok
    final recommendations = await _apiClient.getRecommendations(
      industry: industry,
      answers: apiAnswers,
    );

    AppLogger.d('[TaskLoadingService]', '${recommendations.length} öneri geldi');

    final top3 = recommendations.take(3).toList();
    final tasks = await _resolveToFullTasks(
      recommendations: top3,
      locale: locale,
      businessType: businessType,
      scoreToImpact: scoreToImpact,
    );

    if (tasks.isNotEmpty) {
      await _repository.saveDailyAssignments(
        userId: userId,
        businessId: businessId,
        tasks: tasks,
      );
    }

    return tasks;
  }

  Future<List<DailyTask>> _resolveToFullTasks({
    required List<Recommendation> recommendations,
    required String locale,
    required int businessType,
    required TaskImpact Function(double) scoreToImpact,
  }) async {
    final tasks = <DailyTask>[];
    for (final r in recommendations) {
      final full = await _repository.getTaskById(r.taskId, locale: locale);
      if (full != null) {
        // API taskId'sini ID olarak koru — Firestore'daki int ID yerine
        tasks.add(full.copyWith(id: r.taskId));
      } else {
        tasks.add(DailyTask(
          id: r.taskId,
          title: r.taskName,
          description: r.subCategory,
          impact: scoreToImpact(r.score),
          durationMinutes: 15,
          categoryId: r.category,
          businessType: businessType,
        ));
      }
    }
    return tasks;
  }
}
