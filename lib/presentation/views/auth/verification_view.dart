import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/controllers/auth_controller.dart';

class VerificationView extends StatefulWidget {
  final String email;

  const VerificationView({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isResendEnabled = false;
  int _resendCountdown = 30;
  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    
    // Set up focus node listeners
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _isResendEnabled = false;
    _resendCountdown = 30;
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void _handleTextInput(String value, int index) {
    if (value.isEmpty) return;

    // Only allow digits
    if (!RegExp(r'^[0-9]$').hasMatch(value)) return;

    _controllers[index].text = value;

    // Move to next field if not the last one
    if (index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else {
      // If last field, remove focus
      FocusScope.of(context).unfocus();
      _verifyCode();
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      _controllers[index - 1].clear();
    } else {
      _controllers[index].clear();
    }
  }

  void _verifyCode() {
    final code = _controllers.map((controller) => controller.text).join('');
    if (code.length == 6) {
      // Get the auth controller
      final authController = Provider.of<AuthController>(context, listen: false);
      
      // For now, we'll just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification successful!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // In a real app, you would call a verification method here
      // authController.verifyEmailCode(code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendCode() {
    if (_isResendEnabled) {
      // Reset timer
      _startResendTimer();
      
      // Show resend message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code resent to ${widget.email}'),
        ),
      );
      
      // In a real app, you would call a resend method here
      // final authController = Provider.of<AuthController>(context, listen: false);
      // authController.resendVerificationCode(widget.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Text(
              'Almost there',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 24),
            Text(
              'Please enter the 6-digit code sent to your email ${widget.email} for verification.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 8),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: _focusNodes[index].hasFocus
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      onChanged: (value) => _handleTextInput(value, index),
                      onSubmitted: (_) => _verifyCode(),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Verify',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Didn\'t receive any code? Resend Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _isResendEnabled
                      ? 'Click resend to get a new code'
                      : 'Request new code in ${_resendCountdown}s',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 16),
                if (_isResendEnabled)
                  TextButton(
                    onPressed: _resendCode,
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}