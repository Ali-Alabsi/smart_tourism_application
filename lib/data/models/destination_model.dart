import 'package:smart_tourism_application/core/entities/destination.dart';

class DestinationModel extends Destination {
  DestinationModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.rating,
    required super.location,
    required super.price,
    required super.features,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      features: List<String>.from(json['features'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'location': location,
      'price': price,
      'features': features,
    };
  }

  Destination toEntity() {
    return Destination(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      location: location,
      price: price,
      features: features,
    );
  }

  factory DestinationModel.fromEntity(Destination destination) {
    return DestinationModel(
      id: destination.id,
      name: destination.name,
      description: destination.description,
      imageUrl: destination.imageUrl,
      rating: destination.rating,
      location: destination.location,
      price: destination.price,
      features: destination.features,
    );
  }
}