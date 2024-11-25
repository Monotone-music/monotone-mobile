import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
// import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
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

  // Stream<Duration> get _bufferedPositionStream => _audioHandler.playbackState
  //     .map((state) => state.bufferedPosition)
  //     .distinct();
  // Stream<Duration?> get _durationStream =>
  //     _audioHandler.mediaItem.map((item) => item?.duration).distinct();
  // Stream<PositionData> get _positionDataStream =>
  //     Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //         AudioService.position,
  //         _bufferedPositionStream,
  //         _durationStream,
  //         (position, bufferedPosition, duration) => PositionData(
  //             position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final pageManager = getIt<PageManager>();
    return Consumer<MyAudioHandler>(
      builder: (context, mediaPlayerProvider, child) {
        return ValueListenableBuilder(
            valueListenable: pageManager.currentSongTitleNotifier,
            builder: (context, currentSongTitle, child) {
              final currentMediaItem = pageManager.currentMediaItem;
              final imageUrl = currentMediaItem?.artUri?.toString() ??
                  'assets/image/not_available.png';
              final title = currentMediaItem?.title ?? 'Unknown Title';
              final artistName = currentMediaItem?.artist ?? 'Unknown Artist';
              final albumName = currentMediaItem?.album ?? 'Unknown Album';
              return Scaffold(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF333842)
                      : const Color(
                          0xFFAAB3C6), // Set the background color here
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(
                        80.0), // Set the height of the AppBar
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
                      title: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0), // Add padding above the text
                        child: Column(
                          children: [
                            const Text(
                              'Now Playing',
                              style: TextStyle(color: Color(0xFFE0E0E0)),
                            ),
                            Text(
                              albumName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                return _buildMainPlayer(
                                    context,
                                    mediaPlayerProvider,
                                    imageUrl,
                                    title,
                                    artistName);
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: AudioProgressBar(),
                        ),
                        const AudioControlButtons(),
                        const SizedBox(height: 20),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     IconButton(
                        //       icon: const Icon(Icons.devices,
                        //           color: Color(0xFF898989)),
                        //       onPressed: () {
                        //         // Implement change sound input functionality
                        //       },
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.ios_share_rounded,
                        //           color: Color(0xFF898989)),
                        //       onPressed: () {
                        //         // Implement download media functionality
                        //       },
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.queue_music,
                        //           color: Color(0xFF898989)),
                        //       onPressed: () {
                        //         // Implement queue functionality
                        //       },
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.queue_outlined,
                        //           color: Color(0xFF898989)),
                        //       onPressed: () {
                        //         // Implement queue functionality
                        //       },
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.more_horiz_outlined,
                        //           color: Color(0xFF898989)),
                        //       onPressed: () {
                        //         // Implement share functionality
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ));
            });
      },
    );
  }

  Widget _buildMainPlayer(BuildContext context,
      MyAudioHandler mediaPlayerProvider, imageUrl, title, artistName) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Album Cover
          SizedBox(
              width: 350,
              height: 350,
              child: ImageRenderer(
                imageUrl: imageUrl,
              )),
          const SizedBox(height: 20),
          // Song Title and Artist
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0), // Add padding to both sides
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title, // Replace with actual song title
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFFDBDBDB),
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        artistName, // Replace with actual artist name
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
    return const Column(
      children: [
        Expanded(
          child: Playlist(),
        ),
        // const CurrentSongTitle(),

        // const AddRemoveSongButtons(),
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
