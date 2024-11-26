import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:monotone_flutter/auth/login/login_button.dart';
import 'package:monotone_flutter/auth/login/login_loader.dart';
import 'package:monotone_flutter/auth/login/register_button.dart';
import 'package:monotone_flutter/pages/home.dart';

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

      if (result == 'Invalid username or password' ||
          result == 'Failed to load data') {
        setState(() {
          _errorMessage = result;
        });
      } else {
        // Assuming the result contains the token or success message
        // Save login status
        final secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: 'isLoggedIn', value: 'true');
        print('hisda');
        print(secureStorage);

        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              border: OutlineInputBorder(),
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
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
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
          LoginButton(onPressed: _login),
          SizedBox(height: 16.0),
          RegisterButton(),
        ],
      ),
    );
  }
}
