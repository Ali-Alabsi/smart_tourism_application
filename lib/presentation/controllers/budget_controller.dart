import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/entities/city.dart' as entities;
import 'package:smart_tourism_application/core/use_cases/budget/set_budget.dart';
import 'package:smart_tourism_application/core/use_cases/budget/split_group_budget.dart';
import 'package:smart_tourism_application/core/use_cases/budget/plan_trip.dart';
import 'package:smart_tourism_application/core/use_cases/budget/get_budgets.dart';
import 'package:smart_tourism_application/core/use_cases/city/get_cities.dart';
import 'package:smart_tourism_application/data/models/budgets_responce_model.dart';

class BudgetController extends ChangeNotifier {
  final SetBudget _setBudget;
  final SplitGroupBudget _splitGroupBudget;
  final PlanTrip _planTrip;
  final GetBudgets _getBudgets;
  final GetCities _getCities;
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Budget? _currentBudget;
  bool _isCitiesLoading = false;
  String? _citiesError;
  List<entities.City> _cities = [];
  bool _isBudgetsLoading = false;
  String? _budgetsError;
  BudgetsResponce? _budgetsResponse;

  BudgetController(
    this._setBudget,
    this._splitGroupBudget,
    this._planTrip,
    this._getBudgets,
    this._getCities,
  );

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Budget? get currentBudget => _currentBudget;
  bool get isCitiesLoading => _isCitiesLoading;
  String? get citiesError => _citiesError;
  List<entities.City> get cities => _cities;
  bool get isBudgetsLoading => _isBudgetsLoading;
  String? get budgetsError => _budgetsError;
  BudgetsResponce? get budgetsResponse => _budgetsResponse;
  List<Datum> get budgets => _budgetsResponse?.data ?? [];

  Future<void> loadCities() async {
    _isCitiesLoading = true;
    _citiesError = null;
    notifyListeners();

    try {
      _cities = await _getCities.execute();
    } catch (e) {
      _citiesError = e.toString();
    } finally {
      _isCitiesLoading = false;
      notifyListeners();
    }
  }

  Future<void> setBudget({
    required String userId,
    required double totalAmount,
    required Map<String, double> allocations,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentBudget = await _setBudget.execute(
        userId: userId,
        totalAmount: totalAmount,
        allocations: allocations,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> splitGroupBudget({
    required String userId,
    required double totalAmount,
    required List<String> memberIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentBudget = await _splitGroupBudget.execute(
        userId: userId,
        totalAmount: totalAmount,
        memberIds: memberIds,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> planTrip({
    required String userId,
    required int totalBudget,
    required int peopleCount,
    required int days,
    required String destination,
    required int cityId,
    required Map<String, double> percentages,
    required String name,
    required String address,
    required int fromCityId,
    required int toCityId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _currentBudget = await _planTrip.execute(
        userId: userId,
        totalBudget: totalBudget,
        peopleCount: peopleCount,
        days: days,
        destination: destination,
        cityId: cityId,
        percentages: percentages,
        name: name,
        address: address,
        fromCityId: fromCityId,
        toCityId: toCityId,
      );
      _successMessage = 'Budget plan created successfully!';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBudgets() async {
    _isBudgetsLoading = true;
    _budgetsError = null;
    // Clear previous data before loading new data
    _budgetsResponse = null;
    notifyListeners();

    try {
      _budgetsResponse = await _getBudgets.execute();
    } catch (e) {
      _budgetsError = e.toString();
      // Clear data on error
      _budgetsResponse = null;
    } finally {
      _isBudgetsLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}