import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/use_cases/user/login_user.dart';
import 'package:smart_tourism_application/core/use_cases/user/register_user.dart';

class AuthService {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;

  AuthService(this._loginUser, this._registerUser);

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
}