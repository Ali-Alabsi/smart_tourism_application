import 'package:smart_tourism_application/core/entities/city.dart';

abstract class ICityRepository {
  Future<List<City>> fetchCities();
}


