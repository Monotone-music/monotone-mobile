import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/personal_playlist_items.dart';

Future<Map<String, dynamic>> fetchPlaylistData(String id) async {
  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  print('request url = $BASE_URL/playlist/$id');

  final playlistResponse =
      await httpClient.get(Uri.parse('$BASE_URL/playlist/$id'));

  if (playlistResponse.statusCode != 200) {
    throw Exception('Failed to load playlist');
  }

  final responseBody = jsonDecode(playlistResponse.body);
  print('responseBody = ${responseBody['data']['playlist']}');
  final playlist = Playlist.fromJson(responseBody['data']['playlist']);
  final Map<String, String> imageCache = {};

  for (var recording in playlist.recordings) {
    if (!imageCache.containsKey(recording.recording.image.filename)) {
      final imageResponse = recording.recording.image.filename;
      imageCache[recording.recording.image.filename] = imageResponse;
    }
  }

  return {
    'playlist': playlist,
    'imageCache': imageCache,
  };
}
