import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:monotone_flutter/auth/login/register_button.dart';
import 'package:monotone_flutter/auth/login/services/register_loader.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _registerLoader = RegisterLoader();
  String _errorMessage = '';
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

  @override
  void initState() {
    super.initState();
    _selectedBackgroundImage =
        _backgroundImages[Random().nextInt(_backgroundImages.length)];
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_usernameController.text.length > 25) {
      Fluttertoast.showToast(
        msg: 'Exceed max username length of 25',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    if (_displayNameController.text.length > 25) {
      Fluttertoast.showToast(
        msg: 'Exceed max display name length of 25',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Perform registration action
      final result = await _registerLoader.register(
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
        _displayNameController.text,
      );

      if (result == '201') {
        Fluttertoast.showToast(
          msg: 'Register successfully, please check your email',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
        );
        // Navigate to login page
        GoRouter.of(context).push('/login');
      } else if (result == '401') {
        Fluttertoast.showToast(
          msg: 'The account already exists',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (result == 'Invalid email') {
        Fluttertoast.showToast(
          msg: 'Invalid email format',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (result == '400') {
        Fluttertoast.showToast(
          msg: 'Account already exist',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (result == 'Network error') {
        Fluttertoast.showToast(
          msg: 'A network error wrong',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'An unknown error occurred',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();
    final changeSurface = themeProvider.getThemeColorSurface();
    var subTextSize = 16.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: width * 1,
            height: height * 1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    _selectedBackgroundImage), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: width * 0.8,
                height: height * 0.8,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: changeSurface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: changePrimary,
                        ),
                      ),
                      // SizedBox(height: 40.0),
                      Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                color: changePrimary
                                    .withOpacity(0.5), // Change the color
                                fontSize: subTextSize, // Change the font size
                              ),
                              prefixIcon:
                                  Icon(Icons.person, color: changePrimary),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _displayNameController,
                            decoration: InputDecoration(
                              labelText: 'Display Name',
                              labelStyle: TextStyle(
                                color: changePrimary
                                    .withOpacity(0.5), // Change the color
                                fontSize: subTextSize, // Change the font size
                              ),
                              prefixIcon:
                                  Icon(Icons.person, color: changePrimary),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your display name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: changePrimary
                                    .withOpacity(0.5), // Change the color
                                fontSize: subTextSize, // Change the font size
                              ),
                              prefixIcon:
                                  Icon(Icons.email, color: changePrimary),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: changePrimary
                                    .withOpacity(0.5), // Change the color
                                fontSize: subTextSize, // Change the font size
                              ),
                              prefixIcon:
                                  Icon(Icons.lock, color: changePrimary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: changePrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(
                                color: changePrimary
                                    .withOpacity(0.5), // Change the color
                                fontSize: subTextSize, // Change the font size
                              ),
                              prefixIcon:
                                  Icon(Icons.lock, color: changePrimary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: changePrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmText = !_obscureConfirmText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: _obscureConfirmText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      // SizedBox(height: 32.0),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      // SizedBox(height: 16.0),
                      RegisterButton(onPressed: () {
                        _register();
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
