import 'package:smart_tourism_application/core/entities/city.dart';
import 'package:smart_tourism_application/core/repositories/i_city_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/cities_api.dart';

class CityRepositoryImpl implements ICityRepository {
  final CitiesApi _citiesApi;

  CityRepositoryImpl(this._citiesApi);

  @override
  Future<List<City>> fetchCities() async {
    try {
      final citiesData = await _citiesApi.fetchCities();
      return citiesData.map((city) {
        final map = city as Map<String, dynamic>;
        final location = map['location'] as Map<String, dynamic>? ?? {};
        return City(
          id: map['id'] as int,
          name: map['name'] as String? ?? '',
          country: map['country'] as String? ?? '',
          latitude: double.tryParse(location['latitude']?.toString() ?? '') ?? 0.0,
          longitude: double.tryParse(location['longitude']?.toString() ?? '') ?? 0.0,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to map cities data: $e');
    }
  }
}


