import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/services/api/destination_service.dart';

class HomeController extends ChangeNotifier {
  final DestinationService _destinationService;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Destination> _popularDestinations = [];
  List<Destination> _recommendedDestinations = [];

  HomeController(this._destinationService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Destination> get popularDestinations => _popularDestinations;
  List<Destination> get recommendedDestinations => _recommendedDestinations;

  Future<void> loadPopularDestinations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _popularDestinations = await _destinationService.searchDestinations(
        minRating: 4.0,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecommendations(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendedDestinations = await _destinationService.getRecommendations(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}