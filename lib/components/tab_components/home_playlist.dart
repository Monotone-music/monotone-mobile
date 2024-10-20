import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/logic_components/media_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';

class PlaylistMini extends StatefulWidget {
  final String title; // Required input
  final String? artist; // Optional input
  final String imageUrl; // Required input
  final String songUrl; // Req input

  const PlaylistMini({
    Key? key,
    required this.title,
    this.artist,
    required this.imageUrl,
    required this.songUrl,
  }) : super(key: key);

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
        onTap: () {
          final mediaPlayerProvider =
              Provider.of<MediaPlayerProvider>(context, listen: false);
          mediaPlayerProvider.setMediaUrl(widget.songUrl);
          mediaPlayerProvider.initSong();
          // mediaPlayerProvider.fetchMedia(widget.songUrl);
          mediaPlayerProvider.play(); // Autoplay the song
        },
        child: Container(
          width: screenWidth * 0.5 - 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color:
                isDarkMode ? const Color(0xFF202020) : const Color(0xFFE4E4E4),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.scaleDown,
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  if (widget.artist != null)
                    Text(
                      widget.artist!,
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color.fromARGB(255, 166, 166, 166)
                            : const Color.fromARGB(255, 118, 118, 118),
                        fontSize: 12,
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
