import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/notification.dart';
import 'package:smart_tourism_application/core/repositories/i_notifications_repository.dart';

class NotificationsController extends ChangeNotifier {
  final INotificationsRepository _notificationsRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<NotificationEntity> _notifications = [];
  NotificationEntity? _selectedNotification;
  bool _isLoadingNotification = false;

  NotificationsController(this._notificationsRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<NotificationEntity> get notifications => _notifications;
  NotificationEntity? get selectedNotification => _selectedNotification;
  bool get isLoadingNotification => _isLoadingNotification;

  Future<void> loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _notificationsRepository.getNotifications();
    } catch (e) {
      _errorMessage = e.toString();
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNotificationById(int id) async {
    _isLoadingNotification = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedNotification = await _notificationsRepository.getNotificationById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _selectedNotification = null;
    } finally {
      _isLoadingNotification = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _notificationsRepository.markAsRead(id);
      // Update the notification in the list to mark it as read
      for (var i = 0; i < _notifications.length; i++) {
        if (_notifications[i].id == id) {
          final updatedNotification = _notifications[i];
          final updatedPivot = NotificationPivot(
            userId: updatedNotification.pivot.userId,
            notificationId: updatedNotification.pivot.notificationId,
            isRead: 1, // Mark as read
            readAt: DateTime.now().toIso8601String(),
            createdAt: updatedNotification.pivot.createdAt,
            updatedAt: updatedNotification.pivot.updatedAt,
          );
          
          _notifications[i] = NotificationEntity(
            id: updatedNotification.id,
            title: updatedNotification.title,
            type: updatedNotification.type,
            typeId: updatedNotification.typeId,
            details: updatedNotification.details,
            icon: updatedNotification.icon,
            isActive: updatedNotification.isActive,
            scheduledAt: updatedNotification.scheduledAt,
            createdAt: updatedNotification.createdAt,
            updatedAt: updatedNotification.updatedAt,
            pivot: updatedPivot,
          );
          break;
        }
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}