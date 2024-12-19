import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/playlist_items.dart';

Future<List<PlaylistItem>> fetchPlaylists() async {
  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  final response =
      await httpClient.get(Uri.parse('$BASE_URL/listener/profile'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load playlists');
  }

  final responseBody = jsonDecode(response.body);
  final playlists = List<PlaylistItem>.from(responseBody['data']['playlist']
      .map((playlist) => PlaylistItem.fromJson(playlist)));

  return playlists;
}
