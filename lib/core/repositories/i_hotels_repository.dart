import 'package:smart_tourism_application/core/entities/hotel.dart';

abstract class IHotelsRepository {
  Future<List<Hotel>> getHotels({
    String? name,
    int? cityId,
    int? rating,
  });

  Future<Hotel> getHotelById(int id);
}