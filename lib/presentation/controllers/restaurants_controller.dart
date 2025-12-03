import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/restaurant.dart';
import 'package:smart_tourism_application/core/repositories/i_restaurants_repository.dart';

class RestaurantsController extends ChangeNotifier {
  final IRestaurantsRepository _restaurantsRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Restaurant> _restaurants = [];
  Restaurant? _selectedRestaurant;
  bool _isLoadingRestaurant = false;

  RestaurantsController(this._restaurantsRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Restaurant> get restaurants => _restaurants;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  bool get isLoadingRestaurant => _isLoadingRestaurant;

  Future<void> loadRestaurants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _restaurants = await _restaurantsRepository.getRestaurants();
    } catch (e) {
      _errorMessage = e.toString();
      _restaurants = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRestaurantById(int id) async {
    _isLoadingRestaurant = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedRestaurant = await _restaurantsRepository.getRestaurantById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _selectedRestaurant = null;
    } finally {
      _isLoadingRestaurant = false;
      notifyListeners();
    }
  }
}