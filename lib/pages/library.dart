import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monotone_flutter/components/tab_components/library_list.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    SingleChildScrollView(
      // scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          PlaylistMini(),
        ],
      ),
    ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
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
                alignment: Alignment.center, // <---- The magic
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/image/home_filter.svg',
                  semanticsLabel: 'My SVG Image',

                  // fit: BoxFit.scaleDown,
                  color: const Color(0xFF898989),

                  width: 50, //set your width and height
                  height: 50,
                ),
              )
            ],
          ),
          Expanded(
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
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
