import 'package:flutter/material.dart';
import 'package:smart_tourism_application/presentation/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(context, listen: false);
      authController.onRegisterSuccess = () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
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
              Image.asset(
                'assets/images/logo2.png',
                height: 120,
              ),
              Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'by creating a free account.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 48),
              
              // Form Fields
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primary.withOpacity(0.1),
                  suffixIcon: Icon(Icons.person_2_outlined),
                  hintText: 'Full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primary.withOpacity(0.1),
                  suffixIcon: Icon(Icons.email_outlined),
                  hintText: 'Valid email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primary.withOpacity(0.1),
                  suffixIcon: Icon(Icons.phone_outlined),
                  hintText: 'Phone number',
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
                  filled: true,
                  fillColor: AppColors.primary.withOpacity(0.1),
                  suffixIcon: Icon(Icons.lock_outline),
                  hintText: 'Strong Password',
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
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'By checking the box you agree to our Terms and Conditions.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              
              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _agreedToTerms
                      ? () {
                          if (_nameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            authController.register(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              phoneNumber: _phoneController.text,
                            );
                          }
                        }
                      : null,
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
                          'Create Account >',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24),
              
              // Footer
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to login screen
                    Navigator.pop(context);
                  },
                  child: Text('Already a member? Log in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}