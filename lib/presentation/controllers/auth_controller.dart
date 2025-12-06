import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/services/api/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  User? _currentUser = User(id: "1", name: "name", email: "email", phoneNumber: "phoneNumber");

  // Callbacks for navigation
  Function()? onLoginSuccess;
  Function()? onRegisterSuccess;

  AuthController(this._authService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(email, password);
      _successMessage = "Login successful";
      // Call the callback to navigate to home
      onLoginSuccess?.call();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      _successMessage = "Registration successful";
      // Call the callback to navigate to login
      onRegisterSuccess?.call();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (_currentUser == null) {
        throw Exception('No user logged in');
      }

      final updatedUser = await _authService.updateProfile(
        _currentUser!.copyWith(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
        ),
      );

      _currentUser = updatedUser;
      _successMessage = "Profile updated successfully";
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      _currentUser = updatedUser;
      _successMessage = "Password changed successfully";
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add verification methods
  Future<void> verifyEmailCode(String code) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // In a real implementation, you would call your verification API here
      // For now, we'll just simulate a successful verification
      await Future.delayed(Duration(seconds: 1));
      // Assuming verification is successful
      _successMessage = "Verification successful";
    } catch (e) {
      _errorMessage = 'Invalid verification code';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendVerificationCode(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // In a real implementation, you would call your resend API here
      // For now, we'll just simulate a successful resend
      await Future.delayed(Duration(seconds: 1));
      // Assuming resend is successful
      _successMessage = "Verification code sent";
    } catch (e) {
      _errorMessage = 'Failed to resend verification code';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _authService.forgotPassword(email);
      _successMessage = "Password reset link sent to your email.";
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _successMessage = "Logged out successfully";
    notifyListeners();
  }
}