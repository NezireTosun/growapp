import 'package:growapp/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import '../../data/services/api_client.dart';
import '../../data/services/task_loading_service.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final TaskRepository _repository;
  final ApiClient _apiClient;
  final TaskLoadingService _loader;
  String _businessName = '';

  DashboardProvider(TaskRepository repository, ApiClient apiClient)
      : _repository = repository,
        _apiClient = apiClient,
        _loader = TaskLoadingService(repository, apiClient);

  String get businessName => _businessName;

  void setBusinessName(String name) {
    _businessName = name;
    notifyListeners();
  }

  List<DailyTask> _tasks = [];
  final List<Recommendation> _recommendations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DailyTask> get tasks => _tasks;
  List<Recommendation> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool _feedbackError = false;
  bool get feedbackError => _feedbackError;

  void clearFeedbackError() {
    _feedbackError = false;
    notifyListeners();
  }

  int get totalTasks => _tasks.length;
  int get completedTasks =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;
  double get progressPercent =>
      totalTasks > 0 ? completedTasks / totalTasks : 0.0;

  String _locale = 'tr';
  String get locale => _locale;

  int? _businessType;
  int? get businessType => _businessType;

  String? _userId;
  String? _businessId;

  String _industry = 'rest';
  Map<String, int> _apiAnswers = {};

  String get industry => _industry;
  Map<String, int> get apiAnswers => _apiAnswers;

  void setBusinessType(int type) {
    _businessType = type;
    notifyListeners();
  }

  void setUserAndBusiness(String userId, String businessId) {
    _userId = userId;
    _businessId = businessId;
  }

  static const _industryMap = <String, String>{
    '1': 'cafe',
    '2': 'rest',
    'cafe': 'cafe',
    'rest': 'rest',
  };

  void setApiParams({required String industry, required Map<String, int> answers}) {
    _industry = _industryMap[industry] ?? industry;
    _apiAnswers = answers;
  }

  Future<void> loadTasks({String locale = 'tr', int? businessType}) async {
    _locale = locale;
    if (businessType != null) _businessType = businessType;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    AppLogger.d('[Dashboard]', 'loadTasks businessType=$_businessType industry=$_industry');
    try {
      if (_userId != null && _businessId != null && _businessType != null) {
        _tasks = await _loader.loadTasks(
          userId: _userId!,
          businessId: _businessId!,
          businessType: _businessType!,
          locale: locale,
          industry: _industry,
          apiAnswers: _apiAnswers,
          scoreToImpact: _scoreToImpact,
        );
      } else {
        _tasks = [];
      }
    } catch (e) {
      AppLogger.e('[DashboardProvider]', 'loadTasks error', e);
      if (_userId != null && _businessId != null && _businessType != null) {
        _tasks = await _loader.recoverTasks(
          userId: _userId!,
          businessId: _businessId!,
          businessType: _businessType!,
          locale: locale,
          currentTasks: _tasks,
        );
        if (_tasks.isEmpty) _errorMessage = _friendlyError(e);
      } else {
        _tasks = [];
        _errorMessage = _friendlyError(e);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void markViewed(String taskId) {
    _updateLocalStatus(taskId, TaskStatus.viewed, onlyIfPending: true);
  }

  // ─── FEEDBACK — Strategy pattern ───

  Future<int> markCompleted(String taskId, {String? roiNote}) async {
    return await _applyFeedback<int>(
      taskId: taskId,
      newStatus: TaskStatus.completed,
      apiAction: 'Done',
      repositoryAction: (_userId != null && _businessId != null)
          ? () => _repository.completeTask(
                userId: _userId!,
                businessId: _businessId!,
                taskId: taskId,
                roiNote: roiNote,
              )
          : null,
      defaultResult: 0,
    );
  }

  Future<void> markSnoozed(String taskId, {Duration duration = const Duration(hours: 4)}) async {
    await _applyFeedback<void>(
      taskId: taskId,
      newStatus: TaskStatus.snoozed,
      apiAction: 'Snooze',
      repositoryAction: (_userId != null && _businessId != null)
          ? () => _repository.snoozeTask(
                userId: _userId!,
                businessId: _businessId!,
                taskId: taskId,
                snoozeDuration: duration,
              )
          : null,
    );
  }

  Future<void> markDismissed(String taskId, {required DismissReason reason, String? note}) async {
    final reasonText = switch (reason) {
      DismissReason.budget => 'Bütçe yetersiz',
      DismissReason.time => 'Zaman yok',
      DismissReason.staff => 'Personel yetersiz',
      DismissReason.other => note ?? 'Diğer',
    };

    await _applyFeedback<void>(
      taskId: taskId,
      newStatus: TaskStatus.dismissed,
      apiAction: 'Dismiss',
      apiDismissReason: reasonText,
      repositoryAction: (_userId != null && _businessId != null)
          ? () => _repository.dismissTask(
                userId: _userId!,
                businessId: _businessId!,
                taskId: taskId,
                reason: reason,
                note: note,
              )
          : null,
    );
  }

  Future<void> markBlacklisted(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;
    final category = _tasks[index].categoryId;

    await _applyFeedback<void>(
      taskId: taskId,
      newStatus: TaskStatus.blacklisted,
      apiAction: 'Blacklist',
      repositoryAction: (_userId != null && _businessId != null)
          ? () => _repository.blacklistTask(
                userId: _userId!,
                businessId: _businessId!,
                taskId: taskId,
                category: category,
              )
          : null,
    );
  }

  Future<T> _applyFeedback<T>({
    required String taskId,
    required TaskStatus newStatus,
    required String apiAction,
    String? apiDismissReason,
    Future<T> Function()? repositoryAction,
    T? defaultResult,
  }) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return defaultResult as T;

    _tasks[index] = _tasks[index].copyWith(status: newStatus);
    notifyListeners();

    try {
      await _apiClient.sendFeedback(
        industry: _industry,
        taskId: taskId,
        action: apiAction,
        dismissReason: apiDismissReason,
      );
    } catch (e) {
      AppLogger.e('[DashboardProvider]', 'API feedback error ($apiAction)', e);
    }

    T result = defaultResult as T;
    if (repositoryAction != null) {
      result = await repositoryAction();
    }

    notifyListeners();
    return result;
  }

  void _updateLocalStatus(String taskId, TaskStatus status, {bool onlyIfPending = false}) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;
    if (onlyIfPending && _tasks[index].status != TaskStatus.pending) return;

    _tasks[index] = _tasks[index].copyWith(status: status);
    notifyListeners();

    if (_userId != null && _businessId != null) {
      final previousStatus = _tasks[index].status;
      _repository.updateTaskStatus(
        userId: _userId!,
        businessId: _businessId!,
        taskId: taskId,
        status: status,
      ).catchError((e) {
        AppLogger.e('[DashboardProvider]', 'updateTaskStatus error', e);
        // Firestore yazımı başarısız olduysa local state'i geri al
        final rollbackIndex = _tasks.indexWhere((t) => t.id == taskId);
        if (rollbackIndex != -1) {
          _tasks[rollbackIndex] = _tasks[rollbackIndex].copyWith(status: previousStatus);
          notifyListeners();
        }
      });
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('429') || msg.contains('Too many requests')) return 'rate_limit';
    if (msg.contains('SocketException') ||
        msg.contains('network') ||
        msg.contains('Failed host lookup')) {
      return 'network_error';
    }
    return 'generic_error';
  }

  TaskImpact _scoreToImpact(double score) {
    if (score >= 80) return TaskImpact.high;
    if (score >= 50) return TaskImpact.medium;
    return TaskImpact.low;
  }
}
