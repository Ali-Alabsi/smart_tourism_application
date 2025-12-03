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