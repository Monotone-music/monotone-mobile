import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:provider/provider.dart';

class MediaToolbar extends StatelessWidget {
  final VoidCallback onToggleMediaPlayer;

  MediaToolbar({required this.onToggleMediaPlayer});

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaPlayerProvider>(
      builder: (context, mediaPlayerProvider, child) {
        final mediaUrl = mediaPlayerProvider.currentMediaUrl;
        return GestureDetector(
          onTap: onToggleMediaPlayer,
          child: Container(
            color: Colors.grey[900],
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Placeholder for media thumbnail
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[800],
                  child: Icon(Icons.music_note, color: Colors.white),
                ),
                SizedBox(width: 8.0),
                // Media information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mediaUrl != null ? 'Playing' : 'No media loaded',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        mediaUrl ?? '',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Playback controls
                IconButton(
                  icon: Icon(
                    mediaPlayerProvider.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (mediaPlayerProvider.isPlaying) {
                      mediaPlayerProvider.pause();
                    } else {
                      mediaPlayerProvider.play();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
