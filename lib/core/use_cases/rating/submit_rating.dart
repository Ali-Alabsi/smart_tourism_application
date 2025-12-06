import 'package:smart_tourism_application/core/repositories/i_ratings_repository.dart';

class SubmitRating {
  final IRatingsRepository _ratingsRepository;

  SubmitRating(this._ratingsRepository);

  Future<void> execute({
    required int rate,
    required int typeId,
    required String type,
    required String review,
  }) {
    return _ratingsRepository.submitRating(
      rate: rate,
      typeId: typeId,
      type: type,
      review: review,
    );
  }
}

