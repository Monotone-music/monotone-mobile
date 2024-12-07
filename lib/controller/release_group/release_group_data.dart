import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/release_group_model.dart';

Future<Map<String, dynamic>> fetchReleaseGroupData(String id) async {
  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  final releaseGroupResponse =
      await httpClient.get(Uri.parse('$BASE_URL/album/id/$id'));

  if (releaseGroupResponse.statusCode != 200) {
    throw Exception('Failed to load release group');
  }

  final responseBody = jsonDecode(releaseGroupResponse.body);
  final releaseGroup = ReleaseGroup.fromJson(responseBody['data']);
  final Map<String, String> imageCache = {};

  for (var track in releaseGroup.tracks) {
    if (!imageCache.containsKey(track.imageUrl)) {
      final imageResponse = track.imageUrl;
      imageCache[track.imageUrl] = imageResponse;
    }
  }

  return {
    'releaseGroup': releaseGroup,
    'imageCache': imageCache,
  };
}
