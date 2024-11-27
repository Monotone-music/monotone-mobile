import 'package:flutter/material.dart';
import 'package:monotone_flutter/common/themes/dark_mode.dart';
import 'package:monotone_flutter/common/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //init theme light mode
  ThemeData _themeData = darkMode;

  //get theme
  ThemeData get themeData => _themeData;

  //is dark mode
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  void setThemeData(ThemeData themeData) {
    _themeData = themeData;

    //update UI
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;

    //update UI
    notifyListeners();
  }

  //get theme color
  Color getThemeColorPrimary() {
    _themeData == darkMode
        ? darkMode.colorScheme.primary
        : lightMode.colorScheme.primary;
    print('Theme Data: $_themeData');
    return _themeData == darkMode
        ? darkMode.colorScheme.primary
        : lightMode.colorScheme.primary;
  }

  Color getThemeColorSurface() {
    _themeData == darkMode
        ? darkMode.colorScheme.surface
        : lightMode.colorScheme.surface;
    print('Theme Data: $_themeData');
    return _themeData == darkMode
        ? darkMode.colorScheme.surface
        : lightMode.colorScheme.surface;
  }
}
