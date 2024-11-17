import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:monotone_flutter/page_manager.dart';
import 'package:monotone_flutter/services/audio_handler.dart';
import 'package:monotone_flutter/services/media_components.dart';
import 'package:monotone_flutter/services/service_locator.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class MediaToolbar extends StatelessWidget {
  final VoidCallback onToggleMediaPlayer;
  // final MyAudioHandler audioPlayerHandler;

  MediaToolbar({
    required this.onToggleMediaPlayer,
    //  required this.audioPlayerHandler
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    getIt<PageManager>().init();
    return Consumer<MyAudioHandler>(
      builder: (context, mediaPlayerProvider, child) {
        // final mediaUrl = mediaPlayerProvider.currentMediaUrl;
        return GestureDetector(
          onTap: onToggleMediaPlayer,
          child: Container(
            color:
                isDarkMode ? const Color(0xFF333842) : const Color(0xFFAAB3C6),
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
                        // mediaUrl != null ? 'Now Playing' : 'No media loaded',
                        'Now Playing',
                        style: TextStyle(
                            color: isDarkMode
                                ? const Color(0xFFDBDBDB)
                                : const Color(0xFF1A1A1A),
                            fontSize: 16),
                      ),
                      Text(
                        // mediaUrl ?? '',
                        'Song Name',
                        style: TextStyle(
                            color: isDarkMode
                                ? const Color(0xFF898989)
                                : const Color(0xFF6E6E6E),
                            fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Playback controls
                // StreamBuilder<PlaybackState>(
                //   stream: audioPlayerHandler.playbackState,
                //   builder: (context, snapshot) {
                //     final playbackState = snapshot.data;
                //     final processingState = playbackState?.processingState;
                //     final playing = playbackState?.playing;
                //     if (processingState == AudioProcessingState.loading ||
                //         processingState == AudioProcessingState.buffering) {
                //       return Container(
                //         margin: const EdgeInsets.all(8.0),
                //         width: 24.0,
                //         height: 24.0,
                //         child: const CircularProgressIndicator(),
                //       );
                //     } else if (playing != true) {
                //       return IconButton(
                //         icon: const Icon(Icons.play_arrow),
                //         iconSize: 24.0,
                //         onPressed: audioPlayerHandler.play,
                //       );
                //     } else {
                //       return IconButton(
                //         icon: const Icon(Icons.pause),
                //         iconSize: 24.0,
                //         onPressed: audioPlayerHandler.pause,
                //       );
                //     }
                //   },
                // ),

                const PlayButton(),

                // IconButton(
                //   icon: Icon(
                //     mediaPlayerProvider.isPlaying
                //         ? Icons.pause
                //         : Icons.play_arrow,
                //     color: isDarkMode
                //         ? const Color(0xFFDBDBDB)
                //         : const Color(0xFF6E6E6E),
                //   ),
                //   onPressed: () {
                //     if (mediaPlayerProvider.isPlaying) {
                //       mediaPlayerProvider.pause();
                //     } else {
                //       mediaPlayerProvider.play();
                //     }
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
