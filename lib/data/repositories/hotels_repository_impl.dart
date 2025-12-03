import 'package:smart_tourism_application/core/entities/hotel.dart';
import 'package:smart_tourism_application/core/repositories/i_hotels_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/hotels_api.dart';

class HotelsRepositoryImpl implements IHotelsRepository {
  final HotelsApi _hotelsApi;

  HotelsRepositoryImpl(this._hotelsApi);

  @override
  Future<List<Hotel>> getHotels() async {
    try {
      return await _hotelsApi.getHotels();
    } catch (e) {
      throw Exception('Failed to get hotels: $e');
    }
  }
}