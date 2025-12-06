import 'package:smart_tourism_application/core/entities/hotel.dart';

abstract class IHotelsRepository {
  Future<List<Hotel>> getHotels();
  Future<Hotel> getHotelById(int id);
}