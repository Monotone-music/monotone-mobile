import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:monotone_flutter/view/home/home.dart';
import 'package:monotone_flutter/view/library/library.dart';
import 'package:monotone_flutter/view/login.dart';
import 'package:monotone_flutter/view/payment/transaction_status.dart';
import 'package:monotone_flutter/view/profile/profile.dart';
import 'package:monotone_flutter/view/register.dart';
import 'package:monotone_flutter/view/search/search.dart';

class AppRoutes {
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String homePage = '/home';
  static const String searchPage = '/search';
  static const String libraryPage = '/library';
  static const String profilePage = '/profile';
  static final AppRoutes _instance = AppRoutes._internal();

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

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
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return BottomTabNavigator(
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
            ),
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryPage(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfilePage(),
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterPage(),
        ),
        GoRoute(
          path: '/transaction-status',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return TransactionStatusPage(
              subscriptionController: extra['subscriptionController'],
              amount: extra['amount'],
              currency: extra['currency'],
              membershipType: extra['membershipType'],
            );
          },
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
