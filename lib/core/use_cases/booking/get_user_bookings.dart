import 'package:smart_tourism_application/core/entities/booking.dart';
import 'package:smart_tourism_application/core/repositories/i_booking_repository.dart';

class GetUserBookings {
  final IBookingRepository _bookingRepository;

  GetUserBookings(this._bookingRepository);

  Future<List<Booking>> execute({
    required String userId,
  }) {
    return _bookingRepository.getUserBookings(
      userId: userId,
    );
  }
}