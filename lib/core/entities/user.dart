class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode;
  }
}