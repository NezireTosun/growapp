enum TaskStatus { pending, viewed, completed, snoozed, dismissed, blacklisted }

enum TaskImpact { high, medium, low }

enum DismissReason { budget, time, staff, other }

class TaskStep {
  final String id;
  final int order;
  final String text;

  const TaskStep({required this.id, required this.order, required this.text});
}

class DailyTask {
  final String id;
  final String title;
  final String description;
  final TaskImpact impact;
  final int durationMinutes;
  final TaskStatus status;
  final String categoryId;
  final int businessType;
  final int cooldownDays;
  final String difficultyLevel;
  final String? whyTitle;
  final String? whyImportant;
  final String? howTitle;
  final List<TaskStep> steps;
  final String? templateTitle;
  final String? shareTemplate;

  const DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.impact,
    required this.durationMinutes,
    this.status = TaskStatus.pending,
    this.categoryId = '',
    this.businessType = 0,
    this.cooldownDays = 0,
    this.difficultyLevel = 'medium',
    this.whyTitle,
    this.whyImportant,
    this.howTitle,
    this.steps = const [],
    this.templateTitle,
    this.shareTemplate,
  });

  DailyTask copyWith({String? id, TaskStatus? status}) {
    return DailyTask(
      id: id ?? this.id,
      title: title,
      description: description,
      impact: impact,
      durationMinutes: durationMinutes,
      status: status ?? this.status,
      categoryId: categoryId,
      businessType: businessType,
      cooldownDays: cooldownDays,
      difficultyLevel: difficultyLevel,
      whyTitle: whyTitle,
      whyImportant: whyImportant,
      howTitle: howTitle,
      steps: steps,
      templateTitle: templateTitle,
      shareTemplate: shareTemplate,
    );
  }
}
