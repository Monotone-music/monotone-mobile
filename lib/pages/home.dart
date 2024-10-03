import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:monotone_flutter/components/tab_components/playlist_section.dart';
import 'package:monotone_flutter/components/component_views/search_bar_view.dart';
import 'package:monotone_flutter/components/logic_components/playlist_data_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final List<Item> _data = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expansion Panel List'),
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
        padding: const EdgeInsets.all(8.0),
        children: [
          // const Text('Hello World'),
          // const SizedBox(height: 16),
          _buildPanel(),
        ],
      ),
    );
  }

  bool _customTileExpanded = false;

  Widget _buildPanel() {
    return Column(
      children: <Widget>[
        const SearchBarView(),
        PlaylistSection(title: 'Playlists', fetchItems: DataService().fetchAnotherNotherPlaylistItems),
        PlaylistSection(title: 'New Playlist', fetchItems: DataService().fetchAnotherPlaylistItems),
        PlaylistSection(title: 'Neo Playlist', fetchItems: DataService().fetchPlaylistItems),
      ],
      
    );
  }

//
}
