import 'package:flutter/material.dart';

import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:monotone_flutter/view/login.dart';
import 'package:monotone_flutter/view/register.dart';

class AppRoutes {
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String homePage = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      loginPage: (context) => LoginPage(),
      registerPage: (context) => RegisterPage(),
      homePage: (context) => const BottomTabNavigator(),
    };
  }
}
