import 'package:smart_tourism_application/core/entities/restaurant.dart';

abstract class IRestaurantsRepository {
  Future<List<Restaurant>> getRestaurants({
    String? name,
    int? cityId,
    int? rating,
  });

  Future<Restaurant> getRestaurantById(int id);
}