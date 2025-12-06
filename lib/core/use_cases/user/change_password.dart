import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/repositories/i_user_repository.dart';

class ChangePassword {
  final IUserRepository _userRepository;

  ChangePassword(this._userRepository);

  Future<User> execute({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return _userRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }
}


