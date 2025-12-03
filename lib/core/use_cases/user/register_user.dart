import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/repositories/i_user_repository.dart';

class RegisterUser {
  final IUserRepository _userRepository;

  RegisterUser(this._userRepository);

  Future<User> execute({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    return _userRepository.registerUser(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }
}