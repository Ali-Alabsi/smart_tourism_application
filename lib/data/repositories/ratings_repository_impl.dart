import 'package:smart_tourism_application/core/repositories/i_ratings_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/ratings_api.dart';

class RatingsRepositoryImpl implements IRatingsRepository {
  final RatingsApi _ratingsApi;

  RatingsRepositoryImpl(this._ratingsApi);

  @override
  Future<void> submitRating({
    required int rate,
    required int typeId,
    required String type,
    required String review,
  }) async {
    try {
      await _ratingsApi.submitRating(
        rate: rate,
        typeId: typeId,
        type: type,
        review: review,
      );
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }
}

