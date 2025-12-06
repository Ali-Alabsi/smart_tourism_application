import 'package:smart_tourism_application/core/repositories/i_budget_repository.dart';
import 'package:smart_tourism_application/data/models/budgets_responce_model.dart';

class GetBudgets {
  final IBudgetRepository _budgetRepository;

  GetBudgets(this._budgetRepository);

  Future<BudgetsResponce> execute() {
    return _budgetRepository.getBudgets();
  }
}


