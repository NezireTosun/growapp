class SurveyQuestion {
  final String id;
  final String question;
  final List<SurveyOption> options;
  final int order;

  const SurveyQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.order,
  });
}

enum SurveyMood { happy, neutral, sad }

class SurveyOption {
  final String id;
  final String label;
  final SurveyMood? mood;
  final int score;
  final int order;

  const SurveyOption({
    required this.id,
    required this.label,
    this.mood,
    this.score = 0,
    this.order = 0,
  });
}
