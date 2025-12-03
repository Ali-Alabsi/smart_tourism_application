import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/core/entities/restaurant.dart';
import 'package:dio/dio.dart';

class RestaurantsApi {
  final DioClient _dioClient;

  RestaurantsApi(this._dioClient);

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _dioClient.get('/api/restaurants');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> restaurantsData = data['data'];
          return restaurantsData.map((json) => Restaurant.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load restaurants: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load restaurants: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load restaurants: ${e.response?.data}');
      } else {
        throw Exception('Failed to load restaurants: ${e.message}');
      }
    }
  }

  Future<Restaurant> getRestaurantById(int id) async {
    try {
      final response = await _dioClient.get('/api/restaurants/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return Restaurant.fromJson(data['data']);
        } else {
          throw Exception('Failed to load restaurant: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load restaurant: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load restaurant: ${e.response?.data}');
      } else {
        throw Exception('Failed to load restaurant: ${e.message}');
      }
    }
  }
}