import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/core/repositories/i_destination_repository.dart';

class SearchDestinations {
  final IDestinationRepository _destinationRepository;

  SearchDestinations(this._destinationRepository);

  Future<List<Destination>> execute({
    String? query,
    String? location,
    double? minRating,
  }) {
    return _destinationRepository.searchDestinations(
      query: query,
      location: location,
      minRating: minRating,
    );
  }
}