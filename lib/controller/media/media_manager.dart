import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/release_group_model.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'package:audio_service/audio_service.dart';
import 'services/playlist_repository.dart';
import 'services/service_locator.dart';
import 'package:http/http.dart' as http;

class MediaManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ]);
  // Extra
  MediaItem? get currentMediaItem => _audioHandler.mediaItem.value;

  final _audioHandler = getIt<AudioHandler>();
  var queueCounter = 0;

  // Events: Calls coming from the UI
  void init() async {
    // await _initLoadPlaylist();

    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  Future<void> fetchAndPrintApiResponse(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 206) {
        print('API Response: ${response.headers}');
      } else {
        print(
            'Failed to load data from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data from API: $e');
    }
  }

  Future<void> addQueueItemIfNotExists(MediaItem mediaItem) async {
    if (!_isDuplicate(mediaItem)) {
      await _audioHandler.addQueueItem(mediaItem);
    } else {
      print('Item already exists in the queue: ${mediaItem.title}');
    }
  }

  bool _isDuplicate(MediaItem mediaItem) {
    return _audioHandler.queue.value.any((item) => item.id == mediaItem.id);
  }

  void clearLoadPlaylistAndPlay(List<Track> playlist, String albumName) async {
    await _audioHandler.stop();
    await _audioHandler.seek(Duration.zero);
    await _audioHandler.skipToQueueItem(0);
    removeAll();
    loadPlaylist(playlist, albumName);
    play();
  }

  void clearLoadPlaylistAndSkipToIndex(
      List<Track> playlist, String albumName, int index) async {
    await _audioHandler.stop();
    await _audioHandler.seek(Duration.zero);
    removeAll();

    // Add the selected track first
    final selectedTrack = playlist[index];
    final selectedMediaItem = await _createMediaItem(selectedTrack, albumName);
    await _audioHandler.addQueueItem(selectedMediaItem);

    // Add the rest of the playlist
    final remainingTracks =
        playlist.where((track) => track.id != selectedTrack.id).toList();
    loadPlaylist(remainingTracks, albumName);

    await _audioHandler.skipToQueueItem(0);
    print('Skipped to index: $index');
    play();
  }

  Future<MediaItem> _createMediaItem(Track track, String albumName) async {
    final accessToken = await _storage.read(key: 'accessToken');
    final bitrate = await _storage.read(key: 'bitrate');

    // print('https://api2.ibarakoi.online/tracks/stream/${track.id}?bitrate=${bitrate}');
    return MediaItem(
      id: '${track.id}_${queueCounter++}',
      album: albumName,
      title: track.title,
      artist: track.artistNames.join(', '),
      artUri: Uri.parse('https://api2.ibarakoi.online/image/${track.imageUrl}'),
      artHeaders: {'Authorization': 'Bearer $accessToken'},
      extras: {
        'url':
            'https://api2.ibarakoi.online/tracks/stream/${track.id}?bitrate=lossless',
      },
    );
  }

  void loadPlaylist(List<Track> playlist, String albumName) async {
    print('playlist loading');
    final mediaItems = await Future.wait(playlist.map((track) async {
      return await _createMediaItem(track, albumName);
    }).toList());
    await _audioHandler.addQueueItems(mediaItems);
    print('playlist loaded: ${mediaItems}');
    // auto play the track after finish loading
  }

  void sequentialLoadTracks(List<Track> tracks, String albumName) async {
    for (var track in tracks) {
      loadTrack(track, albumName);
    }
  }

  void clearAndLoadTrack(Track track, String albumName) async {
    removeAll();
    loadTrack(track, albumName);
    play();
  }

  void loadTrack(
      //add Map<String, String> input argument
      Track track,
      String albumName) async {
    // final songRepository = getIt<PlaylistRepository>();

    print('track loading');
    final accessToken = await _storage.read(key: 'accessToken');
    final bitrate = await _storage.read(key: 'bitrate');
    
    final fetchedTrack = track;
    final mediaItem = MediaItem(
      id: '${fetchedTrack.id}_${queueCounter++}',
      album: albumName,
      title: fetchedTrack.title,
      artist: fetchedTrack.artistNames.join(', '),
      artHeaders: {'Authorization': 'Bearer $accessToken'},
      artUri: Uri.parse('$BASE_URL/image/${fetchedTrack.imageUrl}'),
      extras: {
        'url': '$BASE_URL/tracks/stream/${fetchedTrack.id}?bitrate=lossless'
      },
    );
    // fetchAndPrintApiResponse(mediaItem.extras!['url'] as String);

    await _audioHandler.addQueueItem(mediaItem);
    // print(mediaItem);
    print('track loaded: ${mediaItem}');
    // auto play the track after finish loading
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
      } else {
        playlistNotifier.value = playlist;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> add() async {
    final songRepository = getIt<PlaylistRepository>();
    final song = await songRepository.fetchAnotherSong();
    final mediaItem = MediaItem(
      id: song['id'] ?? '',
      album: song['album'] ?? '',
      title: song['title'] ?? '',
      extras: {'url': song['url']},
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void removeAll() {
    final queueLength = _audioHandler.queue.value.length;
    for (int i = queueLength - 1; i >= 0; i--) {
      _audioHandler.removeQueueItemAt(i);
    }
    print('All items removed from the queue');
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}
