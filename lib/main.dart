<<<<<<< HEAD
import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
// import 'package:audio_service_example/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monotone_flutter/auth/login/login_form.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:provider/provider.dart';

// import 'package:get/get.dart';
import 'package:monotone_flutter/components/component_views/bottom_tab_navi.dart';
import 'package:monotone_flutter/page_manager.dart';
import 'package:monotone_flutter/pages/login.dart';
import 'package:monotone_flutter/services/audio_handler.dart';
import 'package:monotone_flutter/services/service_locator.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:permission_handler/permission_handler.dart';
=======
import 'package:flutter/material.dart';
import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:provider/provider.dart';
>>>>>>> b8a440a0254d7685d91fd071b3ae95344959b59a

// Create a singleton instance of TrackHandler
// TrackHandler _trackHandler = TrackHandler();
// late AudioHandler audioHandler;
void main() async {
  String initialRoute='/login';
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  //Run

  final client = DioClient();
  final alive =await client.keepAlive();
  if(alive?.data == 200){
    initialRoute = '/home';
  }
  ///
  runApp(MyApp(initialRoute:initialRoute));
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
  @override
  void initState() {
    super.initState();
    getIt<MediaManager>().init();
  }

  @override
  void dispose() {
    getIt<MediaManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.initialRoute);
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
          return MaterialApp(
              title: 'Monotone',
              // home: LoginPage(),
              debugShowCheckedModeBanner: false,
              theme: Provider.of<ThemeProvider>(context).themeData,
              //ROUTES
              initialRoute: widget.initialRoute,
              routes: {
                MyApp.loginPage: (context) => LoginPage(),
                MyApp.homePage: (context) => const BottomTabNavigator(),
              }

              ///
              );
        },
      ),
    );
  }
}
