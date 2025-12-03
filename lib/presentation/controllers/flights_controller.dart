import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/flight.dart';
import 'package:smart_tourism_application/core/repositories/i_flights_repository.dart';

class FlightsController extends ChangeNotifier {
  final IFlightsRepository _flightsRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Flight> _flights = [];
  Flight? _selectedFlight;
  bool _isLoadingFlight = false;

  FlightsController(this._flightsRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Flight> get flights => _flights;
  Flight? get selectedFlight => _selectedFlight;
  bool get isLoadingFlight => _isLoadingFlight;

  Future<void> loadFlights() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _flights = await _flightsRepository.getFlights();
    } catch (e) {
      _errorMessage = e.toString();
      _flights = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFlightById(int id) async {
    _isLoadingFlight = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedFlight = await _flightsRepository.getFlightById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _selectedFlight = null;
    } finally {
      _isLoadingFlight = false;
      notifyListeners();
    }
  }
}