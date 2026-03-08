import 'package:smart_tourism_application/core/entities/activity.dart';
import 'package:smart_tourism_application/core/repositories/i_activities_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/activities_api.dart';

class ActivitiesRepositoryImpl implements IActivitiesRepository {
  final ActivitiesApi _activitiesApi;

  ActivitiesRepositoryImpl(this._activitiesApi);

  @override
  Future<List<Activity>> getActivities({
    String? name,
    int? cityId,
    int? rating,
  }) async {
    try {
      return await _activitiesApi.getActivities(
        name: name,
        cityId: cityId,
        rating: rating,
      );
    } catch (e) {
      throw Exception('Failed to get activities: $e');
    }
  }

  @override
  Future<Activity> getActivityById(int id) async {
    try {
      return await _activitiesApi.getActivityById(id);
    } catch (e) {
      throw Exception('Failed to get activity: $e');
    }
  }
}