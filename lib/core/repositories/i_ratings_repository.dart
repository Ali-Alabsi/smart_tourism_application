abstract class IRatingsRepository {
  Future<void> submitRating({
    required int rate,
    required int typeId,
    required String type,
    required String review,
  });
}

