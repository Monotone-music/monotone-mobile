import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/components/component_views/media_player.dart';
import 'package:monotone_flutter/pages/discover.dart';
import 'package:monotone_flutter/pages/library.dart';
import 'package:monotone_flutter/pages/home.dart';
import 'package:monotone_flutter/pages/search.dart';
import 'package:monotone_flutter/pages/profile.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
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
    ProfilePage(),
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
        items: [
          BottomNavigationBarItem(
            icon:ImageRenderer(
              imageUrl: 'assets/image/home_icon.svg',
              height: MediaQuery.of(context).size.height *0.05, // Adjust the height as needed
              width: MediaQuery.of(context).size.width * 0.05, // Adjust the width as needed
            ),

            activeIcon:  ImageRenderer(
              imageUrl: 'assets/image/home_active_icon.svg',
            ),

            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon:  ImageRenderer(
              imageUrl: 'assets/image/discover_icon.svg',
              height: MediaQuery.of(context).size.height *0.05, // Adjust the height as needed
              width: MediaQuery.of(context).size.width * 0.05,
            ),

            activeIcon:  ImageRenderer(
              imageUrl: 'assets/image/discover_active_icon.svg',  ///// Discover has not received active icon yet
              height: MediaQuery.of(context).size.height *0.05, // Adjust the height as needed
              width: MediaQuery.of(context).size.width * 0.05, // Adjust the width as needed
            ),

            label: 'Discover',
          ),

          BottomNavigationBarItem(
            icon:  ImageRenderer(
              imageUrl: 'assets/image/search_icon.svg',
              height: MediaQuery.of(context).size.height *0.05, // Adjust the height as needed
              width: MediaQuery.of(context).size.width * 0.05,
            ),

            activeIcon:  ImageRenderer(
              imageUrl: 'assets/image/search_active_icon.svg',
            ),

            label: 'Search',
          ),

          BottomNavigationBarItem(
            icon:  ImageRenderer(
              imageUrl: 'assets/image/library_icon.svg',
              height: MediaQuery.of(context).size.height *0.05, // Adjust the height as needed
              width: MediaQuery.of(context).size.width * 0.05,
            ),

            activeIcon:  ImageRenderer(
              imageUrl: 'assets/image/library_active_icon.svg',
            ),

            label: 'Library',
          ),

          BottomNavigationBarItem(
            icon:  ImageRenderer(
              imageUrl: 'assets/image/me_icon.svg',
              height: MediaQuery.of(context).size.height *0.05, // Adjust the height as needed
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            
            activeIcon:  ImageRenderer(
              imageUrl: 'assets/image/me_active_icon.svg',
            ),

            label: 'Me',
          ),
        ],
      ),
    );
  }
}
