class TourGuide {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String language;
  final double hourlyRate;
  final List<String> specialties;

  TourGuide({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.language,
    required this.hourlyRate,
    required this.specialties,
  });

  TourGuide copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? rating,
    String? language,
    double? hourlyRate,
    List<String>? specialties,
  }) {
    return TourGuide(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      language: language ?? this.language,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      specialties: specialties ?? this.specialties,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'language': language,
      'hourlyRate': hourlyRate,
      'specialties': specialties,
    };
  }

  factory TourGuide.fromJson(Map<String, dynamic> json) {
    return TourGuide(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      language: json['language'] as String,
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      specialties: List<String>.from(json['specialties'] as List),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TourGuide &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.rating == rating &&
      other.language == language &&
      other.hourlyRate == hourlyRate &&
      other.specialties == specialties;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      rating.hashCode ^
      language.hashCode ^
      hourlyRate.hashCode ^
      specialties.hashCode;
  }
}