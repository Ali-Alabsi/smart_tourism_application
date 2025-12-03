import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/hotel.dart';
import 'package:smart_tourism_application/core/repositories/i_hotels_repository.dart';

class HotelsController extends ChangeNotifier {
  final IHotelsRepository _hotelsRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Hotel> _hotels = [];

  HotelsController(this._hotelsRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Hotel> get hotels => _hotels;

  Future<void> loadHotels() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _hotels = await _hotelsRepository.getHotels();
    } catch (e) {
      _errorMessage = e.toString();
      _hotels = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}