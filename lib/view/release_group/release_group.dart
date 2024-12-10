import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/controller/release_group/release_group_data.dart';
import 'package:monotone_flutter/view/media/toolbar/media_toolbar.dart';
import 'package:monotone_flutter/models/release_group_model.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/view/release_group/release_group_view.dart';

class ReleaseGroupPage extends StatefulWidget {
  final String id;

  ReleaseGroupPage({required this.id});

  @override
  _ReleaseGroupPageState createState() => _ReleaseGroupPageState();
}

class _ReleaseGroupPageState extends State<ReleaseGroupPage> {
  late Future<Map<String, dynamic>> releaseGroupData;

  @override
  void initState() {
    super.initState();
    releaseGroupData = fetchReleaseGroupData(widget.id);
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
          future: releaseGroupData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildShimmerLoading(context);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final releaseGroup = snapshot.data!['releaseGroup'];
              final imageCache = snapshot.data!['imageCache'];

              // Calculate total duration
              final totalDuration = releaseGroup.tracks.fold<double>(
                  0.0, (double sum, Track track) => sum + track.duration);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Album image with back button
                    buildAlbumImageWithBackButton(
                        context, releaseGroup, imageCache, themeProvider),
                    // const SizedBox(height: 16),
                    // Album name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          AutoScrollText(
                            releaseGroup.name,
                            textAlign: TextAlign.center,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(25, 0)),
                            mode: AutoScrollTextMode.endless,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 8),
                          // Artist name
                          Text(
                            releaseGroup.artistName,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          //release year, total tracks, total duration
                          Text(
                            '${releaseGroup.releaseYear} • ${releaseGroup.tracks.length} tracks • ${formatDuration(totalDuration)}',
                            //Add color to the text

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
                          buildTrackList(
                              context, releaseGroup, isDarkMode, imageCache),
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
      // bottomNavigationBar: MediaToolbar(),
    );
  }
}
