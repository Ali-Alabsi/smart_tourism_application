import 'package:smart_tourism_application/core/repositories/i_budget_repository.dart';

class DeleteBudget {
  final IBudgetRepository _budgetRepository;

  DeleteBudget(this._budgetRepository);

  Future<void> execute(int id) {
    return _budgetRepository.deleteBudget(id);
  }
}


