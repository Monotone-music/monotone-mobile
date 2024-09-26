import 'package:flutter/material.dart';
import 'package:monotone_flutter/pages/discover.dart';
import 'package:monotone_flutter/pages/home.dart';
import 'package:monotone_flutter/pages/library.dart';
import 'package:monotone_flutter/components/component_views/playlist_card_view.dart';

class BottomTabNavigator extends StatefulWidget {
  @override
  _BottomTabNavigatorState createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    // Add your tab screens here
    HomeScreen(),
    DiscoverPage(),
    LibraryPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          // Add your bottom navigation items here
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Library'),
        ],
      ),
    );
  }
}
