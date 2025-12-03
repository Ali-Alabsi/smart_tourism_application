import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/booking.dart';
import 'package:smart_tourism_application/services/api/booking_service.dart';

class BookingController extends ChangeNotifier {
  final BookingService _bookingService;
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Booking> _userBookings = [];
  Booking? _currentBooking;

  BookingController(this._bookingService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Booking> get userBookings => _userBookings;
  Booking? get currentBooking => _currentBooking;

  Future<void> createBooking({
    required String userId,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int numberOfGuests,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentBooking = await _bookingService.createBooking(
        userId: userId,
        destinationId: destinationId,
        startDate: startDate,
        endDate: endDate,
        numberOfGuests: numberOfGuests,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserBookings(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userBookings = await _bookingService.getUserBookings(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}