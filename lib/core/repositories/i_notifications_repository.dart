import 'package:smart_tourism_application/core/entities/notification.dart';

abstract class INotificationsRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<NotificationEntity> getNotificationById(int id);
  Future<void> markAsRead(int id);
}