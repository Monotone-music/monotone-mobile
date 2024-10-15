import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:provider/provider.dart';

class MediaPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MediaPlayerProvider>(
      builder: (context, mediaPlayerProvider, child) {
        final mediaUrl = mediaPlayerProvider.currentMediaUrl;
        return Scaffold(
          backgroundColor: Colors.black, // Set the background color here
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Now Playing',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the song URL
                Text(
                  mediaUrl ?? 'No media loaded',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 20),
                // Progress Bar
                Slider(
                  value: mediaPlayerProvider.position.inSeconds.toDouble(),
                  max: mediaPlayerProvider.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    mediaPlayerProvider.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mediaPlayerProvider.position.toString().split('.').first,
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      mediaPlayerProvider.duration.toString().split('.').first,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous,
                          color: Colors.white, size: 36),
                      onPressed: () {
                        // Implement skip previous functionality
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        mediaPlayerProvider.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 64,
                      ),
                      onPressed: () {
                        if (mediaPlayerProvider.isPlaying) {
                          mediaPlayerProvider.pause();
                        } else {
                          mediaPlayerProvider.play();
                        }
                      },
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.skip_next, color: Colors.white, size: 36),
                      onPressed: () {
                        // Implement skip next functionality
                      },
                    ),
                  ],
                ),
                Spacer(),
                // Close Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
