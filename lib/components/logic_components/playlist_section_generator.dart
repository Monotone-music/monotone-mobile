import 'package:flutter/material.dart';

import 'package:monotone_flutter/components/component_views/playlist_card_view.dart'; // Import the PlaylistListView widget
import 'package:monotone_flutter/components/models/playlist_items.dart'; // Import the PlaylistItem model

class PlaylistSectionGenerator extends StatefulWidget {
  final Future<List<PlaylistItem>> Function() fetchItems; // Function to fetch items
  const PlaylistSectionGenerator({required this.fetchItems, super.key}); 

  @override
  State<PlaylistSectionGenerator> createState() => _PlaylistSectionGeneratorState();
}

class _PlaylistSectionGeneratorState extends State<PlaylistSectionGenerator> {
  Future<List<PlaylistItem>>? _playlistItemsFuture;

  @override
  void initState() {
    super.initState();
    _playlistItemsFuture = widget.fetchItems(); // Fetch items in initState
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
          return Center(child: Text('No items found'));
        } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add space between items
                    child: SizedBox(
                  //     height: MediaQuery.of(context).size.width * 1, // Set a specific height
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width * 0.39,
                        child: PlaylistCard(playlistItem: item), // Use PlaylistCard to display the item
                      ),
                  //   ),
                  );
                }).toList(),
              ),
            );
          }
        }
      );
    }
  }