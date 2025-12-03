import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/repositories/i_budget_repository.dart';

class SplitGroupBudget {
  final IBudgetRepository _budgetRepository;

  SplitGroupBudget(this._budgetRepository);

  Future<Budget> execute({
    required String userId,
    required double totalAmount,
    required List<String> memberIds,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _budgetRepository.splitGroupBudget(
      userId: userId,
      totalAmount: totalAmount,
      memberIds: memberIds,
      startDate: startDate,
      endDate: endDate,
    );
  }
}