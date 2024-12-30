import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/search_bar_items.dart'; // Import the SearchItem model

class SearchBarLoader {
  final String searchUrl = '$BASE_URL/search/?q=';
  final String suggestionsUrl = '$BASE_URL/album/top';

  Future<SearchResults> fetchSuggestion() async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());

    final response = await httpClient.get(Uri.parse(suggestionsUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load top albums');
    }

    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    final List<dynamic> data = jsonResponse['data']['releaseGroup'];
    List<SearchItem> albums = data.map((album) {
      return SearchItem(
        id: album['_id'].toString(),
        score: 0.0,
        source: Source(
          value: album['title'].toString(),
          type: 'album',
          createdAt: DateTime.parse(album['releaseEvent']['date']),
          albumInfo: AlbumInfo(
            releaseEvent: ReleaseEvent.fromJson(album['releaseEvent']),
            id: album['_id'].toString(),
            mbid: album['mbid'].toString(),
            albumArtist: album['releaseType'] == 'compilation'
                ? 'Various Artists'
                : album['albumArtist'].toString(),
            release: [], // Assuming release list is not needed for suggestions
            releaseType: album['releaseType'].toString(),
            title: album['title'].toString(),
            image: mediaImage.fromJson(album['image']),
          ),
        ),
      );
    }).toList();

    return SearchResults(albums: albums, recordings: [], artists: []);
  }

  Future<SearchResults> fetchSearchResults(String query) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());
    // Add a delay to simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    if (query.isEmpty) {
      return SearchResults(albums: [], recordings: [], artists: []);
    }
    final response = await httpClient.get(Uri.parse('$searchUrl$query'));
    // print('response data: ${response.body}');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'ok') {
        return SearchResults.fromJson(responseBody['data']);
      } else {
        throw Exception('Failed to load search results');
      }
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
