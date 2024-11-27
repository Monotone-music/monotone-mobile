import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monotone_flutter/common/api_url.dart';

import 'package:monotone_flutter/models/artist_detail_items.dart';
import 'package:monotone_flutter/view/artist_detail/artist_detail_view.dart';

class ArtistDetailLoader extends StatefulWidget {
  final String artistId;

  ArtistDetailLoader({required this.artistId});

  @override
  _ArtistDetailLoaderState createState() => _ArtistDetailLoaderState();
}

class _ArtistDetailLoaderState extends State<ArtistDetailLoader> {
  late Future<Artist> artistFuture;

  @override
  void initState() {
    super.initState();
    artistFuture = fetchArtistData(widget.artistId);
  }

  Future<Artist> fetchArtistData(String artistId) async {
    final response = await http.get(Uri.parse('$BASE_URL/artist/id/$artistId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load artist data');
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (!jsonResponse.containsKey('data') ||
        !jsonResponse['data'].containsKey('artist')) {
      throw Exception('Artist data not found');
    }

    final artist = Artist.fromJson(jsonResponse['data']['artist']);
    return artist;
  }

  Future<Map<String, String>> fetchImageFilenames(List<String> ids) async {
    final response = await http.get(Uri.parse('$BASE_URL/album'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load album data');
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (!jsonResponse.containsKey('data') ||
        !jsonResponse['data'].containsKey('releaseGroup')) {
      throw Exception('Album data not found');
    }

    final List<dynamic> releaseGroupsJson =
        jsonResponse['data']['releaseGroup'];
    Map<String, String> imageFilenames = {};

    for (final id in ids) {
      for (final releaseGroupJson in releaseGroupsJson) {
        if (releaseGroupJson['_id'] == id) {
          imageFilenames[id] =
              '$BASE_URL/image/${releaseGroupJson['image']['filename']}';
          break;
        }
      }
    }
    return imageFilenames;
  }

  ///
  Future<Map<String, String>> fetchAlbumAndFeaturedImages(
      List<String> albumIds, List<String> featuredIds) async {
    final albumImages = await fetchImageFilenames(albumIds);
    final featuredImages = await fetchImageFilenames(featuredIds);

    return {...albumImages, ...featuredImages};
  }

  ///
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Artist>(
      future: artistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final artist = snapshot.data!;
          final albumIds = artist.releaseGroup
              .map((releaseGroup) => releaseGroup.id)
              .toList();
          final featuredIds = artist.featuredIn
              .map((featuredRelease) => featuredRelease.id)
              .toList();
          return FutureBuilder<Map<String, String>>(
            future: fetchAlbumAndFeaturedImages(albumIds, featuredIds),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (imageSnapshot.hasError) {
                return Center(child: Text('Error: ${imageSnapshot.error}'));
              } else if (imageSnapshot.hasData) {
                final imageFilenames = imageSnapshot.data!;
                return ArtistDetailView(
                    artist: artist, albumImageUrls: imageFilenames);
              } else {
                return Center(child: Text('No artist images available'));
              }
            },
          );
        } else {
          return Center(child: Text('No artist data available'));
        }
      },
    );
  }
}
