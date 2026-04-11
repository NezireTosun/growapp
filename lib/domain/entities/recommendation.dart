class Recommendation {
  final int rank;
  final String taskId;
  final String taskName;
  final String category;
  final String subCategory;
  final double score;

  const Recommendation({
    required this.rank,
    required this.taskId,
    required this.taskName,
    required this.category,
    required this.subCategory,
    required this.score,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      rank: json['rank'] as int,
      taskId: json['taskId'] as String,
      taskName: json['taskName'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }
}

class FeedbackResponse {
  final String userId;
  final String taskId;
  final String action;
  final DateTime recordedAt;
  final String? dismissReason;

  const FeedbackResponse({
    required this.userId,
    required this.taskId,
    required this.action,
    required this.recordedAt,
    this.dismissReason,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      userId: json['userId'] as String,
      taskId: json['taskId'] as String,
      action: json['action'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      dismissReason: json['dismissReason'] as String?,
    );
  }
}
