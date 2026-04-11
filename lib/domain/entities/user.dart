class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String planId;
  final bool emailVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.planId = 'free',
    this.emailVerified = false,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
  });
}
