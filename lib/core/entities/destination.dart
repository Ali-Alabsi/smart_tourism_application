class Destination {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String location;
  final double price;
  final List<String> features;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.price,
    required this.features,
  });

  Destination copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? rating,
    String? location,
    double? price,
    List<String>? features,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      price: price ?? this.price,
      features: features ?? this.features,
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

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Destination &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.rating == rating &&
      other.location == location &&
      other.price == price &&
      other.features == features;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      rating.hashCode ^
      location.hashCode ^
      price.hashCode ^
      features.hashCode;
  }
}