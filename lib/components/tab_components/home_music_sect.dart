import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/tab_components/home_playlist.dart';
import 'package:monotone_flutter/services/audio_handler.dart';
import 'package:monotone_flutter/services/media_components.dart';
import 'package:monotone_flutter/services/service_locator.dart';

class PlaylistList extends StatelessWidget {
  final List<Map<String, String>> trackItems;

  const PlaylistList({super.key, required this.trackItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        gridPlaylistMini(),
        SizedBox(height: 10), // Add some spacing between the widgets
        M4UPlaylist(),
        // ChunkAudioControl(),
      ],
    );
  }

  Widget gridPlaylistMini() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trackItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 0.0, // Spacing between columns
        mainAxisSpacing: 0.0, // Spacing between rows
        childAspectRatio: 2.3, // Aspect ratio of each item
      ),
      itemBuilder: (context, index) {
        return PlaylistMini(trackItem: trackItems[index]);
      },
    );
  }

  Widget M4UPlaylist() {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Container(
        constraints: const BoxConstraints(
            maxWidth: 200), // Define a fixed width for the Container
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300, // Define a fixed width for the AutoScrollText
              height: 24, // Define a fixed height for the AutoScrollText
              child: AutoScrollText(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                style: TextStyle(fontSize: 16), // Adjust font size as needed
                scrollDirection:
                    Axis.horizontal, // Change to horizontal scrolling
                mode: AutoScrollTextMode.bouncing,
                // delayBefore: Duration(milliseconds: 3000),
                velocity: Velocity(
                    pixelsPerSecond:
                        Offset(20, 0)), // Adjust the scrolling speed
                delayBefore: Duration(seconds: 1),
                pauseBetween: Duration(seconds: 1),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // Handle tap
      },
    );
  }
}
