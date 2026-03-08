class Hotel {
  final int id;
  final String name;
  final String address;
  final Location location;
  final City city;
  final String? url;
  final PriceRange priceRange;
  final String details;
  final bool isActive;
  final List<String> images;
  final String featuredImage;
  final List<Service> services;
  final String createdAt;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.city,
    required this.url,
    required this.priceRange,
    required this.details,
    required this.isActive,
    required this.images,
    required this.featuredImage,
    required this.services,
    required this.createdAt,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
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
      url: json['url']?.toString(),
      priceRange: json['price_range'] != null
          ? PriceRange.fromJson(json['price_range'] as Map<String, dynamic>)
          : PriceRange(min: 0, max: 0),
      details: json['details']?.toString() ?? '',
      isActive: (json['is_active'] as bool?) ?? false,
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      featuredImage: json['featured_image']?.toString() ?? '',
      services: (json['services'] as List<dynamic>? ?? const [])
          .map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'location': location.toJson(),
      'city': city.toJson(),
      'url': url,
      'price_range': priceRange.toJson(),
      'details': details,
      'is_active': isActive,
      'images': images,
      'featured_image': featuredImage,
      'services': services.map((e) => e.toJson()).toList(),
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

class Service {
  final int id;
  final String name;
  final String icon;
  final String description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  Service({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isActive: (json['is_active'] as bool?) ?? false,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}