import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/core/entities/activity.dart';
import 'package:dio/dio.dart';

class ActivitiesApi {
  final DioClient _dioClient;

  ActivitiesApi(this._dioClient);

  Future<List<Activity>> getActivities({
    String? name,
    int? cityId,
    int? rating,
  }) async {
    try {
      final response = await _dioClient.get(
        '/api/activities',
        queryParameters: {
          if (name != null && name.isNotEmpty) 'name': name,
          if (cityId != null) 'city_id': cityId,
          if (rating != null) 'rating': rating,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> activitiesData = data['data'];
          return activitiesData.map((json) => Activity.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load activities: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load activities: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load activities: ${e.response?.data}');
      } else {
        throw Exception('Failed to load activities: ${e.message}');
      }
    }
  }

  Future<Activity> getActivityById(int id) async {
    try {
      final response = await _dioClient.get('/api/activities/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final activityData = data['data'];
          return Activity.fromJson(activityData);
        } else {
          throw Exception('Failed to load activity: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load activity: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load activity: ${e.response?.data}');
      } else {
        throw Exception('Failed to load activity: ${e.message}');
      }
    }
  }
}