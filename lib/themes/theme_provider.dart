import 'package:flutter/material.dart';
import 'package:monotone_flutter/themes/dark_mode.dart';
import 'package:monotone_flutter/themes/light_mode.dart';

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
}
