import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/repositories/i_user_repository.dart';

class LoginUser {
  final IUserRepository _userRepository;

  LoginUser(this._userRepository);

  Future<User> execute({
    required String email,
    required String password,
  }) {
    return _userRepository.loginUser(
      email: email,
      password: password,
    );
  }
}