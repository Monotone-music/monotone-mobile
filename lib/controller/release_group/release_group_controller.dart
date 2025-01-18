import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/controller/media/media_manager.dart';
import 'package:monotone_flutter/controller/media/services/service_locator.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/playlist_items.dart';
import 'package:monotone_flutter/models/release_group_model.dart';
import 'package:monotone_flutter/view/release_group/add_playlist_modal.dart';

class ReleaseGroupController {
  final Dio _dio = Dio();

  void loadPlaylist(List<Track> playlist, String albumName) {
    getIt<MediaManager>().loadPlaylist(playlist, albumName);
  }

  void clearLoadPlaylistAndSkipToIndex(
      List<Track> playlist, String albumName, int index) {
    getIt<MediaManager>()
        .clearLoadPlaylistAndSkipToIndex(playlist, albumName, index);
  }

  Future<String> reportRelease(
      String recordingId, String? type, String? reason) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    final apiUrl = Uri.parse('$BASE_URL/report/create');
    final Map<String, dynamic> requestBody = {
      'recordingId': recordingId,
      'type': type,
      'reason': reason,
    };

    try {
      final response = await httpClient.post(apiUrl, body: requestBody);

      if (response.statusCode == 200) {
        return '200';
      } else {
        return '${response.statusCode}';
      }

      ///
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle specific status codes
        if (e.response!.statusCode == 400) {
          return '400';
        } else if (e.response!.statusCode == 401) {
          return '401';
        } else if (e.response!.statusCode == 403) {
          return '403';
        } else if (e.response!.statusCode == 404) {
          return '404';
        } else {
          // Handle other status codes
          return 'Unexpected error';
        }
      } else {
        // Handle other errors
        print('Error during report request: $e');
        return '502';
      }
    } catch (e) {
      print('Error during report request: $e');
      return '500';
    }
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
