import 'package:smart_tourism_application/core/repositories/i_user_repository.dart';

class ForgotPassword {
  final IUserRepository _userRepository;

  ForgotPassword(this._userRepository);

  Future<void> execute(String email) {
    return _userRepository.forgotPassword(email);
  }
}

