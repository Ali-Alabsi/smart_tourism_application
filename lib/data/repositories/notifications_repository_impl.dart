import 'package:smart_tourism_application/core/entities/notification.dart';
import 'package:smart_tourism_application/core/repositories/i_notifications_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/notifications_api.dart';

class NotificationsRepositoryImpl implements INotificationsRepository {
  final NotificationsApi _notificationsApi;

  NotificationsRepositoryImpl(this._notificationsApi);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      return await _notificationsApi.getNotifications();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  @override
  Future<NotificationEntity> getNotificationById(int id) async {
    try {
      return await _notificationsApi.getNotificationById(id);
    } catch (e) {
      throw Exception('Failed to get notification: $e');
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      return await _notificationsApi.markAsRead(id);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }
}