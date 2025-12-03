import 'package:smart_tourism_application/core/entities/destination.dart';

abstract class IDestinationRepository {
  Future<List<Destination>> searchDestinations({
    String? query,
    String? location,
    double? minRating,
  });

  Future<List<Destination>> getRecommendations({
    required String userId,
  });
}