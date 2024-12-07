import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/controller/media/notifiers/play_button_notifier.dart';
import 'package:monotone_flutter/controller/media/notifiers/progress_notifier.dart';
import 'package:monotone_flutter/controller/media/notifiers/repeat_button_notifier.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 40)),
        );
      },
    );
  }
}

class Playlist extends StatelessWidget {
  const Playlist({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final pageManager = getIt<MediaManager>();
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);
    return Expanded(
      child: ValueListenableBuilder<List<MediaItem>>(
        valueListenable: pageManager.playlistNotifier,
        builder: (context, playlist, _) {
          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final mediaItem = playlist[index];
              final isPlaying =
                  mediaItem.id == pageManager.currentMediaItem?.id;
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FutureBuilder<Response>(
                    future: httpClient.get(
                      Uri.parse(mediaItem.artUri?.toString() ?? ''),
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
                        return Image.asset(
                          'assets/image/not_available.png',
                          width: 50,
                          height: 50,
                        );
                      } else if (snapshot.hasData) {
                        final imageData = snapshot.data?.bodyBytes;
                        return ImageRenderer(
                          imageUrl: imageData,
                          width: 50,
                          height: 50,
                        );
                      } else {
                        return Image.asset(
                          'assets/image/album_1.png',
                          width: 50,
                          height: 50,
                        );
                      }
                    },
                  ),
                ),
                title: Text(mediaItem.title),
                subtitle: Text(
                  mediaItem.artist ?? 'Unknown Artist',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddRemoveSongButtons extends StatelessWidget {
  const AddRemoveSongButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: pageManager.add,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: pageManager.remove,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  final bool? isTimeIndicatorInvisible;
  const AudioProgressBar({Key? key, this.isTimeIndicatorInvisible})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          barHeight: 3.0,
          thumbRadius: 5.0,
          thumbCanPaintOutsideBar: false,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
          timeLabelLocation: isTimeIndicatorInvisible == true
              ? TimeLabelLocation.none
              : TimeLabelLocation.below,
        );
      },
    );
  }
}

class AudioProgressBarSmall extends StatelessWidget {
  final bool? isTimeIndicatorInvisible;
  const AudioProgressBarSmall({Key? key, this.isTimeIndicatorInvisible})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          barHeight: 2.0,
          thumbRadius: 4.0,
          thumbCanPaintOutsideBar: false,
          thumbGlowRadius: 15,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
          timeLabelLocation: isTimeIndicatorInvisible == true
              ? TimeLabelLocation.none
              : TimeLabelLocation.below,
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          RepeatButton(),
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
          ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  final double? size;
  const RepeatButton({Key? key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          iconSize: size,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  final double? size;
  const PreviousSongButton({Key? key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: size,
          onPressed: (isFirst) ? null : pageManager.previous,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              // margin: const EdgeInsets.all(2.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  final double? size;
  const NextSongButton({Key? key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: size,
          onPressed: (isLast) ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  final double? size;
  const ShuffleButton({Key? key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? const Icon(Icons.shuffle)
              : const Icon(Icons.shuffle, color: Colors.grey),
          iconSize: size,
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
