import 'package:smart_tourism_application/core/entities/activity.dart';

abstract class IActivitiesRepository {
  Future<List<Activity>> getActivities({
    String? name,
    int? cityId,
    int? rating,
  });

  Future<Activity> getActivityById(int id);

}