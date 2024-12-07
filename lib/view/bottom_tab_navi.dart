import 'package:flutter/material.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/view/media/player/media_player.dart';
import 'package:monotone_flutter/view/media/toolbar/media_toolbar.dart';
import 'package:monotone_flutter/view/discover/discover.dart';
import 'package:monotone_flutter/view/library/library.dart';
import 'package:monotone_flutter/view/home/home.dart';
import 'package:monotone_flutter/view/search/search.dart';
import 'package:monotone_flutter/view/profile/profile.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
// import 'package:monotone_flutter/components/component_views/playlist_card.dart';

class BottomTabNavigator extends StatefulWidget {
  const BottomTabNavigator({
    super.key,
  });

  @override
  _BottomTabNavigatorState createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _currentIndex = 0;
  // bool _isPlaying = false;
  bool _isMediaPlayerVisible = true;

  void _toggleMediaPlayer() {
    setState(() {});

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
      body: Column(
        children: [
          Expanded(child: _tabs[_currentIndex]),
          Container(
            // height: 65,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              // showSelectedLabels: false,
              // showUnselectedLabels: false,
              selectedItemColor: isDarkMode
                  ? const Color(0xFF898989)
                  : const Color(0xFF6E6E6E),
              unselectedItemColor: isDarkMode
                  ? const Color(0xFF898989)
                  : const Color(0xFF6E6E6E),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: ImageRenderer(
                    imageUrl: 'assets/image/home_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width *
                        0.04, // Adjust the width as needed
                  ),
                  activeIcon: ImageRenderer(
                    imageUrl: 'assets/image/home_active_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: ImageRenderer(
                    imageUrl: 'assets/image/discover_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  activeIcon: ImageRenderer(
                    imageUrl:
                        'assets/image/discover_active_icon.svg', ///// Discover has not received active icon yet
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width *
                        0.04, // Adjust the width as needed
                  ),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: ImageRenderer(
                    imageUrl: 'assets/image/search_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  activeIcon: ImageRenderer(
                    imageUrl: 'assets/image/search_active_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: ImageRenderer(
                    imageUrl: 'assets/image/library_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  activeIcon: ImageRenderer(
                    imageUrl: 'assets/image/library_active_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  label: 'Library',
                ),
                BottomNavigationBarItem(
                  icon: ImageRenderer(
                    imageUrl: 'assets/image/me_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  activeIcon: ImageRenderer(
                    imageUrl: 'assets/image/me_active_icon.svg',
                    height: MediaQuery.of(context).size.height *
                        0.04, // Adjust the height as needed
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  label: 'Me',
                ),
              ],
            ),
          ),
          if (_isMediaPlayerVisible)
            MediaToolbar(
                // onToggleMediaPlayer: _toggleMediaPlayer,
                ),
        ],
      ),
      // bottomNavigationBar:
    );
  }
}
