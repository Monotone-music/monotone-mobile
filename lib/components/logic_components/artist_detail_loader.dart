import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:monotone_flutter/components/component_views/artist_detail_view.dart';
import 'package:monotone_flutter/components/models/artist_detail_items.dart'; // Import the Artist model

// Define the ArtistDetailLoader widget
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
    final response = await http.get(Uri.parse('https://api2.ibarakoi.online/artist/$artistId'));
    // print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to load artist data');
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (!jsonResponse.containsKey('data') || !jsonResponse['data'].containsKey('artist')) {
      throw Exception('Artist data not found');
    }

    final artist = Artist.fromJson(jsonResponse['data']['artist']);
    ///Use to fetch Image
    // final Map<String, String> imageCache = {};

    // // Assuming you want to cache images for featured releases and release groups
    // for (var release in artist.featuredIn) {
    //   if (!imageCache.containsKey(release.mbid)) {
    //     final imageResponse = await fetchImage(release.mbid);
    //     imageCache[release.mbid] = imageResponse;
    //   }
    // }

    // for (var release in artist.releaseGroup) {
    //   if (!imageCache.containsKey(release.mbid)) {
    //     final imageResponse = await fetchImage(release.mbid);
    //     imageCache[release.mbid] = imageResponse;
    //   }
    // }

    return artist;
  }

  Future<String> fetchImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    }

    return response.body;
  }

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
          return ArtistDetailView(artist: snapshot.data!);
        } else {
          return Center(child: Text('No artist data available'));
        }
      },
    );
  }
}
