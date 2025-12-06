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
    try {
      final updatedUserModel = await _authApi.updateProfile(
        fullName: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
      );

      // Update local stored user data
      await _sharedPrefs.setString('userId', updatedUserModel.id);
      await _sharedPrefs.setString('userName', updatedUserModel.name);
      await _sharedPrefs.setString('userEmail', updatedUserModel.email);
      await _sharedPrefs.setString('userPhoneNumber', updatedUserModel.phoneNumber);

      return updatedUserModel;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<User> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final updatedUserModel = await _authApi.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      // Optionally update local stored user data
      await _sharedPrefs.setString('userId', updatedUserModel.id);
      await _sharedPrefs.setString('userName', updatedUserModel.name);
      await _sharedPrefs.setString('userEmail', updatedUserModel.email);
      await _sharedPrefs.setString('userPhoneNumber', updatedUserModel.phoneNumber);

      return updatedUserModel;
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authApi.forgotPassword(email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
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