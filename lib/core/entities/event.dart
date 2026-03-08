class Event {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String location;
  final double price;
  final int maxParticipants;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.price,
    required this.maxParticipants,
  });

  Event copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    DateTime? date,
    String? location,
    double? price,
    int? maxParticipants,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      location: location ?? this.location,
      price: price ?? this.price,
      maxParticipants: maxParticipants ?? this.maxParticipants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'location': location,
      'price': price,
      'maxParticipants': maxParticipants,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      location: json['location']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      maxParticipants: (json['maxParticipants'] as int?) ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Event &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.date == date &&
      other.location == location &&
      other.price == price &&
      other.maxParticipants == maxParticipants;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      date.hashCode ^
      location.hashCode ^
      price.hashCode ^
      maxParticipants.hashCode;
  }
}