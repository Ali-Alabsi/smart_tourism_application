import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/user.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _showChangePassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authController = Provider.of<AuthController>(context, listen: false);
    if (authController.currentUser != null) {
      _nameController.text = authController.currentUser!.name;
      _emailController.text = authController.currentUser!.email;
      _phoneController.text = authController.currentUser!.phoneNumber;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'), // English localization
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  // Save changes
                  _saveProfile();
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          if (authController.currentUser == null) {
            return Center(
              child: Text(
                'No user data available', // English localization
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Section
                _buildProfileHeader(authController.currentUser!),
                
                SizedBox(height: 24),
                
                // Personal Information Section
                _buildPersonalInfoSection(),
                
                SizedBox(height: 24),
                
                // Change Password Section
                _buildChangePasswordSection(),
                
                SizedBox(height: 24),
                
                // Notification Settings Section
                // _buildNotificationSettingsSection(),
                
                SizedBox(height: 24),
                
                // Privacy Controls Section
                _buildPrivacyControlsSection(),
                
                SizedBox(height: 24),
                
                // Account Actions
                _buildAccountActions(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email,
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
      ),
      validator: validator,
    );
  }

  Widget _buildChangePasswordSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showChangePassword ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _showChangePassword = !_showChangePassword;
                    });
                  },
                ),
              ],
            ),
            if (_showChangePassword) ...[
              SizedBox(height: 16),
              _buildTextField(
                controller: _currentPasswordController,
                label: 'Current Password',
                icon: Icons.lock,
                enabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _newPasswordController,
                label: 'New Password',
                icon: Icons.lock_outline,
                enabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirm New Password',
                icon: Icons.lock_outline,
                enabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Update Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget _buildNotificationSettingsSection() {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Notification Settings',
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: AppColors.primary,
  //             ),
  //           ),
  //           SizedBox(height: 16),
  //           _buildSwitchListTile(
  //             title: 'Email Notifications',
  //             subtitle: 'Receive email updates about your bookings and activities',
  //             value: true,
  //             onChanged: (value) {},
  //           ),
  //           Divider(),
  //           _buildSwitchListTile(
  //             title: 'Push Notifications',
  //             subtitle: 'Receive push notifications on your device',
  //             value: true,
  //             onChanged: (value) {},
  //           ),
  //           Divider(),
  //           _buildSwitchListTile(
  //             title: 'SMS Notifications',
  //             subtitle: 'Receive SMS alerts for important updates',
  //             value: false,
  //             onChanged: (value) {},
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      inactiveThumbColor: Colors.grey[400],
      inactiveTrackColor: Colors.grey[300],
    );
  }

  Widget _buildPrivacyControlsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Controls',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16),
            _buildSwitchListTile(
              title: 'Profile Visibility',
              subtitle: 'Make your profile visible to other users',
              value: true,
              onChanged: (value) {},
            ),
            Divider(),
            _buildSwitchListTile(
              title: 'Location Sharing',
              subtitle: 'Share your location with travel companions',
              value: false,
              onChanged: (value) {},
            ),
            Divider(),
            _buildSwitchListTile(
              title: 'Activity History',
              subtitle: 'Save your travel history for recommendations',
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.history,
                color: AppColors.primary,
              ),
              title: Text('Booking History'),
              subtitle: Text('View your past bookings and activities'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to booking history
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.bookmark,
                color: AppColors.primary,
              ),
              title: Text('Saved Items'),
              subtitle: Text('View your saved destinations and activities'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to saved items
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: Text('Sign out of your account'),
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save profile changes
      final authController = Provider.of<AuthController>(context, listen: false);
      // In a real implementation, you would call the updateProfile API here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'), // English localization
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleChangePassword() {
    if (_currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        // In a real implementation, you would call the change password API here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password changed successfully'), // English localization
            backgroundColor: Colors.green,
          ),
        );
        // Clear password fields
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _showChangePassword = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'), // English localization
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all password fields'), // English localization
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'), // English localization
          content: Text('Are you sure you want to logout?'), // English localization
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'), // English localization
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final authController = Provider.of<AuthController>(context, listen: false);
                authController.logout();
                // Navigate to login screen
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: Text(
                'Logout', // English localization
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}