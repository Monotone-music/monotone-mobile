import 'package:flutter/material.dart';
import 'playlist_mini.dart';

class PlaylistList extends StatelessWidget {
  final List<Map<String, String>> playlists;

  const PlaylistList({Key? key, required this.playlists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 0.0, // Spacing between columns
        mainAxisSpacing: 0.0, // Spacing between rows
        childAspectRatio: 2.3, // Aspect ratio of each item
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return PlaylistMini(
          title: playlist['title']!,
          artist: playlist['artist'],
          imageUrl: playlist['imageUrl']!,
        );
      },
    );
  }
}
