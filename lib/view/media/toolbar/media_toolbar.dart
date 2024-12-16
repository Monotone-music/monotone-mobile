import 'package:flutter/material.dart';
import 'package:monotone_flutter/view/media/player/media_player.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/widgets/media_widgets/media_components.dart';
import 'package:provider/provider.dart';

class MediaToolbar extends StatefulWidget {
  // final VoidCallback onToggleMediaPlayer;

  MediaToolbar({
    super.key,
    // required this.onToggleMediaPlayer,
  });

  @override
  _MediaToolbarState createState() => _MediaToolbarState();
}

class _MediaToolbarState extends State<MediaToolbar> {
  bool _isMediaPlayerVisible = true;
  void _toggleMediaPlayer() {
    setState(() {});

    if (_isMediaPlayerVisible) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => MediaPlayer(),
      ).then((_) {
        setState(() {
          // _isMediaPlayerVisible = !_isMediaPlayerVisible;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final pageManager = getIt<MediaManager>();
    return Consumer<MyAudioHandler>(
      builder: (context, mediaPlayerProvider, child) {
        return GestureDetector(
          onTap: _toggleMediaPlayer,
          child: Container(
            padding: const EdgeInsets.all(0.0),
            margin: const EdgeInsets.all(0.0),
            width: screenWidth,
            height: 105.0,
            color:
                isDarkMode ? const Color(0xFF333842) : const Color(0xFFAAB3C6),
            // padding: const EdgeInsets.all(4.0),
            child: ValueListenableBuilder<String>(
              valueListenable: pageManager.currentSongTitleNotifier,
              builder: (context, currentSongTitle, child) {
                final currentMediaItem = pageManager.currentMediaItem;
                final imageUrl = currentMediaItem?.artUri?.toString() ??
                    'assets/image/not_available.png';
                final trackName = currentMediaItem?.title ?? 'No media loaded';
                final artistName = currentMediaItem?.artist ?? '';

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Media thumbnail
                        SizedBox(
                          width: 6.0,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageRenderer(
                            imageUrl: imageUrl,
                            width: 85,
                            height: 85,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        // const SizedBox(width: 8.0),
                        // Track Name and Artist Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 4.0,
                                  bottom: 4.0,
                                ),
                                child: AudioProgressBarSmall(
                                  isTimeIndicatorInvisible: true,
                                ),
                              ),
                              Text(
                                trackName,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // const SizedBox(height: 4.0),
                              Text(
                                artistName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: isDarkMode
                                          ? const Color(0xFFAAB3C6)
                                              .withOpacity(0.6)
                                          : const Color(0xFF333842)
                                              .withOpacity(0.6),
                                      // fontSize: 10,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RepeatButton(
                                    size: 20,
                                  ),
                                  PreviousSongButton(
                                    size: 20,
                                  ),
                                  PlayButton(),
                                  NextSongButton(
                                    size: 20,
                                  ),
                                  ShuffleButton(
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
