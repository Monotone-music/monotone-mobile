import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/view/profile/profile.dart';

import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:monotone_flutter/widgets/routes/routes.dart';
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
    if (_formKey.currentState!.validate()) {
      // Perform login action
      final result = await _loginLoader.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (result == '400') {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      } else if (result == 'Other' || result == 'error') {
        setState(() {
          _errorMessage = 'There must be something wrong';
        });
      } else {
        GoRouter.of(context).go('/');
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

    return Scaffold(
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
              height: height * 0.6,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: changeSurface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    SizedBox(height: 40.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: changePrimary
                              .withOpacity(0.5), // Change the color
                          fontSize: 22.0, // Change the font size
                        ),
                        prefixIcon: Icon(Icons.person, color: changePrimary),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
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
                        border: OutlineInputBorder(),
                      ),
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    ///
                    SizedBox(height: 32.0),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    SizedBox(height: 16.0),
                    LoginButton(onPressed: () {
                      _login();
                    }),

                    ///
                    SizedBox(height: 30.0),
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
                                Navigator.pushNamed(
                                    context, AppRoutes.registerPage);
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
