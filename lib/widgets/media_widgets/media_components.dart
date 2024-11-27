import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:monotone_flutter/controller/media/notifiers/play_button_notifier.dart';
import 'package:monotone_flutter/controller/media/notifiers/progress_notifier.dart';
import 'package:monotone_flutter/controller/media/notifiers/repeat_button_notifier.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:provider/provider.dart';

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
    return Expanded(
      child: ValueListenableBuilder<List<MediaItem>>(
        valueListenable: pageManager.playlistNotifier,
        builder: (context, playlist, _) {
          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final mediaItem = playlist[index];
              return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: ImageRenderer(
                      imageUrl: mediaItem.artUri?.toString() ??
                          'assets/image/album_1.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text(mediaItem.title),
                  subtitle: Text(
                    mediaItem.artist ?? 'Unknown Artist',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    getIt<AudioHandler>().skipToQueueItem(index);
                  },
                  trailing: IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.minimize_outlined),
                    onPressed: () {
                      getIt<AudioHandler>().removeQueueItemAt(index);
                      // print('delete song at index: $index');
                    },
                  ));
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
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          barHeight: 3.0,
          thumbRadius: 5.0,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
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
  const RepeatButton({Key? key}) : super(key: key);
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
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
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
              margin: const EdgeInsets.all(8.0),
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
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<MediaManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: (isLast) ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
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
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}

//custom widget
// class ChunkAudioControl extends StatelessWidget {
//   final _audioHandler = GetIt.instance<MyAudioHandler>();

//   Future<void> _testStreamAudioSource() async {
//     const apiUrl =
//         'https://api2.ibarakoi.online/tracks/stream/6740a0c66357c3ed99dedf9e';
//     print('apiUrl: $apiUrl');
//     await _audioHandler.addStreamAudioSourceFromApi(apiUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 300,
//       height: 50,
//       child: Center(
//         child: ElevatedButton(
//           onPressed: _testStreamAudioSource,
//           child: const Text('Test Stream Audio Source'),
//         ),
//       ),
//     );
//   }
// }
