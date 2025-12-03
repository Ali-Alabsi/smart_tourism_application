import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/repositories/i_user_repository.dart';
import 'package:smart_tourism_application/data/datasources/remote/auth_api.dart';
import 'package:smart_tourism_application/data/datasources/local/shared_prefs.dart';
import 'package:smart_tourism_application/data/models/user_model.dart';

class UserRepositoryImpl implements IUserRepository {
  final AuthApi _authApi;
  final SharedPrefs _sharedPrefs;

  UserRepositoryImpl(this._authApi, this._sharedPrefs);

  @override
  Future<User> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final userModel = await _authApi.registerUser(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      
      // Save user data locally
      await _sharedPrefs.setString('userId', userModel.id);
      await _sharedPrefs.setString('userName', userModel.name);
      await _sharedPrefs.setString('userEmail', userModel.email);
      
      return userModel;
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  @override
  Future<User> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _authApi.loginUser(
        email: email,
        password: password,
      );
      
      // Save user data locally
      await _sharedPrefs.setString('userId', userModel.id);
      await _sharedPrefs.setString('userName', userModel.name);
      await _sharedPrefs.setString('userEmail', userModel.email);
      await _sharedPrefs.setBool('isLoggedIn', true);
      
      return userModel;
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<User> updateProfile({
    required String userId,
    required User user,
  }) async {
    // In a real implementation, this would call an API to update the user profile
    // For now, we'll just return the user as is
    return user;
  }

  @override
  Future<void> logoutUser() async {
    try {
      await _authApi.logoutUser();
      
      // Clear local user data
      await _sharedPrefs.remove('userId');
      await _sharedPrefs.remove('userName');
      await _sharedPrefs.remove('userEmail');
      await _sharedPrefs.setBool('isLoggedIn', false);
    } catch (e) {
      throw Exception('Failed to logout user: $e');
    }
  }
}