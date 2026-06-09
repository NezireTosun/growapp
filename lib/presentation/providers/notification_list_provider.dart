import 'package:growapp/core/utils/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/app_notification.dart';

class NotificationListProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> load(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _db
          .collection('notifications')
          .where('user_id', isEqualTo: userId)
          .get();

      _notifications = snapshot.docs
          .map((doc) => AppNotification.fromMap(doc.id, doc.data()))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      AppLogger.e('[NotificationListProvider]', 'Error', e);
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
        _errorMessage = 'network_error';
      } else {
        _errorMessage = 'generic_error';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;

    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();

    try {
      await _db.collection('notifications').doc(notificationId).update({
        'is_read': true,
      });
    } catch (e) {
      AppLogger.e('[NotificationListProvider]', 'markAsRead error', e);
    }
  }

  Future<void> markAllAsRead() async {
    final unread = _notifications.where((n) => !n.isRead).toList();
    if (unread.isEmpty) return;

    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();

    final batch = _db.batch();
    for (final n in unread) {
      batch.update(_db.collection('notifications').doc(n.id), {'is_read': true});
    }
    try {
      await batch.commit();
    } catch (e) {
      AppLogger.e('[NotificationListProvider]', 'markAllAsRead batch error', e);
      // Optimistic update geri al
      _notifications = _notifications.map((n) {
        final wasUnread = unread.any((u) => u.id == n.id);
        return wasUnread ? n.copyWith(isRead: false) : n;
      }).toList();
      notifyListeners();
    }
  }

  /// Create a notification in Firestore (called when tasks are assigned, reminders, etc.)
  Future<void> createNotification({
    required String userId,
    String? businessId,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _db.collection('notifications').add({
      'user_id': userId,
      'business_id': businessId,
      'type': type.name,
      'title': title,
      'body': body,
      'is_read': false,
      'created_at': FieldValue.serverTimestamp(),
      'data': data,
    });
  }
}
