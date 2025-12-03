import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/core/repositories/i_destination_repository.dart';

class GetRecommendations {
  final IDestinationRepository _destinationRepository;

  GetRecommendations(this._destinationRepository);

  Future<List<Destination>> execute({
    required String userId,
  }) {
    return _destinationRepository.getRecommendations(
      userId: userId,
    );
  }
}