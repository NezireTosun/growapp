import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';

/// Firestore dökümanlarından lokalize DailyTask oluşturma sorumluluğu.
class TaskLocalizationService {
  String localized(dynamic field, String locale) {
    if (field == null) return '';
    if (field is Map) {
      // Önce istenen locale, sonra en, sonra tr, sonra ilk değer
      final value = field[locale] ?? field['en'] ?? field['tr'] ?? field.values.firstOrNull ?? '';
      if (value is String) return value;
      if (value is List) return value.isNotEmpty ? value.first.toString() : '';
      return value.toString();
    }
    if (field is String) return field;
    if (field is List) return field.isNotEmpty ? field.first.toString() : '';
    return '';
  }

  Future<DailyTask> buildTask(
    DocumentSnapshot<Map<String, dynamic>> doc,
    Map<String, dynamic> data,
    String locale,
  ) async {
    final steps = <TaskStep>[];
    final rawHowSteps = data['how_steps'];

    if (rawHowSteps != null) {
      if (rawHowSteps is List) {
        for (var i = 0; i < rawHowSteps.length; i++) {
          steps.add(TaskStep(
            id: 'step_$i',
            order: i,
            text: localized(rawHowSteps[i], locale),
          ));
        }
      } else if (rawHowSteps is Map) {
        // locale → en → tr → ilk mevcut locale
        final localeSteps = rawHowSteps[locale] ??
            rawHowSteps['en'] ??
            rawHowSteps['tr'] ??
            rawHowSteps.values.firstOrNull;
        if (localeSteps is List) {
          for (var i = 0; i < localeSteps.length; i++) {
            steps.add(TaskStep(
              id: 'step_$i',
              order: i,
              text: localeSteps[i].toString(),
            ));
          }
        } else if (localeSteps is String) {
          steps.add(TaskStep(id: 'step_0', order: 0, text: localeSteps));
        }
      }
    } else {
      final stepsSnapshot = await doc.reference
          .collection('task_steps')
          .orderBy('step_order')
          .get();
      for (final s in stepsSnapshot.docs) {
        final stepData = s.data();
        steps.add(TaskStep(
          id: s.id,
          order: stepData['step_order'] as int? ?? 0,
          text: localized(stepData['step_text'], locale),
        ));
      }
    }

    String? nonEmpty(String s) => s.isNotEmpty ? s : null;

    return DailyTask(
      id: (data['task_id'] ?? doc.id).toString(),
      title: localized(data['title'] ?? data['task_name'] ?? '', locale),
      description: localized(data['why_text'] ?? '', locale),
      impact: _mapImpact(data['impact_score'] as int? ?? data['impact'] as int? ?? 5),
      durationMinutes: data['time_estimate'] as int? ?? 10,
      categoryId: data['category'] as String? ??
          data['category_id'] as String? ??
          data['main_category'] as String? ??
          '',
      businessType: data['business_type'] as int? ?? 0,
      cooldownDays: data['cool_down_days'] as int? ?? data['cooldown_days'] as int? ?? 0,
      difficultyLevel: data['difficulty_level'] as String? ?? 'medium',
      whyTitle: nonEmpty(localized(data['why_title'], locale)),
      whyImportant: nonEmpty(localized(data['why_text'], locale)),
      howTitle: nonEmpty(localized(data['how_title'], locale)),
      steps: steps,
      templateTitle: nonEmpty(localized(data['template_title'], locale)),
      shareTemplate: nonEmpty(localized(data['template_text'], locale)),
    );
  }

  TaskImpact _mapImpact(int score) {
    if (score >= 7) return TaskImpact.high;
    if (score >= 4) return TaskImpact.medium;
    return TaskImpact.low;
  }
}
