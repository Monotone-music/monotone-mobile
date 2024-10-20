import 'package:flutter/material.dart';

import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:monotone_flutter/components/tab_components/playlist_section.dart';
import 'package:monotone_flutter/components/component_views/search_bar_view.dart';
import 'package:monotone_flutter/components/logic_components/playlist_data_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // final List<Item> _data = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // const Text('Hello World'),
          // const SizedBox(height: 16),
          const SearchBarView(placeholderText: 'Search Library',),
          _sortPanel(),
          _buildPanel(),
        ],
      ),
    );
  }

  bool _customTileExpanded = false;

  Widget _sortPanel() {
    return Column(children: [
      Row(
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.05), // Add vertical space
          SvgPicture.asset(
            'assets/image/group_icon.svg', // Replace with your SVG asset path
            height: MediaQuery.of(context).size.height *
                0.05, // Adjust the height as needed
            width: MediaQuery.of(context).size.height *
                0.05, // Adjust the width as needed
          ),
          const Text("Group"),
          SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          SvgPicture.asset(
            'assets/image/recent_icon.svg', // Replace with your SVG asset path
            height: MediaQuery.of(context).size.height *
                0.05, // Adjust the height as needed
            width: MediaQuery.of(context).size.height *
                0.05, // Adjust the width as needed
          ),
          const Text("Recent")
        ],
      )
    ]);
  }

  Widget _buildPanel() {
    return Column(
      children: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height *
                0.025), // Add vertical space
        PlaylistSection(
            title: 'Playlists', fetchItems: DataService().fetchPlaylistItems),
        // PlaylistSection(title: 'New Playlist', fetchItems: DataService().fetchAnotherPlaylistItems),
        // PlaylistSection(title: 'Neo Playlist', fetchItems: DataService().fetchPlaylistItems),
      ],
    );
  }

//
}
