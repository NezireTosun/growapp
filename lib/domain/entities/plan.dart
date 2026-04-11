class Plan {
  final String id;
  final String name;
  final double price;
  final int maxBusinesses;
  final int maxMembersPerBusiness;
  final int maxMessagesPerDay;
  final bool hasWhatsApp;
  final bool hasNotifications;
  final bool hasAnalytics;
  final bool hasAiInsights;
  final int strategicDimensions; // Q1-Q7 = 7
  final int strategicTasks; // Top 30
  final List<String> features;
  final bool isActive;

  const Plan({
    required this.id,
    required this.name,
    this.price = 0,
    this.maxBusinesses = 1,
    this.maxMembersPerBusiness = 1,
    this.maxMessagesPerDay = 5,
    this.hasWhatsApp = false,
    this.hasNotifications = false,
    this.hasAnalytics = false,
    this.hasAiInsights = false,
    this.strategicDimensions = 7,
    this.strategicTasks = 30,
    this.features = const [],
    this.isActive = true,
  });
}
