import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/budget.dart';
import 'package:smart_tourism_application/core/use_cases/budget/set_budget.dart';
import 'package:smart_tourism_application/core/use_cases/budget/split_group_budget.dart';

class BudgetController extends ChangeNotifier {
  final SetBudget _setBudget;
  final SplitGroupBudget _splitGroupBudget;
  
  bool _isLoading = false;
  String? _errorMessage;
  Budget? _currentBudget;

  BudgetController(this._setBudget, this._splitGroupBudget);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Budget? get currentBudget => _currentBudget;

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
}