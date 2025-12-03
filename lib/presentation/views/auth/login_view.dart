import 'package:flutter/material.dart';
import 'package:smart_tourism_application/presentation/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/presentation/views/auth/verification_view.dart';
import 'package:smart_tourism_application/presentation/views/home/home_view.dart';

import '../../../core/theme/app_colors.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Set up the callback for successful login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(context, listen: false);
      authController.onLoginSuccess = () {
        // Navigate to HomeView after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo2.png',
                    height: 120,
                  ),
                  // Body Content
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'sign in to access your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 120),
                ],
              ),
              // Form Fields
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.email_outlined),
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.lock_outline),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Error message display
                  if (authController.errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        authController.errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  // Success message display
                  if (authController.successMessage != null)
                    Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        authController.successMessage!,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      Text('Remember me'),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text('Forget password ?',
                        style: TextStyle(
                          color: AppColors.primary,
                        ),)
                      ),
                    ],
                  ),
                  SizedBox(height: 120),
                ],
              ),

              // Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authController.isLoading
                          ? null
                          : () {
                              if (_emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                authController.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: authController.isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Login >',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Verification button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationView(
                            email: _emailController.text.isEmpty 
                                ? 'user@example.com' 
                                : _emailController.text,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Continue with Email Verification',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Footer
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to registration screen
                      },
                      child: Text('New Member? Register now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}