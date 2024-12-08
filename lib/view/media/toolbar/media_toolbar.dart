import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/view/media/player/media_player.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/widgets/media_widgets/media_components.dart';
import 'package:shimmer/shimmer.dart';

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

  Future<Uint8List> fetchImage(Uri artUri) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());
    final response = await httpClient.get(artUri);
    print(response);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final pageManager = getIt<MediaManager>();

    ////
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
                final trackName = currentMediaItem?.title ?? 'No media loaded';
                final artistName =
                    currentMediaItem?.artist ?? 'Xue hue piao piao';

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        // Media thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: currentMediaItem?.artUri != null
                              ? FutureBuilder<Uint8List>(
                                  future: fetchImage(currentMediaItem!.artUri!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return ImageRenderer(
                                        imageUrl:
                                            'assets/image/not_available.png',
                                        width: 75,
                                        height: 75,
                                      );
                                    } else if (snapshot.hasData) {
                                      return ImageRenderer(
                                        imageUrl: snapshot.data!,
                                        width: 75,
                                        height: 75,
                                      );
                                    } else {
                                      return ImageRenderer(
                                        imageUrl:
                                            'assets/image/not_available.png',
                                        width: 75,
                                        height: 75,
                                      );
                                    }
                                  },
                                )
                              : ImageRenderer(
                                  imageUrl: 'assets/image/not_available.png',
                                  width: 75,
                                  height: 75,
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

                                  ///
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );

                ///
              },
            ),
          ),
        );
      },
    );
  }
}
