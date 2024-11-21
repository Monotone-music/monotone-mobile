import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:monotone_flutter/components/models/track_item.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/page_manager.dart';
import 'package:monotone_flutter/pages/release_group.dart';
import 'package:monotone_flutter/services/audio_handler.dart';
import 'package:monotone_flutter/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';

class PlaylistMini extends StatefulWidget {
  final Map<String, String> trackItem;

  const PlaylistMini({super.key, required this.trackItem});

  @override
  State<PlaylistMini> createState() => _PlaylistMiniState();
}

class _PlaylistMiniState extends State<PlaylistMini> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          // This is where to pass reference data to the audio handler

          // getIt<PageManager>().FakeLoadPlaylist();
          // getIt<MyAudioHandler>().clearQueue();
          // await getIt<PageManager>().removeAll();
          // getIt<PageManager>().loadTrack(widget.trackItem);
          // getIt<AudioHandler>().skipToQueueItem(widget.)
        },
        child: Container(
          width: screenWidth * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color:
                isDarkMode ? const Color(0xFF202020) : const Color(0xFFE4E4E4),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: ImageRenderer(
                  imageUrl: widget.trackItem['artUri'].toString(),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      // This is where to pass reference data to the audio handler

                      // getIt<PageManager>().FakeLoadPlaylist();
                      // getIt<MyAudioHandler>().clearQueue();
                      // await getIt<PageManager>().removeAll();
                      getIt<PageManager>().loadTrack(widget.trackItem);
                      // getIt<AudioHandler>().skipToQueueItem(widget.)
                    },
                    child: Text(
                      widget.trackItem['title'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.trackItem['artist'] != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReleaseGroupPage(
                                artistName: widget.trackItem['artist']!),
                          ),
                        );
                      },
                      child: Text(
                        widget.trackItem['artist']!,
                        style: TextStyle(
                          color: isDarkMode
                              ? const Color.fromARGB(255, 166, 166, 166)
                              : const Color.fromARGB(255, 118, 118, 118),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                ],
              ),
            ],
          ),
        ));
  }
}
