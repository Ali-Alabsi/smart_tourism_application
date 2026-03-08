class Restaurant {
  final int id;
  final String name;
  final String address;
  final Location location;
  final City? city;
  final String? url;
  final String cuisineType;
  final OpeningHours openingHours;
  final bool isActive;
  final List<String> images;
  final String logo;
  final int foodsCount;
  final Foods foods;
  final String createdAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.city,
    required this.url,
    required this.cuisineType,
    required this.openingHours,
    required this.isActive,
    required this.images,
    required this.logo,
    required this.foodsCount,
    required this.foods,
    required this.createdAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : Location(latitude: '', longitude: ''),
      city: json['city'] != null
          ? City.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      url: json['url']?.toString(),
      cuisineType: json['cuisine_type']?.toString() ?? '',
      openingHours: json['opening_hours'] != null
          ? OpeningHours.fromJson(json['opening_hours'] as Map<String, dynamic>)
          : OpeningHours(openingTime: '', closingTime: ''),
      isActive: (json['is_active'] as bool?) ?? false,
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      logo: json['logo']?.toString() ?? '',
      foodsCount: (json['foods_count'] as int?) ?? 0,
      foods: json['foods'] != null
          ? Foods.fromJson(json['foods'] as Map<String, dynamic>)
          : Foods(data: const [], meta: FoodsMeta(count: 0)),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'location': location.toJson(),
      'city': city?.toJson(),
      'url': url,
      'cuisine_type': cuisineType,
      'opening_hours': openingHours.toJson(),
      'is_active': isActive,
      'images': images,
      'logo': logo,
      'foods_count': foodsCount,
      'foods': foods.toJson(),
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

class OpeningHours {
  final String openingTime;
  final String closingTime;

  OpeningHours({
    required this.openingTime,
    required this.closingTime,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openingTime: json['opening_time']?.toString() ?? '',
      closingTime: json['closing_time']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opening_time': openingTime,
      'closing_time': closingTime,
    };
  }
}

class Foods {
  final List<Food> data;
  final FoodsMeta meta;

  Foods({
    required this.data,
    required this.meta,
  });

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
      data: (json['data'] as List<dynamic>? ?? const [])
          .map((e) => Food.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? FoodsMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : FoodsMeta(count: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class Food {
  final int id;
  final String name;
  final int restaurantId;
  final String type;
  final PriceRange priceRange;
  final String description;
  final bool isAvailable;
  final List<String> images;
  final String mainImage;
  final String createdAt;
  final String updatedAt;

  Food({
    required this.id,
    required this.name,
    required this.restaurantId,
    required this.type,
    required this.priceRange,
    required this.description,
    required this.isAvailable,
    required this.images,
    required this.mainImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      restaurantId: json['restaurant_id'] as int,
      type: json['type']?.toString() ?? '',
      priceRange: json['price_range'] != null
          ? PriceRange.fromJson(json['price_range'] as Map<String, dynamic>)
          : PriceRange(from: '', to: ''),
      description: json['description']?.toString() ?? '',
      isAvailable: (json['is_available'] as bool?) ?? false,
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      mainImage: json['main_image']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'restaurant_id': restaurantId,
      'type': type,
      'price_range': priceRange.toJson(),
      'description': description,
      'is_available': isAvailable,
      'images': images,
      'main_image': mainImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PriceRange {
  final String from;
  final String to;

  PriceRange({
    required this.from,
    required this.to,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}

class FoodsMeta {
  final int count;

  FoodsMeta({
    required this.count,
  });

  factory FoodsMeta.fromJson(Map<String, dynamic> json) {
    return FoodsMeta(
      count: (json['count'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
    };
  }
}