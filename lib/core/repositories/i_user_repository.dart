import 'package:smart_tourism_application/core/entities/user.dart';

abstract class IUserRepository {
  Future<User> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  });

  Future<User> loginUser({
    required String email,
    required String password,
  });

  Future<User> updateProfile({
    required String userId,
    required User user,
  });

  Future<void> logoutUser();
}