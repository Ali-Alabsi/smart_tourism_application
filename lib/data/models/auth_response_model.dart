class AuthResponseModel {
  final bool success;
  final String message;
  final AuthDataModel data;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class AuthDataModel {
  final ApiUserModel user;
  final String token;

  AuthDataModel({
    required this.user,
    required this.token,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: ApiUserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}

class ApiUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool? isVerified;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String avatar;
  final String createdAt;

  ApiUserModel({
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

  factory ApiUserModel.fromJson(Map<String, dynamic> json) {
    return ApiUserModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      isVerified: json['is_verified'] as bool?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      phoneVerifiedAt: json['phone_verified_at'] as String?,
      avatar: json['avatar'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'is_verified': isVerified,
      'email_verified_at': emailVerifiedAt,
      'phone_verified_at': phoneVerifiedAt,
      'avatar': avatar,
      'created_at': createdAt,
    };
  }
}