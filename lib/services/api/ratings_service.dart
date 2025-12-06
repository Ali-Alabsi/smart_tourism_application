import 'package:smart_tourism_application/core/use_cases/rating/submit_rating.dart';

class RatingsService {
  final SubmitRating _submitRating;

  RatingsService(this._submitRating);

  Future<void> submitRating({
    required int rate,
    required int typeId,
    required String type,
    required String review,
  }) async {
    return await _submitRating.execute(
      rate: rate,
      typeId: typeId,
      type: type,
      review: review,
    );
  }
}

