import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/component_views/media_toolbar.dart';
import 'package:monotone_flutter/pages/discover.dart';
import 'package:monotone_flutter/pages/library.dart';
import 'package:monotone_flutter/pages/home.dart';
import 'package:monotone_flutter/pages/search.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';
// import 'package:monotone_flutter/components/component_views/playlist_card.dart';

class BottomTabNavigator extends StatefulWidget {
  @override
  _BottomTabNavigatorState createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isDisplaying = false;

  static const List<Map<String, String>> playlists = [
    {
      'title': 'Get Lucky',
      'artist': 'Daft Punk',
      'imageUrl': 'assets/image/album_1.png',
    },
    // Add more playlists as needed
  ];

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleDisplay() {
    setState(() {
      _isDisplaying = !_isDisplaying;
    });
  }

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
      body: Column(
        children: [
          Expanded(child: _tabs[_currentIndex]),
          if (_isDisplaying)
            MediaToolbar(
              title: playlists[0]['title']!, // Replace with actual song title
              artist: playlists[0]
                  ['artist']!, // Replace with actual artist name
              imageUrl: playlists[0]
                  ['imageUrl']!, // Replace with actual image path
              isPlaying: _isPlaying,
              onPlayPause: _togglePlayPause,
              onClose: _toggleDisplay,
            ),
          BottomNavigationBar(
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star), label: 'Discover'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_music), label: 'Library'),
            ],
          ),
        ],
      ),
    );
  }
}
