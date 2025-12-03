import 'package:smart_tourism_application/core/entities/flight.dart';

abstract class IFlightsRepository {
  Future<List<Flight>> getFlights();
  Future<Flight> getFlightById(int id);
}