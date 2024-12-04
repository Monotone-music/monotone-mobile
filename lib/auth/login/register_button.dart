import 'package:flutter/material.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';

import 'package:monotone_flutter/view/register.dart';
import 'package:provider/provider.dart';

class RegisterButton extends StatelessWidget {
  RegisterButton();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();
    final changeSurface = themeProvider.getThemeColorSurface();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 15, color: changePrimary.withOpacity(0.5)),
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
            style: TextStyle(
              color: changePrimary,
            ),
          ),
        ),

        ///
      ],
    );

    ///
  }
}
