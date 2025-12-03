import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/repositories/i_budget_repository.dart';

class SetBudget {
  final IBudgetRepository _budgetRepository;

  SetBudget(this._budgetRepository);

  Future<Budget> execute({
    required String userId,
    required double totalAmount,
    required Map<String, double> allocations,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _budgetRepository.setBudget(
      userId: userId,
      totalAmount: totalAmount,
      allocations: allocations,
      startDate: startDate,
      endDate: endDate,
    );
  }
}