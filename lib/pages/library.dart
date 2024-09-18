import 'package:flutter/material.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/components/playlist_card.dart';

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
        padding: const EdgeInsets.all(16.0),
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
    return const Column(
      children: <Widget>[
        PlaylistCard(),
      ],
    );
  }

//
}
