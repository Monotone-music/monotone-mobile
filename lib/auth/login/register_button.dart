import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigate to the registration page
      },
      child: Text('Don\'t have an account? Register'),
    );
  }
}
