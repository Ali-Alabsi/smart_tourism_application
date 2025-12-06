import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/use_cases/user/login_user.dart';
import 'package:smart_tourism_application/core/use_cases/user/register_user.dart';
import 'package:smart_tourism_application/core/use_cases/user/update_profile.dart';
import 'package:smart_tourism_application/core/use_cases/user/change_password.dart';
import 'package:smart_tourism_application/core/use_cases/user/forgot_password.dart';

class AuthService {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final UpdateProfile _updateProfile;
  final ChangePassword _changePassword;
  final ForgotPassword _forgotPassword;

  AuthService(
    this._loginUser,
    this._registerUser,
    this._updateProfile,
    this._changePassword,
    this._forgotPassword,
  );

  Future<User> login(String email, String password) async {
    return await _loginUser.execute(email: email, password: password);
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    return await _registerUser.execute(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }

  Future<User> updateProfile(User user) async {
    return await _updateProfile.execute(
      userId: user.id,
      user: user,
    );
  }

  Future<User> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    return await _changePassword.execute(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }

  Future<void> forgotPassword(String email) async {
    return await _forgotPassword.execute(email);
  }
}