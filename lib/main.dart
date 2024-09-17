import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/tabs/bottom_tab_navi.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
//
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter test',
      debugShowCheckedModeBanner: false,
      home: BottomTabNavigator(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
