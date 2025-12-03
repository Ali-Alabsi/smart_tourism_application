import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/services/api/destination_service.dart';

class DestinationController extends ChangeNotifier {
  final DestinationService _destinationService;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Destination> _searchResults = [];
  Destination? _selectedDestination;

  DestinationController(this._destinationService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Destination> get searchResults => _searchResults;
  Destination? get selectedDestination => _selectedDestination;

  Future<void> searchDestinations({
    String? query,
    String? location,
    double? minRating,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _destinationService.searchDestinations(
        query: query,
        location: location,
        minRating: minRating,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectDestination(Destination destination) {
    _selectedDestination = destination;
    notifyListeners();
  }
}