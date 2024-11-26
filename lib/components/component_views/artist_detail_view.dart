import 'package:flutter/material.dart';
import 'package:monotone_flutter/pages/home.dart';
import 'package:monotone_flutter/pages/release_group.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/components/models/artist_detail_items.dart'; // Import the Artist model
import 'package:monotone_flutter/components/logic_components/artist_detail_loader.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';

// Define the ArtistDetailView widget
class ArtistDetailView extends StatelessWidget {
  final Artist artist;
  final Map<String, String> albumImageUrls;

  ArtistDetailView({required this.artist, required this.albumImageUrls});

  @override
  Widget build(BuildContext context) {
    double height;
    double width;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          _avatarPanel(context),
          _popularPanel(context),
          _albumPanel(context),
          _singleAndExtendedPanel(context),
          _otherArtistPanel(context),
          _featuredInPanel(context),

          ///
        ],
      ),
    ));
  }

  // Widget _buildPanel() {
  //   return Container();
  // }

  ///
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
            height: height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                    'assets/image/rajang.jpg'), // Replace with your image path
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  changePrimary.withOpacity(0.8),
                  BlendMode.dstOut,
                ),
              ),
            ),

            ///
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),

                ///
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: changePrimary, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: ClipOval(
                    child: ImageRenderer(
                      imageUrl: 'assets/image/rajang.jpg',
                      height: (height * 0.17),
                      width: (width * 0.4),
                    ),
                  ),
                ),

                ///
                SizedBox(
                  height: 20,
                ),

                ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(artist.name,
                          style: TextStyle(
                            color: changePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          )),
                    ),
                    Spacer(),
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
            )

            ///
            ),
        SizedBox(
          height: 30,
        ),

        ///
      ],
    );
  }

  ///
  Widget _popularPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<dynamic> allReleases = [];
    allReleases.addAll(artist.featuredIn);
    allReleases.addAll(artist.releaseGroup);

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Text(
            'Popular',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          /// Conditional Check
          if (allReleases.isEmpty)
            Container(
              padding: EdgeInsets.all(16.0),
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

            /// List of Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(allReleases.length, (index) {
                final release = allReleases[index];
                final year =
                    DateTime.parse(release.releaseEvent.date).year.toString();
                final releaseType = release.releaseType[0].toUpperCase() +
                    release.releaseType.substring(1);
                final imageUrl = albumImageUrls[release.id] ??
                    ''; // Get the correct image URL for the release

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () {
                      // Handle tap event
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReleaseGroupPage(
                                  id: release.id,
                                )), // Replace with your navigation target
                      );
                    },
                    child: Row(
                      children: [
                        /// Square Image
                        Container(
                          width: width * 0.2,
                          height: height * 0.1,
                          decoration: BoxDecoration(
                            color: changePrimary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ImageRenderer(
                            imageUrl: imageUrl, // Replace with your image path
                          ),
                        ),
                        SizedBox(width: 16),

                        /// Title, Year, and Release Type
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                release.title, // Replace with your title
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    year, // Replace with your year
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
                                        color: changePrimary.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    releaseType, // Replace with your release type
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

                        /// Icon Button
                        IconButton(
                          icon: ImageRenderer(
                            imageUrl: 'assets/image/vertical_more_icon.svg',
                            width: 50,
                            height: 50,
                          ),
                          onPressed: () {
                            // Handle icon button press
                            print('Icon button pressed for item $index');
                          },
                        ),

                        ///
                      ],
                    ),
                  ),
                );

                ///
              }),
            ),
        ],

        ///
      ),
    );
  }

  ///
  Widget _albumPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<ReleaseGroup> albums = artist.releaseGroup
        .where((release) => release.releaseType.toLowerCase() == 'album')
        .toList();

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Text(
            'Albums',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (albums.isEmpty)
            Container(
              height: height * 0.25,
              padding: EdgeInsets.all(16.0),
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

            /// List of Singles and Compilations
            Container(
              height:
                  height * 0.30, // Increase the height to provide more space
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  final year =
                      DateTime.parse(album.releaseEvent.date).year.toString();
                  final releaseType = album.releaseType[0].toUpperCase() +
                      album.releaseType.substring(1);
                  final imageUrl = albumImageUrls[album.id] ??
                      ''; // Get the correct image URL for the album

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      onTap: () {
                        // Handle tap event
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReleaseGroupPage(
                                  id: album
                                      .id)), // Replace with your navigation target
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Square Image
                          Container(
                              width: width * 0.4,
                              height: width * 0.4,
                              decoration: BoxDecoration(
                                color: changePrimary.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ImageRenderer(imageUrl: imageUrl)),
                          SizedBox(height: 8),

                          /// Album Title
                          Text(
                            album.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),

                          /// Release Type and Year
                          Text(
                            '$releaseType • $year',
                            style: TextStyle(
                              fontSize: 14,
                              color: changePrimary.withOpacity(0.5),
                            ),
                          ),

                          ///
                        ],
                      ),
                    ),
                  );

                  ///
                },
              ),
            ),

          ///
        ],
      ),
    );
  }

  ///
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
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Text(
            'Singles & EPs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (singlesAndCompilations.isEmpty)
            Container(
              padding: EdgeInsets.all(16.0),
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

            /// List of Singles and Compilations
            Container(
              height:
                  height * 0.27, // Increase the height to provide more space
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: singlesAndCompilations.length,
                itemBuilder: (context, index) {
                  final release = singlesAndCompilations[index];
                  final year =
                      DateTime.parse(release.releaseEvent.date).year.toString();
                  final releaseType = release.releaseType[0].toUpperCase() +
                      release.releaseType.substring(1);

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      onTap: () {
                        // Handle tap event
                        print('Single/Compilation $index pressed');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Square Image
                          Container(
                            width: width * 0.3,
                            height: width * 0.3,
                            decoration: BoxDecoration(
                              color: changePrimary.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ImageRenderer(
                              imageUrl: 'assets/image/rajang.jpg',
                            ),
                          ),
                          SizedBox(height: 8),

                          /// Release Title
                          Text(
                            release.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),

                          /// Release Type and Year
                          Text(
                            '$releaseType • $year',
                            style: TextStyle(
                              fontSize: 14,
                              color: changePrimary.withOpacity(0.5),
                            ),
                          ),

                          ///
                        ],
                      ),
                    ),
                  );

                  ///
                },
              ),
            ),

          ///
        ],
      ),
    );
  }

  ///
  ///
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
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Text(
            'Others you may like',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          /// List of Artists
          Container(
            height: height * 0.24, // Set a fixed height for the list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artistNames.length,
              itemBuilder: (context, index) {
                final artistName = artistNames[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  // child: InkWell(
                  //   onTap: () {
                  //     // Handle tap event
                  //     print('Artist $index pressed');
                  //   },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Circular Avatar
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
                      SizedBox(height: 8),

                      /// Artist Name
                      Text(
                        artistName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ///
                    ],
                  ),
                  // ),
                );

                ///
              },
            ),
          ),

          ///
        ],
      ),
    );
  }

  ///
  Widget _featuredInPanel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<FeaturedRelease> appearsIn = artist.featuredIn
        .where((features) => features.title.isNotEmpty)
        .toList();
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appears in',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          /// Conditional Check
          if (appearsIn.isEmpty)
            Container(
              height: height * 0.2,
              padding: EdgeInsets.all(16.0),
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

            /// List of Appears In
            Container(
              height:
                  height * 0.33, // Increase the height to provide more space
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: appearsIn.length,
                itemBuilder: (context, index) {
                  final release = appearsIn[index];
                  final year =
                      DateTime.parse(release.releaseEvent.date).year.toString();
                  final releaseType = release.releaseType[0].toUpperCase() +
                      release.releaseType.substring(1);
                  final imageUrl = albumImageUrls[release.id] ??
                      ''; // Get the correct image URL for the release

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      onTap: () {
                        // Handle tap event
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReleaseGroupPage(
                                    id: release.id,
                                  )), // Replace with your navigation target
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Square Image
                          Container(
                              width: width * 0.4,
                              height: width * 0.4,
                              decoration: BoxDecoration(
                                color: changePrimary.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8.0),
                              ),

                              ///
                              child: ImageRenderer(
                                imageUrl:
                                    imageUrl, // Use the correct image URL for the release
                              )

                              ///
                              ),
                          SizedBox(height: 8),

                          /// Release Title
                          Text(
                            release.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),

                          /// Release Type and Year
                          Text(
                            '$releaseType • $year',
                            style: TextStyle(
                              fontSize: 16,
                              color: changePrimary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  ///
}
