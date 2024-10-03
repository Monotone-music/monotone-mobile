import 'package:flutter/material.dart';
import 'package:monotone_flutter/pages/discover.dart';
import 'package:monotone_flutter/pages/library.dart';
import 'package:monotone_flutter/pages/home.dart';
import 'package:monotone_flutter/pages/search.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class BottomTabNavigator extends StatefulWidget {
  @override
  _BottomTabNavigatorState createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    // Add your tab screens here
    HomePage(),
    DiscoverPage(),
    SearchPage(),
    LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor:
            isDarkMode ? const Color(0xFF898989) : const Color(0xFF6E6E6E),
        unselectedItemColor:
            isDarkMode ? const Color(0xFF898989) : const Color(0xFF6E6E6E),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          // Add your bottom navigation items here
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Library'),
        ],
      ),
    );
  }
}
