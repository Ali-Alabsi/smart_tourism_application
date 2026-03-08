import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/core/entities/hotel.dart';
import 'package:smart_tourism_application/core/entities/restaurant.dart';
import 'package:smart_tourism_application/core/entities/flight.dart';
import 'package:smart_tourism_application/core/entities/activity.dart';
import 'package:smart_tourism_application/core/repositories/i_hotels_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_restaurants_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_flights_repository.dart';
import 'package:smart_tourism_application/core/repositories/i_activities_repository.dart';

class DestinationsController with ChangeNotifier {
  final IHotelsRepository _hotelsRepository;
  final IRestaurantsRepository _restaurantsRepository;
  final IFlightsRepository _flightsRepository;
  final IActivitiesRepository _activitiesRepository;

  DestinationsController(
    this._hotelsRepository,
    this._restaurantsRepository,
    this._flightsRepository,
    this._activitiesRepository,
  );

  bool _isLoading = false;
  String? _errorMessage;
  List<Destination> _destinations = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Destination> get destinations => _destinations;

  // أول 5 كـ "Featured"
  List<Destination> get featuredDestinations =>
      _destinations.take(5).toList();

  // أول عناصر كـ "Popular"
  List<Destination> get popularDestinations => _destinations.skip(5).take(8).toList();

  Future<void> loadDestinations({String? name}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // نجلب مجموعة صغيرة من كل نوع (يمكنك تعديل العدد)
      final hotels = await _hotelsRepository.getHotels(name: name);
      final restaurants =
          await _restaurantsRepository.getRestaurants(name: name);
      final flights = await _flightsRepository.getFlights(name: name);
      final activities =
          await _activitiesRepository.getActivities(name: name);

      final List<Destination> combined = [];

      combined.addAll(
        hotels.take(5).map(_mapHotelToDestination),
      );
      combined.addAll(
        restaurants.take(5).map(_mapRestaurantToDestination),
      );
      combined.addAll(
        flights.take(5).map(_mapFlightToDestination),
      );
      combined.addAll(
        activities.take(5).map(_mapActivityToDestination),
      );

      _destinations = combined;
    } catch (e) {
      _errorMessage = e.toString();
      _destinations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchDestinations(String query) async {
    await loadDestinations(name: query.isEmpty ? null : query);
  }

  Destination _mapHotelToDestination(Hotel hotel) {
    return Destination(
      id: 'hotel-${hotel.id}',
      name: hotel.name,
      description: hotel.details,
      imageUrl: hotel.featuredImage,
      rating: 0, // يمكن ربطه بتقييم الفنادق لاحقًا
      location: hotel.city.name,
      price: hotel.priceRange.min.toDouble(),
      features: ['Hotel', hotel.address],
    );
  }

  Destination _mapRestaurantToDestination(Restaurant restaurant) {
    final image = restaurant.images.isNotEmpty ? restaurant.images.first : '';
    return Destination(
      id: 'restaurant-${restaurant.id}',
      name: restaurant.name,
      description: restaurant.cuisineType,
      imageUrl: image,
      rating: 0,
      location: restaurant.address,
      price: 0,
      features: ['Restaurant', restaurant.cuisineType],
    );
  }

  Destination _mapFlightToDestination(Flight flight) {
    return Destination(
      id: 'flight-${flight.id}',
      name: flight.name,
      description: flight.details,
      imageUrl: flight.logo,
      rating: flight.averageRating ?? 0,
      location: flight.address,
      price: 0,
      features: ['Airline', '${flight.plainTravelsCount} routes'],
    );
  }

  Destination _mapActivityToDestination(Activity activity) {
    return Destination(
      id: 'activity-${activity.id}',
      name: activity.name,
      description: activity.details,
      imageUrl: activity.thumbnail,
      rating: 0,
      location: activity.address,
      price: activity.priceRange.min.toDouble(),
      features: ['Activity', activity.date],
    );
  }
}