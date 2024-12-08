import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/view/login.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  LogoutButton({required this.onPressed});
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();
    final changeSurface = themeProvider.getThemeColorSurface();

    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Sign Out'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 20),
        backgroundColor: changeSurface, // Background color
        foregroundColor: changePrimary, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          side: BorderSide(
              color: changePrimary.withOpacity(0.4),
              width: 2), // Border color and width
        ),
        elevation: 0, // Elevation
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    Navigator.pushReplacementNamed(context, '/login');

    ///
    await secureStorage
        .deleteAll(); // This will delete all tokens and other stored data
    // await secureStorage.write(key: 'isLoggedIn', value: 'false');
  }
}
