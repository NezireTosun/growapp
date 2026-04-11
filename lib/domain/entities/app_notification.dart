import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  taskAssigned,
  taskReminder,
  dailySummary,
}

class AppNotification {
  final String id;
  final String userId;
  final String? businessId;
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const AppNotification({
    required this.id,
    required this.userId,
    this.businessId,
    required this.type,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      businessId: businessId,
      type: type,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      data: data,
    );
  }

  factory AppNotification.fromMap(String id, Map<String, dynamic> map) {
    return AppNotification(
      id: id,
      userId: map['user_id'] as String? ?? '',
      businessId: map['business_id'] as String?,
      type: _parseType(map['type'] as String? ?? ''),
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      isRead: map['is_read'] as bool? ?? false,
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      data: map['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'business_id': businessId,
        'type': type.name,
        'title': title,
        'body': body,
        'is_read': isRead,
        'created_at': Timestamp.fromDate(createdAt),
        'data': data,
      };

  static NotificationType _parseType(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.taskReminder,
    );
  }
}
