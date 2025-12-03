import 'package:smart_tourism_application/core/entities/booking.dart';

abstract class IBookingRepository {
  Future<Booking> createBooking({
    required String userId,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int numberOfGuests,
  });

  Future<List<Booking>> getUserBookings({
    required String userId,
  });

  Future<Booking> cancelBooking({
    required String bookingId,
  });
}