import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monotone_flutter/components/models/release_group_model.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';

class ReleaseGroupPage extends StatefulWidget {
  final String artistName;

  ReleaseGroupPage({required this.artistName});

  @override
  _ReleaseGroupPageState createState() => _ReleaseGroupPageState();
}

class _ReleaseGroupPageState extends State<ReleaseGroupPage> {
  late Future<Map<String, dynamic>> releaseGroupData;

  @override
  void initState() {
    super.initState();
    releaseGroupData = fetchReleaseGroupData(widget.artistName);
  }

  Future<Map<String, dynamic>> fetchReleaseGroupData(String artistName) async {
    final releaseGroupResponse =
        await http.get(Uri.parse('https://api2.ibarakoi.online/album/all'));

    if (releaseGroupResponse.statusCode != 200) {
      throw Exception('Failed to load release group');
    }

    final releaseGroup =
        ReleaseGroup.fromJson(json.decode(releaseGroupResponse.body));
    final Map<String, String> imageCache = {};

    for (var track in releaseGroup.tracks) {
      if (!imageCache.containsKey(track.imageUrl)) {
        final imageResponse = await fetchImage(track.imageUrl);
        imageCache[track.imageUrl] = imageResponse;
      }
    }

    return {
      'releaseGroup': releaseGroup,
      'imageCache': imageCache,
    };
  }

  Future<String> fetchImage(String imageUrl) async {
    final response = await http
        .get(Uri.parse('https://api2.ibarakoi.online/image/$imageUrl'));

    if (response.statusCode == 200) {
      final buffer = json.decode(response.body)['data']['buffer']['data'];
      print('Womp womp');
      return base64Encode(List<int>.from(buffer));
    } else {
      throw Exception('Failed to load image');
    }
  }

  String formatDuration(double duration) {
    final minutes = duration ~/ 60;
    final seconds = (duration % 60).toInt();
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: releaseGroupData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Shimmer for Album image with back button
                  Stack(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Shimmer for Album name
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 20,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Shimmer for Tracks
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                title: Container(
                                  height: 20,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                subtitle: Container(
                                  height: 20,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final releaseGroup = snapshot.data!['releaseGroup'];
            final imageCache = snapshot.data!['imageCache'];

            // Calculate total duration
            final totalDuration = releaseGroup.tracks.fold<double>(
                0.0, (double sum, Track track) => sum + track.duration);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Album image with back button
                  Stack(
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(base64Decode(
                                imageCache[releaseGroup.imageUrl])),
                            fit: BoxFit.cover,
                          ),
                        ),
                        //add the gradient effect here
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                //use the app theme color here
                                // themeProvider.getThemeColorPrimary(),
                                Colors.transparent,
                                // themeProvider.getThemeColorPrimary(),
                                themeProvider
                                    .getThemeColorSurface()
                                    .withOpacity(0.3),
                                themeProvider
                                    .getThemeColorSurface()
                                    .withOpacity(0.5),
                                themeProvider
                                    .getThemeColorSurface()
                                    .withOpacity(0.7),
                                themeProvider
                                    .getThemeColorSurface()
                                    .withOpacity(0.9),
                                themeProvider.getThemeColorSurface(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.2), // Background color with opacity
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      //More actions button
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.2), // Background color with opacity
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {
                              // Add more actions here
                            },
                          ),
                        ),
                      ),
                      // Play shuffle button
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -10,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.2), // Background color with opacity

                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.shuffle,
                                color: Colors.white, size: 30),
                            onPressed: () {
                              // Play the album

                              // getIt<PageManager>().playAlbum();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Album name
                  Text(
                    releaseGroup.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  // Artist name
                  Text(
                    releaseGroup.artistName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(height: 8),
                  //release year, total tracks, total duration
                  Text(
                    '${releaseGroup.releaseYear} • ${releaseGroup.tracks.length} tracks • ${formatDuration(totalDuration)}',
                    //Add color to the text

                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Tracks
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: releaseGroup.tracks.length,
                          itemBuilder: (context, index) {
                            final track = releaseGroup.tracks[index];
                            return ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 15,
                                    child: Text(
                                      track.position.toString(),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  // Text(
                                  //   track.position.toString(),
                                  //   textAlign: TextAlign.end,
                                  // ),
                                  const SizedBox(width: 15),
                                  Image.memory(
                                    base64Decode(imageCache[track.imageUrl]),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                              title: Text(
                                track.title,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                '${formatDuration(track.duration)} • ${track.artistName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  // Add more actions here
                                },
                              ),
                              onTap: () {
                                // Play the track
                                // getIt<PageManager>().playTrack(track);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
