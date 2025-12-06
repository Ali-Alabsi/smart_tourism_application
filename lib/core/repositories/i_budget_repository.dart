import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/data/models/budgets_responce_model.dart';

abstract class IBudgetRepository {
  Future<Budget> setBudget({
    required String userId,
    required double totalAmount,
    required Map<String, double> allocations,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Budget> splitGroupBudget({
    required String userId,
    required double totalAmount,
    required List<String> memberIds,
    required DateTime startDate,
    required DateTime endDate,
  });

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
  });

  Future<BudgetsResponce> getBudgets();
}