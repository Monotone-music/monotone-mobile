import 'dart:math';

import 'package:flutter/material.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:monotone_flutter/auth/login/login_button.dart';
import 'package:monotone_flutter/auth/login/login_loader.dart';
import 'package:monotone_flutter/auth/login/register_button.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginLoader = LoginLoader();
  final _jwtInterceptor = DioClient(); // Create an instance of jwt_interceptor
  String _errorMessage = '';
  final _secureStorage = FlutterSecureStorage();
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

  ///
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

        ///
      } else if (result == 'Other') {
        setState(() {
          _errorMessage = 'There must be something wrong';
        });

        ///
      } else {
        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomTabNavigator()),
        );
      }
    }
  }

//TESTING FOR TOKEN
  // Future<void> _printTokens() async {
  //   final accessToken = await _jwtInterceptor.readAccessToken();
  //   final refreshToken = await _jwtInterceptor.readRefreshToken();
  //   print('Access Token: $accessToken');
  //   print('Refresh Token: $refreshToken');
  // }

  @override
  Widget build(BuildContext context) {
    // print(_selectedBackgroundImage);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    _selectedBackgroundImage), // Replace with your image path
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  changePrimary.withOpacity(0.8),
                  BlendMode.dstOut,
                ),
              ),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,

              //   colors: [
              //     Colors.black.withOpacity(0.5),
              //     Colors.transparent,
              //   ],
              // ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Monotone',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color:
                              Colors.white.withOpacity(0.5), // Change the color
                          fontSize: 22.0, // Change the font size
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color:
                              Colors.white.withOpacity(0.5), // Change the color
                          fontSize: 22.0, // Change the font size
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
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
                    ),
                    SizedBox(height: 32.0),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 16.0),
                    LoginButton(onPressed: () { _login();}),
                    SizedBox(height: 16.0),
                    RegisterButton(),
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
