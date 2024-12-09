import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final Widget child;
  const BottomTabNavigator({Key? key, required this.child}) : super(key: key);

  @override
  _BottomTabNavigatorState createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  // late AnimationController _controller;

  /// Add your routes here
  final List<String> _routes = [
    '/home',
    '/search',
    '/library',
    '/profile',
  ];

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    GoRouter.of(context).go(_routes[index]);
  }

  int _getCurrentIndex(String route) {
    return _routes.indexOf(route);
  }

  bool _isMediaPlayerVisible = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final currentRoute = GoRouter.of(context).location;
    _currentIndex = _getCurrentIndex(currentRoute);
    // Ensure _currentIndex is within the valid range
    if (_currentIndex < 0 || _currentIndex >= _routes.length) {
      _currentIndex = 0; // Default to the first tab
    }

    ///
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: widget.child,
          ),
          Container(
            // height: 65,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: onTabTapped,

              // showSelectedLabels: false,
              // showUnselectedLabels: false,
              selectedItemColor: isDarkMode
                  ? const Color(0xFF898989)
                  : const Color(0xFF6E6E6E),
              unselectedItemColor: isDarkMode
                  ? const Color(0xFF898989)
                  : const Color(0xFF6E6E6E),
              // onTap: (index) {
              //   setState(() {
              //     _currentIndex = index;
              //   });
              // },
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
