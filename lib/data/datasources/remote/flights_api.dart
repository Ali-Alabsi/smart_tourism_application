import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/core/entities/flight.dart';
import 'package:dio/dio.dart';

class FlightsApi {
  final DioClient _dioClient;

  FlightsApi(this._dioClient);

  Future<List<Flight>> getFlights() async {
    try {
      final response = await _dioClient.get('/api/plains');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> flightsData = data['data'];
          return flightsData.map((json) => Flight.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load flights: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load flights: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load flights: ${e.response?.data}');
      } else {
        throw Exception('Failed to load flights: ${e.message}');
      }
    }
  }

  Future<Flight> getFlightById(int id) async {
    try {
      final response = await _dioClient.get('/api/plains/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return Flight.fromJson(data['data']);
        } else {
          throw Exception('Failed to load flight: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load flight: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load flight: ${e.response?.data}');
      } else {
        throw Exception('Failed to load flight: ${e.message}');
      }
    }
  }
}