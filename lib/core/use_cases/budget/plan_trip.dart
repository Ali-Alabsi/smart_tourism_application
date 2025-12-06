import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/repositories/i_budget_repository.dart';

class PlanTrip {
  final IBudgetRepository _budgetRepository;

  PlanTrip(this._budgetRepository);

  Future<Budget> execute({
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
  }) {
    return _budgetRepository.planTrip(
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
  }
}

