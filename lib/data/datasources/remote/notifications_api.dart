import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/core/entities/notification.dart';
import 'package:dio/dio.dart';

class NotificationsApi {
  final DioClient _dioClient;

  NotificationsApi(this._dioClient);

  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final response = await _dioClient.get('/api/notifications');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> notificationsData = data['data'];
          return notificationsData.map((json) => NotificationEntity.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load notifications: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load notifications: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load notifications: ${e.response?.data}');
      } else {
        throw Exception('Failed to load notifications: ${e.message}');
      }
    }
  }

  Future<NotificationEntity> getNotificationById(int id) async {
    try {
      final response = await _dioClient.get('/api/notifications/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return NotificationEntity.fromJson(data['data']);
        } else {
          throw Exception('Failed to load notification: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load notification: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load notification: ${e.response?.data}');
      } else {
        throw Exception('Failed to load notification: ${e.message}');
      }
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final response = await _dioClient.put('/api/notifications/$id/read');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to mark notification as read: ${e.response?.data}');
      } else {
        throw Exception('Failed to mark notification as read: ${e.message}');
      }
    }
  }
}