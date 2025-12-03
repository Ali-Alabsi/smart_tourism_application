import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:dio/dio.dart';

class DestinationApi {
  final DioClient _dioClient;

  DestinationApi(this._dioClient);

  Future<List<Destination>> searchDestinations({
    String? query,
    String? location,
    double? minRating,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (query != null) queryParams['query'] = query;
      if (location != null) queryParams['location'] = location;
      if (minRating != null) queryParams['minRating'] = minRating;

      final response = await _dioClient.get('/destinations', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Destination.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load destinations: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load destinations: ${e.response?.data}');
      } else {
        throw Exception('Failed to load destinations: ${e.message}');
      }
    }
  }

  Future<List<Destination>> getRecommendations(String userId) async {
    try {
      final response = await _dioClient.get('/recommendations', queryParameters: {'userId': userId});
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Destination.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommendations: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load recommendations: ${e.response?.data}');
      } else {
        throw Exception('Failed to load recommendations: ${e.message}');
      }
    }
  }
}