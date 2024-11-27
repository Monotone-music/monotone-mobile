import 'package:http/http.dart' as http;
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/models/release_group_model.dart';
import 'dart:convert';

Future<Map<String, dynamic>> fetchReleaseGroupData(String id) async {
  final releaseGroupResponse =
      await http.get(Uri.parse('$BASE_URL/album/id/$id'));

  if (releaseGroupResponse.statusCode != 200) {
    throw Exception('Failed to load release group');
  }

  final releaseGroup =
      ReleaseGroup.fromJson(json.decode(releaseGroupResponse.body)['data']);
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
