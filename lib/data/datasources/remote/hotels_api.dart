import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/core/entities/hotel.dart';
import 'package:dio/dio.dart';

class HotelsApi {
  final DioClient _dioClient;

  HotelsApi(this._dioClient);

  Future<List<Hotel>> getHotels() async {
    try {
      final response = await _dioClient.get('/api/hotels');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> hotelsData = data['data'];
          return hotelsData.map((json) => Hotel.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load hotels: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load hotels: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load hotels: ${e.response?.data}');
      } else {
        throw Exception('Failed to load hotels: ${e.message}');
      }
    }
  }
}