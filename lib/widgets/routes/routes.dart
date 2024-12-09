import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:monotone_flutter/view/login.dart';
import 'package:monotone_flutter/view/profile/profile.dart';
import 'package:monotone_flutter/view/register.dart';

class AppRoutes {
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String homePage = '/home';
  static const String customerProfile = '/profile';
  static final AppRoutes _instance = AppRoutes._internal();

  late StreamSubscription<Uri> _sub;
  late AppLinks _appLinks;
  late GoRouter router;

  factory AppRoutes() {
    return _instance;
  }

  AppRoutes._internal() {
    _appLinks = AppLinks();
    _initDeepLinkListener();
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BottomTabNavigator(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) {
            return RegisterPage();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const BottomTabNavigator(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfilePage(),
        ),
      ],
    );
  }

  void _initDeepLinkListener() {
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      if (uri != null) {
        router.go(uri.path);
      }
    }, onError: (err) {
      print('Failed to handle deep link: $err');
    });
  }

  GoRouter getRoutes() {
    return router;
  }
}
