import 'package:flutter/material.dart';

import 'package:monotone_flutter/view/register.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(),
        ),

        ///
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },

          ///
          child: Text(
            'Register',
            style: TextStyle(),
          ),
        ),

        ///
      ],
    );

    ///
  }
}
