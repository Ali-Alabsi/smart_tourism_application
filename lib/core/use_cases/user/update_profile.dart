import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/repositories/i_user_repository.dart';

class UpdateProfile {
  final IUserRepository _userRepository;

  UpdateProfile(this._userRepository);

  Future<User> execute({
    required String userId,
    required User user,
  }) {
    return _userRepository.updateProfile(
      userId: userId,
      user: user,
    );
  }
}