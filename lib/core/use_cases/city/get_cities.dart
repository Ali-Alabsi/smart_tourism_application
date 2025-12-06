import 'package:smart_tourism_application/core/entities/city.dart';
import 'package:smart_tourism_application/core/repositories/i_city_repository.dart';

class GetCities {
  final ICityRepository _cityRepository;

  GetCities(this._cityRepository);

  Future<List<City>> execute() {
    return _cityRepository.fetchCities();
  }
}


