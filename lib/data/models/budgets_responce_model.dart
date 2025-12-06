// To parse this JSON data, do
//
//     final budgetsResponce = budgetsResponceFromJson(jsonString);

import 'dart:convert';

BudgetsResponce budgetsResponceFromJson(String str) => BudgetsResponce.fromJson(json.decode(str));

String budgetsResponceToJson(BudgetsResponce data) => json.encode(data.toJson());

class BudgetsResponce {
    bool success;
    String message;
    List<Datum> data;

    BudgetsResponce({
        required this.success,
        required this.message,
        required this.data,
    });

    factory BudgetsResponce.fromJson(Map<String, dynamic> json) => BudgetsResponce(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null 
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String name;
    String address;
    int teamsNumber;
    int days;
    String amount;
    int fromCityId;
    int toCityId;
    int userId;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    City fromCity;
    City toCity;
    User user;
    List<Subcategory> subcategories;

    Datum({
        required this.id,
        required this.name,
        required this.address,
        required this.teamsNumber,
        required this.days,
        required this.amount,
        required this.fromCityId,
        required this.toCityId,
        required this.userId,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.fromCity,
        required this.toCity,
        required this.user,
        required this.subcategories,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        address: json["address"] ?? "",
        teamsNumber: json["teams_number"] ?? 0,
        days: json["days"] ?? 0,
        amount: json["amount"]?.toString() ?? "0.00",
        fromCityId: json["from_city_id"] ?? 0,
        toCityId: json["to_city_id"] ?? 0,
        userId: json["user_id"] ?? 0,
        status: json["status"] ?? "",
        createdAt: json["created_at"] != null 
            ? DateTime.tryParse(json["created_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
        fromCity: json["from_city"] != null 
            ? City.fromJson(json["from_city"])
            : City(id: 0, name: Name.RIYADH, country: Country.SAUDI_ARABIA, location: Location(latitude: "0", longitude: "0"), createdAt: DateTime.now()),
        toCity: json["to_city"] != null
            ? City.fromJson(json["to_city"])
            : City(id: 0, name: Name.RIYADH, country: Country.SAUDI_ARABIA, location: Location(latitude: "0", longitude: "0"), createdAt: DateTime.now()),
        user: json["user"] != null
            ? User.fromJson(json["user"])
            : User(id: 0, fullName: "", email: "", phoneNumber: "", isVerified: false, emailVerifiedAt: null, phoneVerifiedAt: null, avatar: "", createdAt: DateTime.now()),
        subcategories: json["subcategories"] != null
            ? List<Subcategory>.from(json["subcategories"].map((x) => Subcategory.fromJson(x)))
            : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "teams_number": teamsNumber,
        "days": days,
        "amount": amount,
        "from_city_id": fromCityId,
        "to_city_id": toCityId,
        "user_id": userId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "from_city": fromCity.toJson(),
        "to_city": toCity.toJson(),
        "user": user.toJson(),
        "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
    };
}

class City {
    int id;
    Name name;
    Country country;
    Location location;
    DateTime createdAt;

    City({
        required this.id,
        required this.name,
        required this.country,
        required this.location,
        required this.createdAt,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"] ?? 0,
        name: json["name"] != null && nameValues.map.containsKey(json["name"])
            ? nameValues.map[json["name"]]!
            : Name.RIYADH,
        country: json["country"] != null && countryValues.map.containsKey(json["country"])
            ? countryValues.map[json["country"]]!
            : Country.SAUDI_ARABIA,
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : Location(latitude: "0", longitude: "0"),
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "country": countryValues.reverse[country],
        "location": location.toJson(),
        "created_at": createdAt.toIso8601String(),
    };
}

enum Country {
    SAUDI_ARABIA
}

final countryValues = EnumValues({
    "Saudi Arabia": Country.SAUDI_ARABIA
});

class Location {
    String latitude;
    String longitude;

    Location({
        required this.latitude,
        required this.longitude,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toString() ?? "0",
        longitude: json["longitude"]?.toString() ?? "0",
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

enum Name {
    JEDDAH,
    RIYADH
}

final nameValues = EnumValues({
    "Jeddah": Name.JEDDAH,
    "Riyadh": Name.RIYADH
});

class Subcategory {
    int id;
    int budgetId;
    dynamic name;
    Type type;
    int percentage;
    Description description;
    String descriptionText; // Store original description text from API
    dynamic icon;
    dynamic allocatedAmount;
    String spentAmount;
    DateTime createdAt;
    DateTime updatedAt;
    List<Item> items;

    Subcategory({
        required this.id,
        required this.budgetId,
        required this.name,
        required this.type,
        required this.percentage,
        required this.description,
        required this.descriptionText,
        required this.icon,
        required this.allocatedAmount,
        required this.spentAmount,
        required this.createdAt,
        required this.updatedAt,
        required this.items,
    });

    factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["id"] ?? 0,
        budgetId: json["budget_id"] ?? 0,
        name: json["name"],
        type: json["type"] != null && typeValues.map.containsKey(json["type"])
            ? typeValues.map[json["type"]]!
            : Type.OTHER,
        percentage: json["percentage"] ?? 0,
        description: json["description"] != null && descriptionValues.map.containsKey(json["description"])
            ? descriptionValues.map[json["description"]]!
            : Description.DESC,
        descriptionText: json["description"]?.toString() ?? "",
        icon: json["icon"],
        allocatedAmount: json["allocated_amount"],
        spentAmount: json["spent_amount"]?.toString() ?? "0.00",
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
        items: json["items"] != null
            ? List<Item>.from(json["items"].map((x) => Item.fromJson(x)))
            : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "budget_id": budgetId,
        "name": name,
        "type": typeValues.reverse[type],
        "percentage": percentage,
        "description": descriptionText.isNotEmpty ? descriptionText : descriptionValues.reverse[description],
        "icon": icon,
        "allocated_amount": allocatedAmount,
        "spent_amount": spentAmount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

enum Description {
    ACTIVITIES_BUDGET,
    DESC,
    HOTEL_BUDGET,
    RESTAURANT_BUDGET
}

final descriptionValues = EnumValues({
    "Activities budget": Description.ACTIVITIES_BUDGET,
    "desc": Description.DESC,
    "Hotel budget": Description.HOTEL_BUDGET,
    "Restaurant budget": Description.RESTAURANT_BUDGET
});

class Item {
    int id;
    int budgetSubcategoryId;
    int typeId;
    String amount;
    Types? types;
    dynamic purchasedAt;
    DateTime createdAt;
    DateTime updatedAt;

    Item({
        required this.id,
        required this.budgetSubcategoryId,
        required this.typeId,
        required this.amount,
        required this.types,
        required this.purchasedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"] ?? 0,
        budgetSubcategoryId: json["budget_subcategory_id"] ?? 0,
        typeId: json["type_id"] ?? 0,
        amount: json["amount"]?.toString() ?? "0.00",
        types: json["types"] != null && typesValues.map.containsKey(json["types"])
            ? typesValues.map[json["types"]]
            : null,
        purchasedAt: json["purchased_at"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "budget_subcategory_id": budgetSubcategoryId,
        "type_id": typeId,
        "amount": amount,
        "types": types != null ? typesValues.reverse[types] : null,
        "purchased_at": purchasedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

enum Types {
    ACTIVITY,
    MEAL_DAY,
    NIGHT
}

final typesValues = EnumValues({
    "activity": Types.ACTIVITY,
    "meal day": Types.MEAL_DAY,
    "night": Types.NIGHT
});

enum Type {
    ACTIVITIES,
    HOTEL,
    OTHER,
    PLANE,
    RESTAURANT
}

final typeValues = EnumValues({
    "activities": Type.ACTIVITIES,
    "hotel": Type.HOTEL,
    "other": Type.OTHER,
    "plane": Type.PLANE,
    "restaurant": Type.RESTAURANT
});

class User {
    int id;
    String fullName;
    String email;
    String phoneNumber;
    bool isVerified;
    dynamic emailVerifiedAt;
    dynamic phoneVerifiedAt;
    String avatar;
    DateTime createdAt;

    User({
        required this.id,
        required this.fullName,
        required this.email,
        required this.phoneNumber,
        required this.isVerified,
        required this.emailVerifiedAt,
        required this.phoneVerifiedAt,
        required this.avatar,
        required this.createdAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        fullName: json["full_name"] ?? "",
        email: json["email"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        isVerified: json["is_verified"] ?? false,
        emailVerifiedAt: json["email_verified_at"],
        phoneVerifiedAt: json["phone_verified_at"],
        avatar: json["avatar"]?.toString() ?? "",
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"].toString()) ?? DateTime.now()
            : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "is_verified": isVerified,
        "email_verified_at": emailVerifiedAt,
        "phone_verified_at": phoneVerifiedAt,
        "avatar": avatar,
        "created_at": createdAt.toIso8601String(),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}


