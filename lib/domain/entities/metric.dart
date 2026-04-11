class Metric {
  final String id;
  final String businessId;
  final DateTime date;
  final String metricType;
  final double value;
  final DateTime createdAt;

  const Metric({
    required this.id,
    required this.businessId,
    required this.date,
    required this.metricType,
    required this.value,
    required this.createdAt,
  });
}
