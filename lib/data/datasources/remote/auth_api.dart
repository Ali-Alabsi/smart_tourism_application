import 'dart:convert';
import 'package:smart_tourism_application/data/datasources/remote/dio_client.dart';
import 'package:smart_tourism_application/data/models/auth_response_model.dart';
import 'package:smart_tourism_application/data/models/user_model.dart';
import 'package:smart_tourism_application/data/datasources/local/shared_prefs.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final DioClient _dioClient;
  final SharedPrefs _sharedPrefs;

  AuthApi(this._dioClient, this._sharedPrefs);

  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dioClient.post('/api/auth/register', 
        data: {
          'full_name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'phone_number': phoneNumber,
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        
        // Print success message for debugging
        print('Registration Success: ${authResponse.message}');
        
        // Save token
        await _sharedPrefs.setString('authToken', authResponse.data.token);
        
        // Convert to UserModel (existing model)
        final userJson = authResponse.data.user.toJson();
        // Adjust keys to match existing UserModel
        final adjustedUserJson = {
          'id': userJson['id'].toString(),
          'name': userJson['full_name'],
          'email': userJson['email'],
          'phoneNumber': userJson['phone_number'],
        };
        
        return UserModel.fromJson(adjustedUserJson);
      } else {
        throw Exception('Failed to register user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to register user: ${e.response?.data}');
      } else {
        throw Exception('Failed to register user: ${e.message}');
      }
    }
  }

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post('/api/auth/login',
        data: {
          'email': email,
          'password': password,
        }
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        
        // Print success message for debugging
        print('Login Success: ${authResponse.message}');
        
        // Save token
        await _sharedPrefs.setString('authToken', authResponse.data.token);
        
        // Save user_id
        await _sharedPrefs.setString('userId', authResponse.data.user.id.toString());
        
        // Convert to UserModel (existing model)
        final userJson = authResponse.data.user.toJson();
        // Adjust keys to match existing UserModel
        final adjustedUserJson = {
          'id': userJson['id'].toString(),
          'name': userJson['full_name'],
          'email': userJson['email'],
          'phoneNumber': userJson['phone_number'],
        };
        
        return UserModel.fromJson(adjustedUserJson);
      } else {
        throw Exception('Failed to login user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to login user: ${e.response?.data}');
      } else {
        throw Exception('Failed to login user: ${e.message}');
      }
    }
  }

  Future<UserModel> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dioClient.put(
        '/api/auth/profile',
        data: {
          'full_name': fullName,
          'email': email,
          'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        // Expected response:
        // {
        //   "success": true,
        //   "message": "Profile updated successfully",
        //   "data": { ...user fields... }
        // }
        final responseData = response.data as Map<String, dynamic>;
        final userJson = responseData['data'] as Map<String, dynamic>;

        final apiUser = ApiUserModel.fromJson(userJson);
        // Map API user to existing UserModel structure
        final adjustedUserJson = {
          'id': apiUser.id.toString(),
          'name': apiUser.fullName,
          'email': apiUser.email,
          'phoneNumber': apiUser.phoneNumber,
        };

        return UserModel.fromJson(adjustedUserJson);
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to update profile: ${e.response?.data}');
      } else {
        throw Exception('Failed to update profile: ${e.message}');
      }
    }
  }

  Future<UserModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _dioClient.post(
        '/api/auth/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        // Expected response:
        // {
        //   "success": true,
        //   "message": "Password changed successfully",
        //   "data": { ...user fields... }
        // }
        final responseData = response.data as Map<String, dynamic>;
        final userJson = responseData['data'] as Map<String, dynamic>;

        final apiUser = ApiUserModel.fromJson(userJson);
        final adjustedUserJson = {
          'id': apiUser.id.toString(),
          'name': apiUser.fullName,
          'email': apiUser.email,
          'phoneNumber': apiUser.phoneNumber,
        };

        return UserModel.fromJson(adjustedUserJson);
      } else {
        throw Exception('Failed to change password: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to change password: ${e.response?.data}');
      } else {
        throw Exception('Failed to change password: ${e.message}');
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await _dioClient.post(
        '/api/auth/forgot-password',
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final message = responseData['message'] as String;
        print('Forgot Password Success: $message');
      } else {
        throw Exception('Failed to send password reset email: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to send password reset email: ${e.response?.data}');
      } else {
        throw Exception('Failed to send password reset email: ${e.message}');
      }
    }
  }

  Future<void> logoutUser() async {
    try {
      // Get token for authenticated request
      final token = await _sharedPrefs.getString('authToken');
      
      if (token != null) {
        final response = await _dioClient.post('/api/auth/logout', data: {});
        if (response.statusCode == 200) {
          print('Logout Success: User logged out successfully');
        }
      }
      
      // Clear local token regardless
      await _sharedPrefs.remove('authToken');
    } on DioException catch (e) {
      // Even if logout fails, we still clear the local token
      await _sharedPrefs.remove('authToken');
      if (e.response != null) {
        throw Exception('Failed to logout user: ${e.response?.data}');
      } else {
        throw Exception('Failed to logout user: ${e.message}');
      }
    }
  }
}