import 'package:smart_tourism_application/core/entities/booking.dart';
import 'package:smart_tourism_application/core/repositories/i_booking_repository.dart';

class CreateBooking {
  final IBookingRepository _bookingRepository;

  CreateBooking(this._bookingRepository);

  Future<Booking> execute({
    required String userId,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int numberOfGuests,
  }) {
    return _bookingRepository.createBooking(
      userId: userId,
      destinationId: destinationId,
      startDate: startDate,
      endDate: endDate,
      numberOfGuests: numberOfGuests,
    );
  }
}