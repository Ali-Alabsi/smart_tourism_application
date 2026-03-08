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
      name: json['name']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : Location(latitude: '', longitude: ''),
      city: json['city'] != null
          ? City.fromJson(json['city'] as Map<String, dynamic>)
          : City(
              id: 0,
              name: '',
              country: '',
              location: Location(latitude: '', longitude: ''),
              createdAt: '',
            ),
      details: json['details']?.toString() ?? '',
      url: json['url']?.toString(),
      priceRange: json['price_range'] != null
          ? PriceRange.fromJson(json['price_range'] as Map<String, dynamic>)
          : PriceRange(min: 0, max: 0),
      isActive: (json['is_active'] as bool?) ?? false,
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      thumbnail: json['thumbnail']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
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
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
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
      name: json['name']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : Location(latitude: '', longitude: ''),
      createdAt: json['created_at']?.toString() ?? '',
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
      min: (json['min'] as int?) ?? 0,
      max: (json['max'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}