import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/release_group_model.dart';

class PlaylistController {
  void loadPlaylist(List<Track> playlist, String albumName) {
    getIt<MediaManager>().loadPlaylist(playlist, albumName);
  }

  void clearLoadPlaylistAndSkipToIndex(
      List<Track> playlist, String albumName, int index) {
    getIt<MediaManager>()
        .clearLoadPlaylistAndSkipToIndex(playlist, albumName, index);
  }

  Future<void> createPlaylist(String name, [String? recordingId]) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    final response = await httpClient.put(
      Uri.parse('$BASE_URL/playlist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        if (recordingId != null) 'recordingId': recordingId,
      }),
    );

    if (response.statusCode != 200) {
      switch (response.statusCode) {
        case '400':
        throw Exception('There can only be 3 playlists in a free account, upgrade here');
        default:
        throw Exception('Failed to create playlist');
      }
    }
  }

  Future<void> removeFromPlaylist(String playlistId, int trackIndex) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    final response = await httpClient.delete(
      Uri.parse('$BASE_URL/playlist/$playlistId/recording'),
      body: jsonEncode({
        'playlistId': playlistId,
        'index': trackIndex,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove track from playlist');
    }
  }

  Future<void> addTrackToPlaylist(String playlistId, String recordingId) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    final response = await httpClient.put(
      Uri.parse('$BASE_URL/playlist/$playlistId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'recordingId': recordingId,
      }),
    );
    print('status code ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Failed to add track to playlist');
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    final response = await httpClient.delete(
      Uri.parse('$BASE_URL/playlist/$playlistId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete playlist');
    }
  }
}
