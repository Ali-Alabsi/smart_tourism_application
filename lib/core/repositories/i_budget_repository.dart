import 'package:smart_tourism_application/core/entities/budget.dart';

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
}