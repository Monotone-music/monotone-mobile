import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/release_group/release_group_controller.dart';
import 'package:monotone_flutter/view/artist_detail/artist_detail.dart';
import 'package:shimmer/shimmer.dart';

import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/models/release_group_model.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';

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
  final artistId = releaseGroup.artistId;

  return Stack(
    children: [
      Container(
        height: 400,
        width: double.infinity,
        child: Stack(
          children: [
            ImageRenderer(
              imageUrl: '$BASE_URL/image/${imageCache[releaseGroup.imageUrl]}',
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      //More actions button
      if (artistId != 'Various Artists')
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black
                  .withOpacity(0.2), // Background color with opacity
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArtistDetailPage(artistId: artistId),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About this artist'),
                  ),
                ),
              ],
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
                      getIt<MediaManager>().sequentialLoadTracks(
                          releaseGroup.tracks, releaseGroup.name);
                    },
                  ),
                ),
                const SizedBox(width: 16),
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
              child: ImageRenderer(
                imageUrl: '$BASE_URL/image/${imageCache[track.imageUrl]}',
                width: 60,
                height: 60,
              ),
            ),
          ],
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            final textSpan = TextSpan(
              text: track.title,
              style: Theme.of(context).textTheme.bodyLarge,
            );

            final textPainter = TextPainter(
              text: textSpan,
              maxLines: 1,
              textDirection: TextDirection.ltr,
            );

            textPainter.layout(minWidth: 0, maxWidth: constraints.maxWidth);

            if (textPainter.didExceedMaxLines) {
              return AutoScrollText(
                track.title,
                textAlign: TextAlign.left,
                velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                intervalSpaces: 5,
                mode: AutoScrollTextMode.endless,
                delayBefore: const Duration(seconds: 2),
                style: Theme.of(context).textTheme.bodyLarge,
              );
            } else {
              return Text(
                track.title,
                style: Theme.of(context).textTheme.bodyLarge,
              );
            }
          },
        ),
        subtitle: Row(
          children: [
            Text(
              '${formatDuration(track.duration)} • ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final artistNames = track.artistNames.join(', ');
                  final textSpan = TextSpan(
                    text: artistNames,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                  );

                  final textPainter = TextPainter(
                    text: textSpan,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  );

                  textPainter.layout(
                      minWidth: 0, maxWidth: constraints.maxWidth);

                  if (textPainter.didExceedMaxLines) {
                    return AutoScrollText(
                      artistNames,
                      textAlign: TextAlign.left,
                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                      intervalSpaces: 5,
                      mode: AutoScrollTextMode.endless,
                      delayBefore: const Duration(seconds: 2),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                    );
                  } else {
                    return Text(
                      artistNames,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                    );
                  }
                },
              ),
            ),
          ],
        ),

        ///
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textSpan = TextSpan(
                      text: '${track.view}',
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    );

                    final textPainter = TextPainter(
                      text: textSpan,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    );

                    textPainter.layout(
                        minWidth: 0, maxWidth: constraints.maxWidth);

                    if (textPainter.didExceedMaxLines) {
                      return AutoScrollText(
                        '${track.view}',
                        textAlign: TextAlign.right,
                        velocity:
                            const Velocity(pixelsPerSecond: Offset(20, 0)),
                        pauseBetween: const Duration(seconds: 1),
                        mode: AutoScrollTextMode.bouncing,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      );
                    } else {
                      return Text(
                        '${track.view}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      );
                    }
                  },
                ),
              ),

              ///

              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 0) {
                    // Handle add to favorite action
                  } else if (value == 1) {
                    // Handle add to queue action
                  } else if (value == 2) {}
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: ListTile(
                      leading: const Icon(Icons.playlist_add),
                      title: const Text('Add to Playlist'),
                      onTap: () {
                        // Add track to playlist
                        openPlaylistModal(context, track.id);
                      },
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: ListTile(
                      leading: const Icon(Icons.queue),
                      title: const Text('Add to Queue'),
                      onTap: () {
                        getIt<MediaManager>()
                            .loadTrack(track, releaseGroup.name);
                      }, // Add track to queue
                    ),
                  ),

                  PopupMenuItem<int>(
                    value: 2,
                    child: ListTile(
                      leading: const Icon(Icons.report),
                      title: const Text('Report a problem'),
                      onTap: () {
                        _showReportDialog(context, track.id);
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

void _showReportDialog(BuildContext context, String recordingId) {
  showDialog(
    context: context,
    builder: (context) {
      String? selectedOption;
      TextEditingController detailController = TextEditingController();
      final _releaseGroupController = ReleaseGroupController();
      return AlertDialog(
        title: const Text('Report a problem'),
        content: Container(
          width: 300.0, // Set the fixed width here
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('The track is unavailable'),
                    value: 'invalid_playback',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('The track is inappropriate'),
                    value: 'inappropriate_content',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Other error'),
                    value: 'other',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  TextField(
                    controller: detailController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[ -~]')),
                      LengthLimitingTextInputFormatter(250),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Error detail',
                      labelStyle: TextStyle(
                        color: Colors.white
                            .withOpacity(0.7), // Adjust the opacity here
                      ),
                    ),
                    onChanged: (text) {
                      if (!RegExp(r'^[ -~]*$').hasMatch(text)) {
                        Fluttertoast.showToast(
                          msg: 'Only ASCII characters are allowed',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } else if (text.length > 250) {
                        Fluttertoast.showToast(
                          msg: 'Character limit of 250 reached',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),

        ///
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (selectedOption == null) {
                Fluttertoast.showToast(
                  msg: 'Please select an option',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                return;
              }
              String response = await _releaseGroupController.reportRelease(
                  recordingId, selectedOption!, detailController.text);
              // Handle the report submission
              switch (response) {
                case '200':
                  Fluttertoast.showToast(
                    msg: 'Report submitted successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  break;
                case '400':
                  Fluttertoast.showToast(
                    msg: 'Bad request',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  break;
                case '401':
                  Fluttertoast.showToast(
                    msg: 'Unauthorized',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  break;
                // case '403':
                //   Fluttertoast.showToast(
                //     msg: 'Forbidden',
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.BOTTOM,
                //     backgroundColor: Colors.red,
                //     textColor: Colors.white,
                //   );
                //   break;
                case '404':
                  Fluttertoast.showToast(
                    msg: 'Not found',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  break;
                case '502':
                  Fluttertoast.showToast(
                    msg: 'Bad gateway',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  break;
                case '500':
                  Fluttertoast.showToast(
                    msg: 'Something broke',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  break;
                default:
                  Fluttertoast.showToast(
                    msg: 'An unexpected error happened',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  break;
              }
              print('Selected option: $selectedOption');
              print('Detail: ${detailController.text}');
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
