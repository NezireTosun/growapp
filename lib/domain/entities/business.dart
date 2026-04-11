class Business {
  final String id;
  final String name;
  final String ownerId;
  final String? sector;
  final String? city;
  final String? instagram;
  final String status;
  final bool isActive;
  final DateTime createdAt;

  /// Onboarding survey cevapları API formatında: {"q1": 8, "q2": 5, ...}
  final Map<String, int> apiAnswers;

  const Business({
    required this.id,
    required this.name,
    required this.ownerId,
    this.sector,
    this.city,
    this.instagram,
    this.status = 'active',
    this.isActive = true,
    required this.createdAt,
    this.apiAnswers = const {},
  });
}
