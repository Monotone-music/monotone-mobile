import 'package:flutter/material.dart';
import 'package:monotone_flutter/auth/login/login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginNavigator extends StatelessWidget {
  const LoginNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // appBar: AppBar(
      //   title: Text('Home Page'),
      // ),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text('Go to Login Page'),
        ),
      ),
    );
  }
}
