import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),

              ///
              SizedBox(
                height: height * 0.1,
              ),

              ///
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),

              ///
              SizedBox(
                height: height * 0.1,
              ),

              ///
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: _checkPasswordStrength,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              Text('Password Strength: $_passwordStrength'),

              ///
              SizedBox(
                height: height * 0.1,
              ),

              ///
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
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

              ///
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),

              ///
              // SizedBox(height: 40),
              // TextButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   child: Text('Login'),
              // ),
            ],

            ///
          ),
        ),

        ///
      ),
    );
  }
}
