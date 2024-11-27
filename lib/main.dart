import 'package:flutter/material.dart';
import 'package:monotone_flutter/view/bottom_tab_navi.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:provider/provider.dart';

// Create a singleton instance of TrackHandler
// TrackHandler _trackHandler = TrackHandler();
// late AudioHandler audioHandler;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
            home: BottomTabNavigator(),
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,
          );
        },
      ),
    );
  }
}
