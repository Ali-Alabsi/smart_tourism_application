class Flight {
  final int id;
  final String name;
  final String address;
  final Location location;
  final City? city;
  final String? url;
  final String details;
  final bool isActive;
  final List<String> images;
  final String logo;
  final int plainTravelsCount;
  final List<PlainTravel> plainTravels;
  final double? averageRating;
  final String createdAt;
  final String updatedAt;

  Flight({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.city,
    required this.url,
    required this.details,
    required this.isActive,
    required this.images,
    required this.logo,
    required this.plainTravelsCount,
    required this.plainTravels,
    required this.averageRating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      city: json['city'] != null 
          ? City.fromJson(json['city'] as Map<String, dynamic>) 
          : null,
      url: json['url'] as String?,
      details: json['details'] as String,
      isActive: json['is_active'] as bool,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      logo: json['logo'] as String,
      plainTravelsCount: json['plain_travels_count'] as int,
      plainTravels: (json['plain_travels'] as List<dynamic>)
          .map((e) => PlainTravel.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageRating: json['average_rating'] as double?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
      'details': details,
      'is_active': isActive,
      'images': images,
      'logo': logo,
      'plain_travels_count': plainTravelsCount,
      'plain_travels': plainTravels.map((e) => e.toJson()).toList(),
      'average_rating': averageRating,
      'created_at': createdAt,
      'updated_at': updatedAt,
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

class PlainTravel {
  final int id;
  final int plainId;
  final int fromCityId;
  final int toCityId;
  final String fromPrice;
  final String toPrice;
  final int durationMinutes;
  final String departureTime;
  final String arrivalTime;
  final String createdAt;
  final String updatedAt;

  PlainTravel({
    required this.id,
    required this.plainId,
    required this.fromCityId,
    required this.toCityId,
    required this.fromPrice,
    required this.toPrice,
    required this.durationMinutes,
    required this.departureTime,
    required this.arrivalTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlainTravel.fromJson(Map<String, dynamic> json) {
    return PlainTravel(
      id: json['id'] as int,
      plainId: json['plain_id'] as int,
      fromCityId: json['from_city_id'] as int,
      toCityId: json['to_city_id'] as int,
      fromPrice: json['from_price'] as String,
      toPrice: json['to_price'] as String,
      durationMinutes: json['duration_minutes'] as int,
      departureTime: json['departure_time'] as String,
      arrivalTime: json['arrival_time'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plain_id': plainId,
      'from_city_id': fromCityId,
      'to_city_id': toCityId,
      'from_price': fromPrice,
      'to_price': toPrice,
      'duration_minutes': durationMinutes,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}