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
      name: json['name'] as String,
      address: json['address'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      city: City.fromJson(json['city'] as Map<String, dynamic>),
      url: json['url'] as String?,
      priceRange: PriceRange.fromJson(json['price_range'] as Map<String, dynamic>),
      details: json['details'] as String,
      isActive: json['is_active'] as bool,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      featuredImage: json['featured_image'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
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
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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