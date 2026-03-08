import 'package:smart_tourism_application/core/entities/restaurant.dart';
import 'package:smart_tourism_application/core/repositories/i_restaurants_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/restaurants_api.dart';

class RestaurantsRepositoryImpl implements IRestaurantsRepository {
  final RestaurantsApi _restaurantsApi;

  RestaurantsRepositoryImpl(this._restaurantsApi);

  @override
  Future<List<Restaurant>> getRestaurants({
    String? name,
    int? cityId,
    int? rating,
  }) async {
    try {
      return await _restaurantsApi.getRestaurants(
        name: name,
        cityId: cityId,
        rating: rating,
      );
    } catch (e) {
      throw Exception('Failed to get restaurants: $e');
    }
  }

  @override
  Future<Restaurant> getRestaurantById(int id) async {
    try {
      return await _restaurantsApi.getRestaurantById(id);
    } catch (e) {
      throw Exception('Failed to get restaurant: $e');
    }
  }
}