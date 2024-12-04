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
  String initialRoute = '/login';
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  //Run

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  // final AudioHandler audioHandler;
  // MyApp({required this.audioHandler});
  @override
  State<MyApp> createState() => _MyAppState();
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
            routes: AppRoutes.getRoutes(), // Use the routes from routes.dart

            ///
          );
        },
      ),
    );
  }
}
