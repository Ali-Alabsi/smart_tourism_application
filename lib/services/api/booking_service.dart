import 'package:smart_tourism_application/core/entities/booking.dart';
import 'package:smart_tourism_application/core/use_cases/booking/create_booking.dart';
import 'package:smart_tourism_application/core/use_cases/booking/get_user_bookings.dart';

class BookingService {
  final CreateBooking _createBooking;
  final GetUserBookings _getUserBookings;

  BookingService(this._createBooking, this._getUserBookings);

  Future<Booking> createBooking({
    required String userId,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int numberOfGuests,
  }) async {
    return await _createBooking.execute(
      userId: userId,
      destinationId: destinationId,
      startDate: startDate,
      endDate: endDate,
      numberOfGuests: numberOfGuests,
    );
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    return await _getUserBookings.execute(userId: userId);
  }
}