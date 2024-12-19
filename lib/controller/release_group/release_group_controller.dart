import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/playlist_items.dart';
import 'package:monotone_flutter/models/release_group_model.dart';
import 'package:monotone_flutter/view/release_group/add_playlist_modal.dart';

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

Future<List<PlaylistItem>> fetchUserPlaylists() async {
  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  final response =
      await httpClient.get(Uri.parse('$BASE_URL/listener/profile'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load user playlists');
  }

  final responseBody = jsonDecode(response.body);
  print(responseBody);
  final playlists = List<PlaylistItem>.from(responseBody['data']['playlist']
      .map((playlist) => PlaylistItem.fromJson(playlist)));

  return playlists;
}

void openPlaylistModal(BuildContext context, String recordingId) async {
  final playlists = await fetchUserPlaylists();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return PlaylistModal(playlists: playlists, recordingId: recordingId);
    },
  );
}
