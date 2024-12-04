import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/main.dart';
import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'package:monotone_flutter/auth/login/login_button.dart';
import 'package:monotone_flutter/auth/login/login_loader.dart';
import 'package:monotone_flutter/auth/login/logout_button.dart';
import 'package:monotone_flutter/auth/login/register_button.dart';
import 'package:monotone_flutter/view/home/home.dart';

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

  @override
  void initState() {
    super.initState();
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
        GoRouter.of(context).go('/home');
        context.go('/home');
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Monotone',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          ///
          SizedBox(height: 32.0),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(
                color: changePrimary.withOpacity(0.5), // Change the color
                fontSize: 22.0, // Change the font size
                // fontWeight: FontWeight.bold, // Change the font weight
              ),
              // border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),

          ///
          SizedBox(height: 30.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: changePrimary.withOpacity(0.5), // Change the color
                fontSize: 22.0, // Change the font size
                // fontWeight: FontWeight.bold, // Change the font weight
              ),
              // border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
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
          SizedBox(height: 32.0),

          ///
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),

          ///
          LoginButton(onPressed: () {
            _login();
          }),
          SizedBox(height: 16.0),

          ///
          RegisterButton(),
        ],
      ),
    );
  }
}
