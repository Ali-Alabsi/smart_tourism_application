import 'package:dio/dio.dart';
import 'package:smart_tourism_application/data/datasources/local/shared_prefs.dart';
import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/data/models/budgets_responce_model.dart';

class BudgetApi {
  final SharedPrefs _sharedPrefs;
  final DioClient _dioClient;

  BudgetApi(this._sharedPrefs, this._dioClient);

  Future<Map<String, dynamic>> planTrip({
    required int totalBudget,
    required int peopleCount,
    required int days,
    required String destination,
    required int cityId,
    required Map<String, double> percentages,
    required String name,
    required String address,
    required int fromCityId,
    required int toCityId,
    required int userId,
  }) async {
    try {
      // Use a separate Dio instance for this API since it has a different base URL
      final dio = Dio();
      dio.options.baseUrl = "https://smart-tourism-application-ai.onrender.com";
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ));
      // Set default headers
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Content-Type'] = 'application/json';
      
      // Get token from SharedPrefs (retrieved from login) and send as Authorization Bearer
      final token = await _sharedPrefs.getString('authToken');
      if (token != null && token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
        print('Bearer $token');
      }
      print('Bearer $token');
      print('Bearer $token');

      final response = await dio.post(
        '/plan-trip',
        data: {
          'total_budget': totalBudget,
          'people_count': peopleCount,
          'days': days,
          'destination': destination,
          'city_id': cityId,
          'percentages': {
            // 'hotels': percentages['hotels'] ?? 0.0,
            // 'food': percentages['food'] ?? 0.0,
            // 'activities': percentages['activities'] ?? 0.0,
            // 'transport': percentages['transport'] ?? 0.0,
            'hotels':  0.4 ,
            'food':  0.25,
            'activities':  0.2,
            'transport': 0.15,
          },
          'name': name,
          'address': address,
          'from_city_id': fromCityId,
          'to_city_id': toCityId,
          'user_id': userId,
        },
      );
      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create budget plan: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception('Failed to create budget plan: ${errorData['message']}');
        }
        throw Exception('Failed to create budget plan: ${e.response?.data ?? e.message}');
      } else {
        // Connection error - provide helpful message
        if (e.type == DioExceptionType.connectionError || 
            e.message?.contains('Connection refused') == true ||
            e.message?.contains('Failed host lookup') == true) {
          throw Exception(
            'Cannot connect to server. Please ensure:\n'
            '1. The server is running on port 8000\n'
            '2. For Android Emulator, server should be accessible via 10.0.2.2:8000\n'
            '3. For physical device, use your computer\'s IP address instead of 127.0.0.1'
          );
        }
        throw Exception('Failed to create budget plan: ${e.message ?? "Unknown error"}');
      }
    } catch (e) {
      throw Exception('Failed to create budget plan: $e');
    }
  }

  Future<BudgetsResponce> getBudgets() async {
    try {
      final response = await _dioClient.get('/api/budgets');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data['success'] == true) {
            return BudgetsResponce.fromJson(data);
          } else {
            throw Exception('Failed to load budgets: ${data['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load budgets: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception('Failed to load budgets: ${errorData['message']}');
        }
        throw Exception('Failed to load budgets: ${e.response?.data ?? e.message}');
      } else {
        throw Exception('Failed to load budgets: ${e.message ?? "Unknown error"}');
      }
    } catch (e) {
      throw Exception('Failed to load budgets: $e');
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      final response = await _dioClient.delete('/api/budgets/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully deleted, nothing to return
        return;
      } else {
        throw Exception('Failed to delete budget: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception('Failed to delete budget: ${errorData['message']}');
        }
        throw Exception('Failed to delete budget: ${e.response?.data ?? e.message}');
      } else {
        throw Exception('Failed to delete budget: ${e.message ?? "Unknown error"}');
      }
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }
}