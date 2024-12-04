import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/view/login.dart';
import 'package:provider/provider.dart';

// Create a singleton instance of TrackHandler
// TrackHandler _trackHandler = TrackHandler();
// late AudioHandler audioHandler;
void main() async {
  String initialRoute = '/login';
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  //Run

  final client = DioClient();
  final alive = await client.keepAlive();
  if (alive?.data == 200) {
    initialRoute = '/home';
  }

  ///
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  // final AudioHandler audioHandler;
  // MyApp({required this.audioHandler});
  @override
  State<MyApp> createState() => _MyAppState();

  // Define your named routes
  static const String loginPage = '/login';
  static const String homePage = '/home';
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<Uri> _sub;
  late AppLinks _appLinks;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    getIt<MediaManager>().init();
    _appLinks = AppLinks();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      if (uri != null) {
        _router.go(uri.path);
      }
    }, onError: (err) {
      print('Failed to handle deep link: $err');
    });
  }

  @override
  void dispose() {
    getIt<MediaManager>().dispose();
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _router = GoRouter(
      // initialLocation: widget.initialRoute,
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (context, state) {
            return LoginPage();
          },
        ),
        GoRoute(
          path: '/',
          builder: (context, state) {
            return BottomTabNavigator();
          },
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAudioHandler(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Monotone',
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,
            routerConfig: _router,

            ///
          );
        },
      ),
    );
  }
}
