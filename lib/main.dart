import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
// import 'package:audio_service_example/common.dart';
import 'package:flutter/material.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:provider/provider.dart';

// import 'package:get/get.dart';
import 'package:monotone_flutter/widgets/routes/routes.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';

// Create a singleton instance of TrackHandler
// TrackHandler _trackHandler = TrackHandler();
// late AudioHandler audioHandler;
void main() async {
  String initialRoute = '/';
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51PR8baLcSoLMTRiQjjqFJopXNY76FOx5YuYfyrQ9WwK4iA32jyWvNXzNdesfHkfyJv4QKXEhceUjL7qltHnaaLxk00qdPpyN4O';

  await setupServiceLocator();
  //Run

  // final httpClient = InterceptedClient.build(interceptors: [
  //   JwtInterceptor(),
  // ]);
  // final alive = await httpClient.keepAlive();
  // print('alive response: ${alive?.data}');
  // if (alive?.data == 200) {
    initialRoute = '/login';
  // }

  ///
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  State<MyApp> createState() => _MyAppState();
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
          return  MaterialApp(
            title: 'Monotone',
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,
            initialRoute: widget.initialRoute,
            routes: AppRoutes.getRoutes(), // Use AppRoutes for routes
          );
        },
      ),
    );
  }
}
