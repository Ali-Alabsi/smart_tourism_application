import 'package:smart_tourism_application/core/entities/flight.dart';
import 'package:smart_tourism_application/core/repositories/i_flights_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/flights_api.dart';

class FlightsRepositoryImpl implements IFlightsRepository {
  final FlightsApi _flightsApi;

  FlightsRepositoryImpl(this._flightsApi);

  @override
  Future<List<Flight>> getFlights({
    String? name,
    int? cityId,
    int? rating,
  }) async {
    try {
      return await _flightsApi.getFlights(
        name: name,
        cityId: cityId,
        rating: rating,
      );
    } catch (e) {
      throw Exception('Failed to get flights: $e');
    }
  }

  @override
  Future<Flight> getFlightById(int id) async {
    try {
      return await _flightsApi.getFlightById(id);
    } catch (e) {
      throw Exception('Failed to get flight: $e');
    }
  }
}