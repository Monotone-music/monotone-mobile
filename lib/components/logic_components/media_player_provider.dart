import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class MediaPlayerProvider extends ChangeNotifier {
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isPlaying = false;
  String? currentMediaUrl;
  final AudioPlayer _audioPlayer = AudioPlayer();

  MediaPlayerProvider() {
    _audioPlayer.positionStream.listen((Duration p) {
      position = p;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((Duration? d) {
      duration = d ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((PlayerState state) {
      isPlaying = state.playing;
      notifyListeners();
    });
  }

  void initSong() {
    if (currentMediaUrl != null) {
      _audioPlayer.setUrl(currentMediaUrl!).catchError((error) {
        print('Error setting URL: $error');
      });
    } else {
      print('No media URL set');
    }
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void setMediaUrl(String url) {
    currentMediaUrl = url;
    notifyListeners();
  }

  // Future<void> fetchMedia() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('https://api.ibarakoi.online/tracks/get'));
  //     if (response.statusCode == 200) {
  //       currentMediaUrl = response.request?.url.toString();
  //       notifyListeners();
  //     } else {
  //       throw Exception('Failed to load media');
  //     }
  //   } catch (e) {
  //     print('Error fetching media: $e');
  //   }
  // }
}
