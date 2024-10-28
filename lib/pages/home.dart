import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:monotone_flutter/components/tab_components/playlist_list.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Map<String, String>> playlists = [
    {
      'title': 'Get Lucky',
      'artist': 'Daft Punk',
      'imageUrl': 'assets/image/album_1.png',
      'songUrl': 'https://api.ibarakoi.online/tracks/get',
    },
    {
      'title': 'Daily Mix',
      'imageUrl': 'assets/image/album_1.png',
      'songUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'title': 'Daily Mix',
      'imageUrl': 'assets/image/album_1.png',
      'songUrl': 'https://api.ibarakoi.online/tracks/get',
    },
    {
      'title': 'Daily Mix',
      'imageUrl': 'assets/image/album_1.png',
      'songUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    // Add more playlists here
    {
      'title': 'Get Lucky',
      'artist': 'Daft Punk',
      'imageUrl': 'assets/image/album_1.png',
      'songUrl': 'https://api.ibarakoi.online/tracks/get',
    },
    {
      'title': 'Get Lucky',
      'artist': 'Daft Punk',
      'imageUrl': 'assets/image/album_1.png',
      'songUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    PlaylistList(playlists: playlists),
    Center(
      child: Text(
        'Podcasts',
        style: TextStyle(fontSize: 24),
      ),
    ),
    Center(
      child: Text(
        'Audiobooks',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 36.0, left: 8.0, right: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    categoryButton("Music", 0),
                    categoryButton("Podcasts", 1),
                    categoryButton("Audiobooks", 2),
                  ],
                ),
                Container(
                  child: SvgPicture.asset(
                    'assets/image/home_filter.svg',
                    semanticsLabel: 'My SVG Image',

                    // fit: BoxFit.scaleDown,
                    color: isDarkMode
                        ? const Color(0xFF898989)
                        : const Color(0xFF6E6E6E),

                    width: 50, //set your width and height
                    height: 50,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryButton(String title, int index) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF202020) : const Color(0xFFE4E4E4),

        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: const Color.fromARGB(255, 0, 0, 0),
        //   width: 1,
        // ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(),
        onPressed: () => _onButtonPressed(index),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w400)),
      ),
    );
  }
}
