import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/common/themes/theme_provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _passwordStrength = '';
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  final List<String> _backgroundImages = [
    'assets/image/backgrounds/log_page_background.jpg',
    'assets/image/backgrounds/log_page_background2.jpg',
    'assets/image/backgrounds/log_page_background3.jpg',
    'assets/image/backgrounds/log_page_background4.jpg',
    'assets/image/backgrounds/log_page_background5.jpg',
    'assets/image/backgrounds/log_page_background6.jpg',
    'assets/image/backgrounds/log_page_background7.jpg',
  ];

  late String _selectedBackgroundImage;

  void _checkPasswordStrength(String password) {
    if (password.length < 6) {
      setState(() {
        _passwordStrength = 'Weak';
      });
    } else if (password.length < 10) {
      setState(() {
        _passwordStrength = 'Medium';
      });
    } else {
      setState(() {
        _passwordStrength = 'Strong';
      });
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Perform registration logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // _registerLoader = RegisterLoader(); // Initialize RegisterLoader in initState
    _selectedBackgroundImage =
        _backgroundImages[Random().nextInt(_backgroundImages.length)];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();
    final changeSurface = themeProvider.getThemeColorSurface();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height*1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    _selectedBackgroundImage), // Use the selected random image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  changePrimary.withOpacity(0.8),
                  BlendMode.dstOut,
                ),
              ),
              // // gradient: LinearGradient(
              // //   begin: Alignment.topCenter,
              // //   end: Alignment.bottomCenter,
              // //   colors: [
              // //     Colors.black.withOpacity(0.5),
              // //     Colors.transparent,
              // //   ],
              // ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',  
                      labelStyle: TextStyle(
                        color:
                            changePrimary.withOpacity(0.5), // Change the color
                        fontSize: 22.0, // Change the font size
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.1),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color:
                            changePrimary.withOpacity(0.5), // Change the color
                        fontSize: 22.0, // Change the font size
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.1),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color:
                            changePrimary.withOpacity(0.5), // Change the color
                        fontSize: 22.0, // Change the font size
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Text('Password Strength: $_passwordStrength'),
                  SizedBox(height: height * 0.1),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      labelStyle: TextStyle(
                        color:
                            changePrimary.withOpacity(0.5), // Change the color
                        fontSize: 22.0, // Change the font size
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmText = !_obscureConfirmText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureConfirmText,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 20),
                      backgroundColor: changeSurface, // Background color
                      foregroundColor: changePrimary, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      elevation: 4, // Elevation
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
