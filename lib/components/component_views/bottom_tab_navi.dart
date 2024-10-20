import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/component_views/media_player.dart';
import 'package:monotone_flutter/components/component_views/media_toolbar.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
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
  bool _isMediaPlayerVisible = true;

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<MediaPlayerProvider>(context, listen: false).fetchMedia();
  // }

  void _toggleMediaPlayer() {
    setState(() {
      // _isMediaPlayerVisible = !_isMediaPlayerVisible;

      // if (_isMediaPlayerVisible) {
    });

    if (_isMediaPlayerVisible) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => MediaPlayer(),
      ).then((_) {
        setState(() {
          // _isMediaPlayerVisible = !_isMediaPlayerVisible;
        });
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleDisplay() {
    setState(() {
      _isMediaPlayerVisible = !_isMediaPlayerVisible;
    });
  }

  final List<Widget> _tabs = [
    // Add your tab screens here
    HomePage(),
    DiscoverPage(),
    SearchPage(),
    LibraryPage(),
    // ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _tabs[_currentIndex]),
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
          if (_isMediaPlayerVisible)
            MediaToolbar(
              onToggleMediaPlayer: _toggleMediaPlayer,
            ),
        ],
      ),
    );
  }
}
