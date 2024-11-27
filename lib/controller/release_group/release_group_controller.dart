import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/models/release_group_model.dart';

class ReleaseGroupController {
  void loadPlaylist(List<Track> playlist, String albumName) {
    getIt<MediaManager>().loadPlaylist(playlist, albumName);
  }

  void clearLoadPlaylistAndSkipToIndex(
      List<Track> playlist, String albumName, int index) {
    getIt<MediaManager>()
        .clearLoadPlaylistAndSkipToIndex(playlist, albumName, index);
  }
}
