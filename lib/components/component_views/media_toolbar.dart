import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/component_views/media_player.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/page_manager.dart';
import 'package:monotone_flutter/services/audio_handler.dart';
import 'package:monotone_flutter/services/media_components.dart';
import 'package:monotone_flutter/services/service_locator.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
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
    final pageManager = getIt<PageManager>();
    return Consumer<MyAudioHandler>(
      builder: (context, mediaPlayerProvider, child) {
        return GestureDetector(
          onTap: _toggleMediaPlayer,
          child: Container(
            width: screenWidth,
            height: 60.0,
            color:
                isDarkMode ? const Color(0xFF333842) : const Color(0xFFAAB3C6),
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<String>(
              valueListenable: pageManager.currentSongTitleNotifier,
              builder: (context, currentSongTitle, child) {
                final currentMediaItem = pageManager.currentMediaItem;
                final imageUrl = currentMediaItem?.artUri?.toString() ??
                    'assets/image/not_available.png';
                final trackName = currentMediaItem?.title ?? 'No media loaded';
                final artistName = currentMediaItem?.artist ?? ':D';

                return Row(
                  children: [
                    // Media thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ImageRenderer(
                        imageUrl: imageUrl,
                        width: 50,
                        height: 50,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Track Name and Artist Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            trackName,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            artistName,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: isDarkMode
                                      ? const Color(0xFFAAB3C6).withOpacity(0.6)
                                      : const Color(0xFF333842)
                                          .withOpacity(0.6),
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Other toolbar elements (e.g., play/pause button)
                    const PlayButton(),
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
