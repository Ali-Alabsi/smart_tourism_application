import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/core/use_cases/destination/search_destinations.dart';
import 'package:smart_tourism_application/core/use_cases/destination/get_recommendations.dart';

class DestinationService {
  final SearchDestinations _searchDestinations;
  final GetRecommendations _getRecommendations;

  DestinationService(this._searchDestinations, this._getRecommendations);

  Future<List<Destination>> searchDestinations({
    String? query,
    String? location,
    double? minRating,
  }) async {
    return await _searchDestinations.execute(
      query: query,
      location: location,
      minRating: minRating,
    );
  }

  Future<List<Destination>> getRecommendations(String userId) async {
    return await _getRecommendations.execute(userId: userId);
  }
}