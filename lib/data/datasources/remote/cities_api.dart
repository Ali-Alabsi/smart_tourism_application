import 'package:dio/dio.dart';
import 'package:smart_tourism_application/data/datasources/local/shared_prefs.dart';

import '../../../config/api_config.dart';

class CitiesApi {
  final SharedPrefs _sharedPrefs;
  final Dio _dio;

  CitiesApi(this._sharedPrefs)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );

  Future<List<dynamic>> fetchCities() async {
    try {
      final token = await _sharedPrefs.getString('authToken');
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.get('/api/cities');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List) {
          return data['data'] as List<dynamic>;
        } else {
          throw Exception('Unexpected response format when fetching cities');
        }
      } else {
        throw Exception('Failed to fetch cities: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to fetch cities: ${e.response?.data ?? e.message}');
      } else {
        throw Exception('Failed to fetch cities: ${e.message}');
      }
    }
  }
}


