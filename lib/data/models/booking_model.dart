import 'package:smart_tourism_application/core/entities/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.userId,
    required super.destinationId,
    required super.startDate,
    required super.endDate,
    required super.numberOfGuests,
    required super.totalPrice,
    required super.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      destinationId: json['destinationId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      numberOfGuests: json['numberOfGuests'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'destinationId': destinationId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  Booking toEntity() {
    return Booking(
      id: id,
      userId: userId,
      destinationId: destinationId,
      startDate: startDate,
      endDate: endDate,
      numberOfGuests: numberOfGuests,
      totalPrice: totalPrice,
      status: status,
    );
  }

  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      id: booking.id,
      userId: booking.userId,
      destinationId: booking.destinationId,
      startDate: booking.startDate,
      endDate: booking.endDate,
      numberOfGuests: booking.numberOfGuests,
      totalPrice: booking.totalPrice,
      status: booking.status,
    );
  }
}