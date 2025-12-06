import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/repositories/i_budget_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/budget_api.dart';
import 'package:smart_tourism_application/data/models/budgets_responce_model.dart';

class BudgetRepositoryImpl implements IBudgetRepository {
  final BudgetApi _budgetApi;

  BudgetRepositoryImpl(this._budgetApi);

  @override
  Future<Budget> setBudget({
    required String userId,
    required double totalAmount,
    required Map<String, double> allocations,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Calculate days from start and end date
      final days = endDate.difference(startDate).inDays;
      
      // Convert allocations to percentages
      final percentages = <String, double>{};
      if (allocations.containsKey('hotels')) {
        percentages['hotels'] = allocations['hotels']! / totalAmount;
      }
      if (allocations.containsKey('food')) {
        percentages['food'] = allocations['food']! / totalAmount;
      }
      if (allocations.containsKey('activities')) {
        percentages['activities'] = allocations['activities']! / totalAmount;
      }
      if (allocations.containsKey('transport')) {
        percentages['transport'] = allocations['transport']! / totalAmount;
      }

      final response = await _budgetApi.planTrip(
        totalBudget: totalAmount.toInt(),
        peopleCount: 1, // Default, should be passed as parameter
        days: days,
        destination: '', // Should be passed as parameter
        cityId: 1, // Default, should be passed as parameter
        percentages: percentages,
        name: '', // Should be passed as parameter
        address: '', // Should be passed as parameter
        fromCityId: 1, // Default, should be passed as parameter
        toCityId: 1, // Default, should be passed as parameter
        userId: int.parse(userId),
      );

      // Create Budget entity from response
      return Budget(
        id: response['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        totalAmount: totalAmount,
        allocations: allocations,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to set budget: $e');
    }
  }

  @override
  Future<Budget> splitGroupBudget({
    required String userId,
    required double totalAmount,
    required List<String> memberIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // This method might not be needed for plan-trip API
    // For now, we'll use setBudget
    return await setBudget(
      userId: userId,
      totalAmount: totalAmount,
      allocations: {},
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<Budget> planTrip({
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
    try {
      final response = await _budgetApi.planTrip(
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
        userId: int.parse(userId),
      );

      // Calculate allocations from percentages
      final allocations = <String, double>{
        'hotels': (totalBudget * (percentages['hotels'] ?? 0.4)),
        'food': (totalBudget * (percentages['food'] ?? 0.25)),
        'activities': (totalBudget * (percentages['activities'] ?? 0.2)),
        'transport': (totalBudget * (percentages['transport'] ?? 0.15)),
      };

      // Create Budget entity from response
      return Budget(
        id: response['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        totalAmount: totalBudget.toDouble(),
        allocations: allocations,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: days)),
      );
    } catch (e) {
      throw Exception('Failed to plan trip: $e');
    }
  }

  @override
  Future<BudgetsResponce> getBudgets() async {
    try {
      return await _budgetApi.getBudgets();
    } catch (e) {
      throw Exception('Failed to get budgets: $e');
    }
  }
}

