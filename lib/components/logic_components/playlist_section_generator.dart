import 'package:flutter/material.dart';

import 'package:monotone_flutter/components/component_views/playlist_card_view.dart'; // Import the PlaylistListView widget
import 'package:monotone_flutter/components/models/playlist_items.dart'; // Import the PlaylistItem model

class PlaylistSectionGenerator extends StatefulWidget {
  @override
  State<PlaylistSectionGenerator> createState() => _PlaylistSectionGeneratorState();
}

class _PlaylistSectionGeneratorState extends State<PlaylistSectionGenerator> {
  Future<List<PlaylistItem>>? _playlistItemsFuture;

  @override
  void initState() {
    super.initState();
    _playlistItemsFuture = fetchPlaylistItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaylistItem>>(
      future: _playlistItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No playlists available'));
        } else {
          List<PlaylistItem> playlistItems = snapshot.data!;
          List<Widget> children = List.generate(playlistItems.length, (index) {
            PlaylistItem item = playlistItems[index];
            return PlaylistCard(
              playlistItem: item,
            );
          }).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: children,
            ),
          );
        }
      },
    );
  }
}

Future<List<PlaylistItem>> fetchPlaylistItems() async {
  // Simulate a delay for fetching data from the database
  await Future.delayed(Duration(seconds: 0));

  // Simulated data
  return [
    PlaylistItem(
      title: 'Song 1',
      artist: 'Artist 1',
      picture: 'assets/image/rajang.jpg',
      amount: '12',
    ),
    PlaylistItem(
      title: 'UrnaCacti',
      artist: 'Artist 333333',
      picture: 'assets/image/rajang.jpg',
      amount: '15',
    ),
    // Add more items as needed
  ];
}