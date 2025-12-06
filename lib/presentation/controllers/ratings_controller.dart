import 'package:flutter/material.dart';
import 'package:smart_tourism_application/services/api/ratings_service.dart';

class RatingsController extends ChangeNotifier {
  final RatingsService _ratingsService;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  RatingsController(this._ratingsService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> submitRating({
    required int rate,
    required int typeId,
    required String type,
    required String review,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _ratingsService.submitRating(
        rate: rate,
        typeId: typeId,
        type: type,
        review: review,
      );

      _successMessage = "Rating submitted successfully";
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}

