import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/core/repositories/i_destination_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/destination_api.dart';
import 'package:smart_tourism_application/data/models/destination_model.dart';

class DestinationRepositoryImpl implements IDestinationRepository {
  final DestinationApi _destinationApi;

  DestinationRepositoryImpl(this._destinationApi);

  @override
  Future<List<Destination>> searchDestinations({
    String? query,
    String? location,
    double? minRating,
  }) async {
    try {
      final destinations = await _destinationApi.searchDestinations(
        query: query,
        location: location,
        minRating: minRating,
      );
      
      return destinations;
    } catch (e) {
      throw Exception('Failed to search destinations: $e');
    }
  }

  @override
  Future<List<Destination>> getRecommendations({
    required String userId,
  }) async {
    try {
      final destinations = await _destinationApi.getRecommendations(userId);
      
      return destinations;
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }
}