import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'package:audio_service/audio_service.dart';
import 'services/playlist_repository.dart';
import 'services/service_locator.dart';
import 'package:http/http.dart' as http;

import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/advertisment/advertisement_loader.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/personal_playlist_items.dart';
import 'package:monotone_flutter/models/release_group_model.dart';

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

  // Extra
  MediaItem? get currentMediaItem => _audioHandler.mediaItem.value;
  int listenAgain = 0;

  final _audioHandler = getIt<AudioHandler>();
  var queueCounter = 0;
  final storage = const FlutterSecureStorage();

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

  Future<void> addAdvertisement() async {
    final advertisementLoader = AdvertisementLoader();
    final advertisement =
        await advertisementLoader.fetchRandomAdvertisement('player');
    dynamic advertisementItem;
    if (advertisement != null) {
      advertisementItem = MediaItem(
        id: '${advertisement.data.id}_advertisement',
        title: advertisement.data.title,
        artist: 'Advertisement',
        artUri:
            Uri.parse('$BASE_URL/image/${advertisement.data.image.filename}'),
        extras: {
          'url': '$BASE_URL/advertisement/stream/${advertisement.data.id}'
        },
      );
    } else {
      advertisementItem = MediaItem(
        id: '_advertisement',
        title: "Ads not supported",
        artist: 'Advertisement',
        artUri: Uri.parse('assets/image/not_available.png'),
        duration: const Duration(seconds: 10),
      );
    }

    _audioHandler.addQueueItem(advertisementItem);
  }

  Future<void> _handleAdvertisements(
      String? oldPlaylist, String? newPlaylist) async {
    var bitrate = await storage.read(key: 'bitrate');
    if (bitrate != '192') {
      return;
    }
    // WHEN THE LISTENER RE-LISTENS
    //TO THE ALBUM FOR THE FIRST TIME,
    //DON'T RUN ADS
    if (oldPlaylist == null || newPlaylist == null) {
      await addAdvertisement();
      listenAgain = 0;
    } else {
      if (newPlaylist != oldPlaylist || listenAgain == 1) {
        await addAdvertisement();
        listenAgain = 0;
      } else {
        listenAgain = 1;
      }
    }
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
    String? _currentPlaylist = _audioHandler.queue.value.isNotEmpty
        ? _audioHandler.queue.value.last.album
        : null;

    await _audioHandler.stop();
    await _audioHandler.seek(Duration.zero);
    await _audioHandler.skipToQueueItem(0);
    removeAll();

    await _handleAdvertisements(_currentPlaylist, albumName);
    loadPlaylist(playlist, albumName);
    play();
  }

  ///========================For the release group page========================

  void clearLoadPlaylistAndSkipToIndex(
      List<Track> playlist, String albumName, int index) async {
    String? _currentPlaylist = _audioHandler.queue.value.isNotEmpty
        ? _audioHandler.queue.value.last.album
        : null;

    await _audioHandler.stop();
    await _audioHandler.seek(Duration.zero);
    removeAll();
    // loadPlaylist(playlist, albumName);
    // stop();
    await _handleAdvertisements(_currentPlaylist, albumName);
//// Add the selected track first
    final selectedTrack = playlist[index];
    final selectedMediaItem = MediaItem(
      id: '${selectedTrack.id}_${queueCounter++}',
      album: albumName,
      title: selectedTrack.title,
      artist: selectedTrack.artistNames.join(', '),
      artUri: Uri.parse('$BASE_URL/image/${selectedTrack.imageUrl}'),
      extras: {
        'url': '$BASE_URL/tracks/stream/${selectedTrack.id}?bitrate=lossless'
      },
    );
    await _audioHandler.addQueueItem(selectedMediaItem);

    // Add the rest of the playlist
    final remainingTracks = playlist.sublist(index + 1);
    loadPlaylist(remainingTracks, albumName);

    await _audioHandler.skipToQueueItem(0);
    print('Skipped to index: $index');
    play();
  }

  void loadPlaylist(List<Track> playlist, String albumName) async {
    print('playlist loading');
    // final songRepository = getIt<PlaylistRepository>();
    final mediaItems = playlist.map((track) {
      return MediaItem(
        id: '${track.id}_${queueCounter++}',
        album: albumName,
        title: track.title,
        artist: track.artistNames.join(', '),
        artUri: Uri.parse('$BASE_URL/image/${track.imageUrl}'),
        extras: {'url': '$BASE_URL/tracks/stream/${track.id}?bitrate=lossless'},
      );
    }).toList();
    await _audioHandler.addQueueItems(mediaItems);
    print('playlist loaded');
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

    final fetchedTrack = track;
    final mediaItem = MediaItem(
      id: '${fetchedTrack.id}_${queueCounter++}',
      album: albumName,
      title: fetchedTrack.title,
      artist: fetchedTrack.artistNames.join(', '),
      artUri: Uri.parse('$BASE_URL/image/${fetchedTrack.imageUrl}'),
      extras: {
        'url': '$BASE_URL/tracks/stream/${fetchedTrack.id}?bitrate=lossless'
      },
    );

    await _audioHandler.addQueueItem(mediaItem);
    // print(mediaItem);
    print('track loaded: ${mediaItem}');
    // auto play the track after finish loading
  }

  ///========================================================================
  ///
  ///========================For the library - playlist page========================
  ///
  void addToUserPlaylist(String name, String? recordingId) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    final addPlaylistResponse =
        await httpClient.put(Uri.parse('$BASE_URL/playlist'),
            body: jsonEncode({
              'name': name,
              if (recordingId != null) 'recordingId': recordingId,
            }));
    print('addPlaylistResponse: ${addPlaylistResponse.body}');

    if (addPlaylistResponse.statusCode != 200) {
      throw Exception('Failed to load release group');
    }
  }

  void clearLoadPlaylistAndSkipToIndexForPlaylist(
      List<RecordingDetails> playlist, String playlistName, int index) async {
    await _audioHandler.stop();
    await _audioHandler.seek(Duration.zero);
    removeAll();

    // Add the selected track first
    final selectedTrack = playlist[index];
    final selectedMediaItem = MediaItem(
      id: '${selectedTrack.id}_${queueCounter++}',
      album: playlistName,
      title: selectedTrack.title,
      artist: selectedTrack.artists.map((artist) => artist.name).join(', '),
      artUri: Uri.parse('$BASE_URL/image/${selectedTrack.image.filename}'),
      extras: {
        'url': '$BASE_URL/tracks/stream/${selectedTrack.id}?bitrate=lossless'
      },
    );
    await _audioHandler.addQueueItem(selectedMediaItem);

    // Add the rest of the playlist
    final remainingTracks = playlist.sublist(index + 1);
    loadPlaylistForRecordings(remainingTracks, playlistName);

    await _audioHandler.skipToQueueItem(0);
    print('Skipped to index: $index');
    play();
  }

  void loadPlaylistForRecordings(
      List<RecordingDetails> playlist, String playlistName) async {
    print('playlist loading');
    final mediaItems = playlist.map((recording) {
      return MediaItem(
        id: '${recording.id}_${queueCounter++}',
        album: playlistName,
        title: recording.title,
        artist: recording.artists.map((artist) => artist.name).join(', '),
        artUri: Uri.parse('$BASE_URL/image/${recording.image.filename}'),
        extras: {
          'url': '$BASE_URL/tracks/stream/${recording.id}?bitrate=lossless'
        },
      );
    }).toList();
    await _audioHandler.addQueueItems(mediaItems);
    print('playlist loaded: ${mediaItems}');
    // auto play the track after finish loading
  }

  void loadTrackForPlaylist(
      RecordingDetails recording, String playlistName) async {
    print('track loading');

    final mediaItem = MediaItem(
      id: '${recording.id}_${queueCounter++}',
      album: playlistName,
      title: recording.title,
      artist: recording.artists.map((artist) => artist.name).join(', '),
      artUri: Uri.parse('$BASE_URL/image/${recording.image.filename}'),
      extras: {
        'url': '$BASE_URL/tracks/stream/${recording.id}?bitrate=lossless'
      },
    );

    await _audioHandler.addQueueItem(mediaItem);
    print('track loaded: ${mediaItem}');
    // auto play the track after finish loading
  }

  void clearLoadPlaylistAndPlayForPlaylist(
      List<RecordingDetails> playlist, String playlistName) async {
    await _audioHandler.stop();
    await _audioHandler.seek(Duration.zero);
    removeAll();

    // Load the entire playlist
    final mediaItems = playlist.map((recording) {
      return MediaItem(
        id: '${recording.id}_${queueCounter++}',
        album: playlistName,
        title: recording.title,
        artist: recording.artists.map((artist) => artist.name).join(', '),
        artUri: Uri.parse('$BASE_URL/image/${recording.image.filename}'),
        extras: {
          'url': '$BASE_URL/tracks/stream/${recording.id}?bitrate=lossless'
        },
      );
    }).toList();
    await _audioHandler.addQueueItems(mediaItems);
    print('playlist loaded: ${mediaItems}');

    // Start playing from the beginning
    await _audioHandler.skipToQueueItem(0);
    play();
  }

  ///========================================================================

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

  void removeAll() async {
    final queueLength = _audioHandler.queue.value.length;
    for (int i = queueLength - 1; i >= 0; i--) {
      _audioHandler.removeQueueItemAt(i);
    }
    print('All items removed from the queue');
    // _audioHandler.pause();
    // _audioHandler.seek(Duration.zero);
    // _audioHandler.skipToQueueItem(0);

    // playlistNotifier.value = [];
    // currentSongTitleNotifier.value = '';
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }

  Future<void> logOut() async {
    progressNotifier.value = const ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    );
    await _audioHandler.pause();
    await _audioHandler.seek(Duration.zero);
    await _audioHandler.skipToQueueItem(0);
    stop();
  }
}
