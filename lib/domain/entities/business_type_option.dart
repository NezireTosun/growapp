class BusinessTypeOption {
  final String id;
  final String name;
  final String icon;
  final bool isAvailable;

  const BusinessTypeOption({
    required this.id,
    required this.name,
    required this.icon,
    this.isAvailable = true,
  });
}
