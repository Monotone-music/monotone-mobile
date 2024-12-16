import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/view/release_group/release_group.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/models/artist_detail_items.dart'; // Import the Artist model
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:shimmer/shimmer.dart';

// Define the ArtistDetailView widget
class ArtistDetailView extends StatelessWidget {
  final Artist artist;
  final Map<String, String> albumImageUrls;

  ArtistDetailView({required this.artist, required this.albumImageUrls});

  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  ///
  @override
  Widget build(BuildContext context) {
    double height;
    double width;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          _avatarPanel(context),
          _popularPanel(context),
          _albumPanel(context),
          _singleAndExtendedPanel(context),
          // _otherArtistPanel(context),
          _featuredInPanel(context),
        ],
      ),
    );
  }

  Widget _avatarPanel(BuildContext context) {
    double height;
    double width;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    return Column(
      children: [
        Container(
            width: double.infinity,
            height: 370,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://api2.ibarakoi.online/image/${artist.image.filename}'), // Use the actual image URL
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  changePrimary.withOpacity(0.8),
                  BlendMode.dstOut,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: changePrimary, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: CircleAvatar(
                    radius: (width * 0.3),
                    backgroundImage: NetworkImage(
                      'https://api2.ibarakoi.online/image/${artist.image.filename}', // Use the actual image URL
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(artist.name,
                          style: TextStyle(
                            color: changePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          )),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          print('Artist Detail Play Button Pressed');
                        },
                        icon: ImageRenderer(
                            height: height * 0.05,
                            width: width * 0.05,
                            imageUrl: 'assets/image/play_button_icon.svg')),
                  ],
                ),
              ],
            )),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _popularPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<dynamic> allReleases = [];
    allReleases.addAll(artist.featuredIn);
    allReleases.addAll(artist.releaseGroup);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (allReleases.isEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'This artist has not released anything yet!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: changePrimary.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(allReleases.length, (index) {
                final release = allReleases[index];
                final year =
                    DateTime.parse(release.releaseEvent.date).year.toString();
                final releaseType = release.releaseType[0].toUpperCase() +
                    release.releaseType.substring(1);
                final imageUrl = albumImageUrls[release.id] ?? '';

                return FutureBuilder<Response>(
                  future: httpClient.get(
                    Uri.parse(imageUrl),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        leading: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(release.title,
                            style: const TextStyle(fontSize: 24)),
                        subtitle: Text(
                          releaseType,
                          style: TextStyle(
                              fontSize: 16,
                              color: changePrimary.withOpacity(0.5)),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: const Icon(Icons.error),
                        title: Text(release.title,
                            style: const TextStyle(fontSize: 24)),
                        subtitle: Text(
                          releaseType,
                          style: TextStyle(
                              fontSize: 16,
                              color: changePrimary.withOpacity(0.5)),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final imageData = snapshot.data?.bodyBytes;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReleaseGroupPage(
                                      id: release.id,
                                    )),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.2,
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                color: changePrimary.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ImageRenderer(
                                imageUrl: imageData,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    release.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        year,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: changePrimary.withOpacity(0.5),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          '•',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                changePrimary.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        releaseType,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: changePrimary.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: ImageRenderer(
                                imageUrl: 'assets/image/vertical_more_icon.svg',
                                width: 50,
                                height: 50,
                              ),
                              onPressed: () {
                                print('Icon button pressed for item $index');
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListTile(
                        leading: Image.asset('assets/image/not_available.png',
                            width: 50, height: 50),
                        title: Text(release.title,
                            style: const TextStyle(fontSize: 24)),
                        subtitle: Text(
                          releaseType,
                          style: TextStyle(
                              fontSize: 16,
                              color: changePrimary.withOpacity(0.5)),
                        ),
                      );
                    }
                  },
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _albumPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<ReleaseGroup> albums = artist.releaseGroup
        .where((release) => release.releaseType.toLowerCase() == 'album')
        .toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Albums',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (albums.isEmpty)
            Container(
              height: height * 0.25,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'This artist has not released their own album yet!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: changePrimary.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: height * 0.30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  final year =
                      DateTime.parse(album.releaseEvent.date).year.toString();
                  final releaseType = album.releaseType[0].toUpperCase() +
                      album.releaseType.substring(1);
                  final imageUrl = albumImageUrls[album.id] ?? '';
                  return FutureBuilder<Response>(
                    future: httpClient.get(
                      Uri.parse(imageUrl),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: width * 0.4,
                            height: width * 0.4,
                            color: Colors.white,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          decoration: BoxDecoration(
                            color: changePrimary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(child: Icon(Icons.error)),
                        );
                      } else if (snapshot.hasData) {
                        final imageData = snapshot.data?.bodyBytes;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReleaseGroupPage(id: album.id)),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.4,
                                height: width * 0.4,
                                decoration: BoxDecoration(
                                  color: changePrimary.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ImageRenderer(
                                  imageUrl: imageData,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.4,
                                child: Text(
                                  album.title,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // SizedBox(height: 4),
                              Text(
                                '$releaseType • $year',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: changePrimary.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          decoration: BoxDecoration(
                            color: changePrimary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Image.asset('assets/image/not_available.png',
                              fit: BoxFit.cover),
                        );
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _singleAndExtendedPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<ReleaseGroup> singlesAndCompilations =
        artist.releaseGroup.where((release) {
      final releaseType = release.releaseType.toLowerCase();
      return releaseType == 'single' || releaseType == 'compilation';
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Singles & EPs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (singlesAndCompilations.isEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'This artist has not released any singles or compilations yet!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: changePrimary.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: height * 0.27,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: singlesAndCompilations.length,
                itemBuilder: (context, index) {
                  final release = singlesAndCompilations[index];
                  final year =
                      DateTime.parse(release.releaseEvent.date).year.toString();
                  final releaseType = release.releaseType[0].toUpperCase() +
                      release.releaseType.substring(1);
                  final imageUrl = albumImageUrls[release.id] ?? '';

                  return FutureBuilder<Response>(
                    future: httpClient.get(
                      Uri.parse(imageUrl),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: width * 0.3,
                          height: width * 0.3,
                          decoration: BoxDecoration(
                            color: changePrimary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          width: width * 0.3,
                          height: width * 0.3,
                          decoration: BoxDecoration(
                            color: changePrimary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(child: Icon(Icons.error)),
                        );
                      } else if (snapshot.hasData) {
                        final imageData = snapshot.data?.bodyBytes;
                        return InkWell(
                          onTap: () {
                            print('Single/Compilation $index pressed');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.3,
                                height: width * 0.3,
                                decoration: BoxDecoration(
                                  color: changePrimary.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ImageRenderer(
                                  imageUrl: imageData,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                release.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$releaseType • $year',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: changePrimary.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          width: width * 0.3,
                          height: width * 0.3,
                          decoration: BoxDecoration(
                            color: changePrimary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Image.asset('assets/image/not_available.png',
                              fit: BoxFit.cover),
                        );
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _otherArtistPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    // Sample data for artist names
    List<String> artistNames = [
      'Artist 1',
      'Artist 2',
      'Artist 3',
      'Artist 4',
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Others you may like',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: height * 0.24,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artistNames.length,
              itemBuilder: (context, index) {
                final artistName = artistNames[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.35,
                        height: width * 0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: changePrimary.withOpacity(0.6),
                        ),
                        child: ClipOval(
                          child: ImageRenderer(
                            imageUrl: 'assets/image/rajang.jpg',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        artistName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuredInPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<FeaturedRelease> appearsIn = artist.featuredIn
        .where((features) => features.title.isNotEmpty)
        .toList();
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appears in',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (appearsIn.isEmpty)
            Container(
              height: height * 0.28,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'This artist does not appear in any releases yet!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: changePrimary.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 450,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: appearsIn.length,
                itemBuilder: (context, index) {
                  final release = appearsIn[index];
                  final year =
                      DateTime.parse(release.releaseEvent.date).year.toString();
                  final releaseType = release.releaseType[0].toUpperCase() +
                      release.releaseType.substring(1);
                  final imageUrl = albumImageUrls[release.id] ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: FutureBuilder<Response>(
                      future: httpClient.get(
                        Uri.parse(imageUrl),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            width: width * 0.4,
                            height: width * 0.4,
                            decoration: BoxDecoration(
                              color: changePrimary.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Center(child: Icon(Icons.error)),
                          );
                        } else if (snapshot.hasData) {
                          final imageData = snapshot.data?.bodyBytes;
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReleaseGroupPage(
                                          id: release.id,
                                        )),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: width * 0.4,
                                  height: width * 0.4,
                                  decoration: BoxDecoration(
                                    color: changePrimary.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ImageRenderer(
                                    imageUrl: imageData,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  release.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$releaseType • $year',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: changePrimary.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            width: width * 0.4,
                            height: width * 0.4,
                            decoration: BoxDecoration(
                              color: changePrimary.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset('assets/image/not_available.png',
                                fit: BoxFit.cover),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
