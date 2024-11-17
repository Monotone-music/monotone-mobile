import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/page_manager.dart';
import 'package:monotone_flutter/services/audio_handler.dart';
import 'package:monotone_flutter/services/media_components.dart';
import 'package:monotone_flutter/services/service_locator.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MediaPlayer extends StatelessWidget {
  const MediaPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final mediaPlayerProvider = Provider.of<MediaPlayerProvider>(context);
    getIt<PageManager>().init();
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<MyAudioHandler>(
      builder: (context, mediaPlayerProvider, child) {
        // final mediaUrl = mediaPlayerProvider.currentMediaUrl;
        return Scaffold(
            backgroundColor: isDarkMode
                ? const Color(0xFF333842)
                : const Color(0xFFAAB3C6), // Set the background color here
            appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(80.0), // Set the height of the AppBar
              child: AppBar(
                backgroundColor: isDarkMode
                    ? const Color(0xFF333842)
                    : const Color(0xFFAAB3C6),
                elevation: 0,
                toolbarHeight: 140.0,
                leading: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0), // Add padding above the icon
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF898989)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                title: const Padding(
                  padding:
                      EdgeInsets.only(top: 20.0), // Add padding above the text
                  child: Text(
                    'Now Playing',
                    style: TextStyle(color: Color(0xFFE0E0E0)),
                  ),
                ),
                centerTitle: true,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: PageView.builder(
                    controller: PageController(initialPage: 1),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _buildPlaylist(context);
                        case 1:
                          return _buildMainPlayer(context, mediaPlayerProvider);
                        case 2:
                          return _buildLyrics(context);
                        default:
                          return const SizedBox();
                      }
                    },
                  )
                      // ;}),
                      ),
                  const SizedBox(height: 20),
                  const AudioProgressBar(),
                  const AudioControlButtons(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.devices, color: Color(0xFF898989)),
                        onPressed: () {
                          // Implement change sound input functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.ios_share_rounded,
                            color: Color(0xFF898989)),
                        onPressed: () {
                          // Implement download media functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.queue_music,
                            color: Color(0xFF898989)),
                        onPressed: () {
                          // Implement queue functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.queue_outlined,
                            color: Color(0xFF898989)),
                        onPressed: () {
                          // Implement queue functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz_outlined,
                            color: Color(0xFF898989)),
                        onPressed: () {
                          // Implement share functionality
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildMainPlayer(
      BuildContext context, MyAudioHandler mediaPlayerProvider) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album Cover
          const SizedBox(
              width: 350,
              // height: 350,
              child: ImageRenderer(
                imageUrl: 'assets/image/album_1.png',
              )),
          const SizedBox(height: 10),
          // Song Title and Artist
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0), // Add padding to both sides
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Song TitleSong TitleSong Title', // Replace with actual song title
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFDBDBDB),
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Artist Name', // Replace with actual artist name
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF898989)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border,
                      color: Color(0xFF898989)),
                  onPressed: () {
                    // Implement favorite functionality
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.playlist_add, color: Color(0xFF898989)),
                  onPressed: () {
                    // Implement add to playlist functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylist(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            "Playlist",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const CurrentSongTitle(),
        const Playlist(),
        const AddRemoveSongButtons(),
        // StreamBuilder<bool>(
        //   stream: _audioHandler.playbackState
        //       .map((state) => state.shuffleMode == AudioServiceShuffleMode.all)
        //       .distinct(),
        //   builder: (context, snapshot) {
        //     final shuffleModeEnabled = snapshot.data ?? false;
        //     return IconButton(
        //       icon: shuffleModeEnabled
        //           ? const Icon(Icons.shuffle, color: Colors.orange)
        //           : const Icon(Icons.shuffle, color: Colors.grey),
        //       onPressed: () async {
        //         final enable = !shuffleModeEnabled;
        //         await _audioHandler.setShuffleMode(enable
        //             ? AudioServiceShuffleMode.all
        //             : AudioServiceShuffleMode.none);
        //       },
        //     );
        //   },
        // ),
        // SizedBox(
        //   height: 240.0,
        // child: StreamBuilder<QueueState>(
        //   stream: _audioHandler.queueState,
        //   builder: (context, snapshot) {
        //     final queueState = snapshot.data ?? QueueState.empty;
        //     final queue = queueState.queue;
        //     return ReorderableListView(
        //       onReorder: (int oldIndex, int newIndex) {
        //         if (oldIndex < newIndex) newIndex--;
        //         _audioHandler.moveQueueItem(oldIndex, newIndex);
        //       },
        //       children: [
        //         for (var i = 0; i < queue.length; i++)
        //           Dismissible(
        //             key: ValueKey(queue[i].id),
        //             background: Container(
        //               color: Colors.redAccent,
        //               alignment: Alignment.centerRight,
        //               child: const Padding(
        //                 padding: EdgeInsets.only(right: 8.0),
        //                 child: Icon(Icons.delete, color: Colors.white),
        //               ),
        //             ),
        //             onDismissed: (dismissDirection) {
        //               _audioHandler.removeQueueItemAt(i);
        //             },
        //             child: Material(
        //               color: i == queueState.queueIndex
        //                   ? Colors.grey.shade300
        //                   : null,
        //               child: ListTile(
        //                 title: Text(queue[i].title),
        //                 onTap: () => _audioHandler.skipToQueueItem(i),
        //               ),
        //             ),
        //           ),
        //       ],
        //     );
        //   },
        // ),
        // ),
      ],
    );
  }

  Widget _buildLyrics(BuildContext context) {
    return const Center(
      child: Text(
        'Lyrics', // Replace with actual lyrics content
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

// class ControlButtons extends StatelessWidget {
//   final MyAudioHandler audioHandler;

//   const ControlButtons(this.audioHandler, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.volume_up),
//           onPressed: () {
//             showSliderDialog(
//               context: context,
//               title: "Adjust volume",
//               divisions: 10,
//               min: 0.0,
//               max: 1.0,
//               value: audioHandler.volume.value,
//               stream: audioHandler.volume,
//               onChanged: audioHandler.setVolume,
//             );
//           },
//         ),
//         StreamBuilder<QueueState>(
//           stream: audioHandler.queueState,
//           builder: (context, snapshot) {
//             final queueState = snapshot.data ?? QueueState.empty;
//             return IconButton(
//               icon: const Icon(Icons.skip_previous),
//               onPressed:
//                   queueState.hasPrevious ? audioHandler.skipToPrevious : null,
//             );
//           },
//         ),
//         StreamBuilder<PlaybackState>(
//           stream: audioHandler.playbackState,
//           builder: (context, snapshot) {
//             final playbackState = snapshot.data;
//             final processingState = playbackState?.processingState;
//             final playing = playbackState?.playing;
//             if (processingState == AudioProcessingState.loading ||
//                 processingState == AudioProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: const CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: audioHandler.play,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: audioHandler.pause,
//               );
//             }
//           },
//         ),
//         StreamBuilder<QueueState>(
//           stream: audioHandler.queueState,
//           builder: (context, snapshot) {
//             final queueState = snapshot.data ?? QueueState.empty;
//             return IconButton(
//               icon: const Icon(Icons.skip_next),
//               onPressed: queueState.hasNext ? audioHandler.skipToNext : null,
//             );
//           },
//         ),
//         StreamBuilder<double>(
//           stream: audioHandler.speed,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               showSliderDialog(
//                 context: context,
//                 title: "Adjust speed",
//                 divisions: 10,
//                 min: 0.5,
//                 max: 1.5,
//                 value: audioHandler.speed.value,
//                 stream: audioHandler.speed,
//                 onChanged: audioHandler.setSpeed,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
