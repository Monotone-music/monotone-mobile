import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:monotone_flutter/view/library/playlist_detail_view.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/controller/playlist/playlist_data.dart';
import 'package:monotone_flutter/view/media/toolbar/media_toolbar.dart';
import 'package:monotone_flutter/models/personal_playlist_items.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';

class PlaylistPage extends StatefulWidget {
  final String id;

  PlaylistPage({required this.id});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Future<Map<String, dynamic>> playlistData;

  @override
  void initState() {
    super.initState();
    playlistData = fetchPlaylistData(widget.id);
  }

  void _reloadPlaylist() {
    setState(() {
      playlistData = fetchPlaylistData(widget.id);
    });
  }

  String formatDuration(double duration) {
    final minutes = duration ~/ 60;
    final seconds = (duration % 60).toInt();
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: playlistData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final playlist = snapshot.data!['playlist'];
              final imageCache = snapshot.data!['imageCache'];
              print('imageCache: ${imageCache}');

              // Calculate total duration
              final totalDuration = playlist.recordings.fold<double>(
                  0.0,
                  (double sum, Recording recording) =>
                      sum + recording.recording.duration);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Album image with back button
                    buildAlbumImageWithBackButton(
                        context, playlist, imageCache, themeProvider),
                    // const SizedBox(height: 16),
                    // Album name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          AutoScrollText(
                            playlist.name,
                            textAlign: TextAlign.center,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(25, 0)),
                            mode: AutoScrollTextMode.endless,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 8),
                          // Artist name
                          if (playlist.recordings.isNotEmpty)
                            Text(
                              playlist.recordings[0].recording.displayedArtist,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          const SizedBox(height: 8),
                          // Release year, total tracks, total duration
                          Text(
                            '${playlist.createdAt.year} • ${playlist.recordings.length} tracks • ${formatDuration(totalDuration)}',
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
                    const SizedBox(height: 8),
                    // Tracks
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (playlist.recordings.isNotEmpty)
                            buildTrackList(context, playlist, isDarkMode,
                                imageCache, _reloadPlaylist)
                          else
                            Center(
                              child: Text(
                                'No tracks available in this playlist.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.black,
                                    ),
                              ),
                            ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
