import 'package:smart_tourism_application/core/entities/flight.dart';

abstract class IFlightsRepository {
  Future<List<Flight>> getFlights({
    String? name,
    int? cityId,
    int? rating,
  });

  Future<Flight> getFlightById(int id);
}