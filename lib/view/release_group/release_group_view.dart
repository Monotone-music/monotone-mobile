import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/release_group_model.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';

import 'package:shimmer/shimmer.dart';

String formatDuration(double duration) {
  final minutes = duration ~/ 60;
  final seconds = (duration % 60).toInt();
  return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
}

Widget buildShimmerLoading(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        // Shimmer for Album image with back button
        Stack(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Shimmer for Album name
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Shimmer for Tracks
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      title: Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      subtitle: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildAlbumImageWithBackButton(
    BuildContext context,
    ReleaseGroup releaseGroup,
    Map<String, String> imageCache,
    ThemeProvider themeProvider) {
  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());
  return Stack(
    children: [
      Container(
        height: 400,
        width: double.infinity,
        child: FutureBuilder<Response>(
          future: httpClient.get(
            Uri.parse(
              'https://api2.ibarakoi.online/image/${imageCache[releaseGroup.imageUrl]}',
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Icon(Icons.error));
            } else if (snapshot.hasData) {
              final imageData = snapshot.data?.bodyBytes;
              return Stack(
                children: [
                  ImageRenderer(
                    imageUrl: imageData,
                    width: double.infinity,
                    height: 400,
                    // fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          themeProvider.getThemeColorSurface().withOpacity(0.1),
                          themeProvider.getThemeColorSurface().withOpacity(0.3),
                          themeProvider.getThemeColorSurface().withOpacity(0.5),
                          themeProvider.getThemeColorSurface(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Image.asset('assets/image/not_available.png'),
              );
            }
          },
        ),
      ),
      Positioned(
        top: 16,
        left: 16,
        child: Container(
          decoration: BoxDecoration(
            color:
                Colors.black.withOpacity(0.2), // Background color with opacity
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      //More actions button
      Positioned(
        top: 16,
        right: 16,
        child: Container(
          decoration: BoxDecoration(
            color:
                Colors.black.withOpacity(0.2), // Background color with opacity
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Add more actions here
            },
          ),
        ),
      ),
      // Play shuffle button
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.play_arrow, color: Colors.green, size: 40),
                onPressed: () async {
                  getIt<MediaManager>().clearLoadPlaylistAndPlay(
                      releaseGroup.tracks, releaseGroup.name);
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                    onPressed: () {
                      // Handle add to favorite action
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.queue, color: Colors.blue, size: 20),
                    onPressed: () {
                      // Handle add to queue action
                      getIt<MediaManager>()
                          .loadPlaylist(releaseGroup.tracks, releaseGroup.name);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.share, color: Colors.yellow, size: 20),
                    onPressed: () {
                      // Handle share action
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildTrackList(BuildContext context, ReleaseGroup releaseGroup,
    bool isDarkMode, Map<String, String> imageCache) {
  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  ///
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: releaseGroup.tracks.length,
    itemBuilder: (context, index) {
      final track = releaseGroup.tracks[index];
      return ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 15,
              child: Text(
                track.position.toString(),
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(width: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FutureBuilder<Response>(
                future: httpClient.get(
                  Uri.parse(
                    'https://api2.ibarakoi.online/image/${imageCache[track.imageUrl]}',
                  ),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.white,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return ImageRenderer(
                      imageUrl: 'assets/image/not_available.png',
                      width: 60,
                      height: 60,
                    );
                  } else if (snapshot.hasData) {
                    final imageData = snapshot.data?.bodyBytes;
                    return ImageRenderer(
                      imageUrl: imageData,
                      width: 60,
                      height: 60,
                    );
                  } else {
                    return ImageRenderer(
                      imageUrl: 'assets/image/not_available.png',
                      width: 60,
                      height: 60,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        title: Text(
          track.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          '${formatDuration(track.duration)} •   ${track.artistNames.join(', ')}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black,
                fontWeight: FontWeight.w300,
              ),
        ),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Row(
            children: [
              Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.14,
                child: Text(
                  '${track.view}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                    fontSize: 13, // Adjust the font size as needed
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),

              ///
              PopupMenuButton<int>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 0) {
                    // Handle add to favorite action
                  } else if (value == 1) {
                    // Handle add to queue action
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Add to Favorite'),
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: ListTile(
                      leading: Icon(Icons.queue),
                      title: Text('Add to Queue'),
                      onTap: () {
                        getIt<MediaManager>()
                            .loadTrack(track, releaseGroup.name);
                      }, // Add track to queue
                    ),
                  ),

                  ///
                ],
              ),

              ///
            ],
          ),
        ),
        onTap: () async {
          // Play the track
          print('Recording id: ${track.id}');
          print('Album: ${releaseGroup.name}');

          getIt<MediaManager>().clearLoadPlaylistAndSkipToIndex(
              releaseGroup.tracks, releaseGroup.name, index);
          //skip to the selected track
          print('get indexed track: $index');
        },
      );
    },
  );
}
