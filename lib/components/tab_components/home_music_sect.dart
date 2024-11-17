import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:monotone_flutter/components/models/track_item.dart';
import 'package:monotone_flutter/components/tab_components/home_playlist.dart';
import 'package:provider/provider.dart';
// import 'playlist_mini.dart';

class PlaylistList extends StatelessWidget {
  // final List<Map<String, String>> playlists;

  final List<Map<String, String>> trackItems;

  const PlaylistList({super.key, required this.trackItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gridPlaylistMini(),
        SizedBox(height: 10), // Add some spacing between the widgets
        M4UPlaylist(),
      ],
    );
  }

  Widget gridPlaylistMini() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 0.0, // Spacing between columns
        mainAxisSpacing: 0.0, // Spacing between rows
        childAspectRatio: 2.3, // Aspect ratio of each item
      ),
      itemCount: trackItems.length,
      itemBuilder: (context, index) {
        final trackItem = trackItems[index];
        return PlaylistMini(
            trackItem: trackItem); // Use PlaylistMini to display the items
      },
    );
  }

  Widget M4UPlaylist() {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: const Text(
        'Made For You',
        style: TextStyle(fontSize: 24.0),
      ),
      // subtitle: const Text('M4U'),
      trailing: const Icon(Icons.more_horiz_outlined),
      onTap: () {
        print('M4U Playlist');
      },
    );
  }
}
