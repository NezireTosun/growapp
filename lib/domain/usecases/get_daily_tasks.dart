import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetDailyTasks {
  final TaskRepository _repository;

  GetDailyTasks(this._repository);

  Future<List<DailyTask>> call({String locale = 'tr', int? businessType}) {
    return _repository.getDailyTasks(locale: locale, businessType: businessType);
  }
}
