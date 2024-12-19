import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/view/home/home_ad_section.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/widgets/skeletons/skeleton_home.dart';
import 'package:monotone_flutter/view/login.dart';
import 'package:monotone_flutter/view/home/home_music_sect.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/controller/home/home_playlist_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Map<String, String>>> topReleaseGroup;
  late Future<List<Map<String, String>>> releaseGroups;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    releaseGroups = fetchReleaseGroups('https://api2.ibarakoi.online/album/');
    topReleaseGroup =
        fetchReleaseGroups('https://api2.ibarakoi.online/album/top');
  }

  Future<String?> _getBitrate() async {
    return await _storage.read(key: 'bitrate');
  }

  Future<List<Map<String, String>>> fetchReleaseGroups(String url) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());
    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load release groups');
    }
    var body = jsonDecode(response.body);
    final data = body['data']['releaseGroup'];
    return List<Map<String, String>>.from(data.map((item) => {
          'id': item['_id'].toString(),
          'title': item['title'].toString(),
          'releaseType': item['releaseType'].toString(),
          'releaseYear':
              item['releaseEvent']['date'].substring(0, 4).toString(),
          'artistName': item['releaseType'] == 'compilation'
              ? 'Various Artists'
              : item['albumArtist'].toString(),
          'imageUrl':
              item['image'] != null ? item['image']['filename'].toString() : '',
        }));
  }

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            onTap: _onButtonPressed,
            tabs: const [
              Tab(text: 'Music'),
              // Tab(text: 'Podcasts'),
              // Tab(text: 'Audiobooks'),
            ],
          ),
        ),
        body: FutureBuilder<String?>(
          future: _getBitrate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final bitrate = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (bitrate == '192') 
                    HomeAdSection(),
                    // Top Album Section
                    HomePlaylistSection(
                      title: 'Most Popular Albums',
                      loader: topReleaseGroup,
                    ),
                    // Another Playlist Section
                    HomePlaylistSection(
                      title: 'New Releases',
                      loader: releaseGroups,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
