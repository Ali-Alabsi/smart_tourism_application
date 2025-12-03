import 'package:smart_tourism_application/core/entities/destination.dart';
import 'package:smart_tourism_application/data/models/destination_model.dart';

class DestinationMapper {
  static Destination toEntity(DestinationModel model) {
    return Destination(
      id: model.id,
      name: model.name,
      description: model.description,
      imageUrl: model.imageUrl,
      rating: model.rating,
      location: model.location,
      price: model.price,
      features: model.features,
    );
  }

  static DestinationModel toModel(Destination entity) {
    return DestinationModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      location: entity.location,
      price: entity.price,
      features: entity.features,
    );
  }
}