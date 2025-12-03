class Activity {
  final int id;
  final String name;
  final String date;
  final String address;
  final Location location;
  final City city;
  final String details;
  final String? url;
  final PriceRange priceRange;
  final bool isActive;
  final List<String> images;
  final String thumbnail;
  final String createdAt;

  Activity({
    required this.id,
    required this.name,
    required this.date,
    required this.address,
    required this.location,
    required this.city,
    required this.details,
    required this.url,
    required this.priceRange,
    required this.isActive,
    required this.images,
    required this.thumbnail,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int,
      name: json['name'] as String,
      date: json['date'] as String,
      address: json['address'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      city: City.fromJson(json['city'] as Map<String, dynamic>),
      details: json['details'] as String,
      url: json['url'] as String?,
      priceRange: PriceRange.fromJson(json['price_range'] as Map<String, dynamic>),
      isActive: json['is_active'] as bool,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnail: json['thumbnail'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'address': address,
      'location': location.toJson(),
      'city': city.toJson(),
      'details': details,
      'url': url,
      'price_range': priceRange.toJson(),
      'is_active': isActive,
      'images': images,
      'thumbnail': thumbnail,
      'created_at': createdAt,
    };
  }
}

class Location {
  final String latitude;
  final String longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class City {
  final int id;
  final String name;
  final String country;
  final Location location;
  final String createdAt;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.location,
    required this.createdAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'location': location.toJson(),
      'created_at': createdAt,
    };
  }
}

class PriceRange {
  final int min;
  final int max;

  PriceRange({
    required this.min,
    required this.max,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: json['min'] as int,
      max: json['max'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}