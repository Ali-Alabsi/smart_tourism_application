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

  Future<Hotel> getHotelById(int id) async {
    try {
      final response = await _dioClient.get('/api/hotels/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return Hotel.fromJson(data['data']);
        } else {
          throw Exception('Failed to load hotel: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load hotel: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load hotel: ${e.response?.data}');
      } else {
        throw Exception('Failed to load hotel: ${e.message}');
      }
    }
  }
}