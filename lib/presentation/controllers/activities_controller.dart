import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/activity.dart';
import 'package:smart_tourism_application/core/repositories/i_activities_repository.dart';

class ActivitiesController extends ChangeNotifier {
  final IActivitiesRepository _activitiesRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Activity> _activities = [];
  Activity? _selectedActivity;
  bool _isLoadingActivity = false;

  ActivitiesController(this._activitiesRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Activity> get activities => _activities;
  Activity? get selectedActivity => _selectedActivity;
  bool get isLoadingActivity => _isLoadingActivity;

  Future<void> loadActivities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activities = await _activitiesRepository.getActivities();
    } catch (e) {
      _errorMessage = e.toString();
      _activities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadActivityById(int id) async {
    _isLoadingActivity = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedActivity = await _activitiesRepository.getActivityById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _selectedActivity = null;
    } finally {
      _isLoadingActivity = false;
      notifyListeners();
    }
  }
}