import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/widgets/skeletons/skeleton_home.dart';
import 'package:monotone_flutter/view/login.dart';
import 'package:monotone_flutter/view/home/home_music_sect.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Map<String, String>>> releaseGroups;

  @override
  void initState() {
    super.initState();
    releaseGroups = fetchReleaseGroups();
  }

  Future<void> _checkFirstTimeUser() async {
    final secureStorage = FlutterSecureStorage();

    if (await secureStorage.read(key: 'isLoggedIn') != 'true') {
      // Navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<List<Map<String, String>>> fetchReleaseGroups() async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());
    final response =
        await httpClient.get(Uri.parse('https://api2.ibarakoi.online/album/'));

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
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            onTap: _onButtonPressed,
            tabs: const [
              Tab(text: 'Music'),
              Tab(text: 'Podcasts'),
              Tab(text: 'Audiobooks'),
            ],
          ),
        ),
        body: Container(
          child: _selectedIndex == 0
              ? FutureBuilder<List<Map<String, String>>>(
                  future: releaseGroups,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // if (true) {
                      return SkeletonHome(
                          screenWidth: screenWidth, isDarkMode: isDarkMode);
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      return PlaylistList(trackItems: snapshot.data!);
                    }
                  },
                )
              : Center(
                  child: Text(
                    _selectedIndex == 1 ? 'Podcasts' : 'Audiobooks',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
        ),
      ),
    );
  }
}
