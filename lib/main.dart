import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/component_views/bottom_tab_navi.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MediaPlayerProvider(),
      builder: (context, child) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, child) {
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
