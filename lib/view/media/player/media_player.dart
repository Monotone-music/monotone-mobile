import 'package:flutter/material.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/view/media/player/media_lyric_view.dart';
import 'package:monotone_flutter/view/media/player/media_main_player_view.dart';
import 'package:monotone_flutter/view/media/player/media_playlist_view.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/widgets/media_widgets/media_components.dart';
import 'package:provider/provider.dart';

class MediaPlayer extends StatelessWidget {
  const MediaPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final pageManager = getIt<MediaManager>();
    return Consumer<MyAudioHandler>(
      builder: (context, mediaPlayerProvider, child) {
        return ValueListenableBuilder(
            valueListenable: pageManager.currentSongTitleNotifier,
            builder: (context, currentSongTitle, child) {
              final currentMediaItem = pageManager.currentMediaItem;
              final imageUrl = currentSongTitle.isEmpty
                  ? 'assets/image/not_available.png'
                  : currentMediaItem?.artUri?.toString() ??
                      'assets/image/not_available.png';
              final title = currentSongTitle.isEmpty
                  ? 'No media loaded'
                  : currentMediaItem?.title ?? 'No media loaded';
              final artistName = currentSongTitle.isEmpty
                  ? 'Select a track to play'
                  : currentMediaItem?.artist ?? 'Select a track to play';
              final albumName = currentSongTitle.isEmpty
                  ? ''
                  : currentMediaItem?.album ?? 'Unknown Album';
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
                                return buildPlaylist(context);
                              case 1:
                                return buildMainPlayer(
                                    context,
                                    mediaPlayerProvider,
                                    imageUrl,
                                    title,
                                    artistName);
                              case 2:
                                return buildLyrics(context);
                              default:
                                return const SizedBox();
                            }
                          },
                        )
                            // ;}),
                            ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: AudioProgressBar(),
                        ),
                        const AudioControlButtons(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ));
            });
      },
    );
  }
}
