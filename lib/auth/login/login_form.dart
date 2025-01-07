import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/auth/login/login_button.dart';
import 'package:monotone_flutter/auth/login/services/login_loader.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginLoader = LoginLoader();
  String _errorMessage = '';
  bool _obscureText = true;

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
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.length > 25) {
      Fluttertoast.showToast(
        msg: 'Exceed max username length of 25',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        fontSize: 18,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Perform login action
      final result = await _loginLoader.login(
        _usernameController.text,
        _passwordController.text,
      );
      if (!mounted) return; // Check if the widget is still mounted

      if (result == '200') {
      Fluttertoast.showToast(
        msg: 'Login successfully',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        fontSize: 18,
        gravity: ToastGravity.BOTTOM,
      );
      // Use GoRouter for navigation
      GoRouter.of(context).go('/home');
    } else if (result == '400') {
      Fluttertoast.showToast(
        msg: 'Invalid username or password',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        fontSize: 18,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (result == '401' || result == '404') {
      Fluttertoast.showToast(
        msg: 'Your account does not exist or unauthorized',
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

      ///
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();
    final changeSurface = themeProvider.getThemeColorSurface();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: height * 1,
            width: width * 1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    _selectedBackgroundImage), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: width * 0.8,
              height: height * 0.5,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: changeSurface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // SizedBox(height: 40.0),
                    Text(
                      'Monotone',
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
                              fontSize: 22.0, // Change the font size
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
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: changePrimary
                                  .withOpacity(0.5), // Change the color
                              fontSize: 22.0, // Change the font size
                            ),
                            prefixIcon: Icon(Icons.lock, color: changePrimary),
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
                      ],
                    ),

                    ///
                    // SizedBox(height: 32.0),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    const SizedBox(height: 16.0),
                    LoginButton(onPressed: () {
                      _login();
                    }),

                    ///
                    // SizedBox(height: 30.0),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: changePrimary,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: changePrimary,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _errorMessage = ''; // Clear the error message
                                });
                                GoRouter.of(context).push('/register');
                              },
                          ),
                        ],
                      ),
                    ),

                    ///
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
