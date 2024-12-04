import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/view/register.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;

  RegisterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();
    final changeSurface = themeProvider.getThemeColorSurface();

    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Register'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 20),
        backgroundColor: changeSurface, // Background color
        foregroundColor: changePrimary, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        elevation: 4, // Elevation
      ),
    );
  }
}
