import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:monotone_flutter/components/component_views/search_bar_view.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: const SearchBarView(
            placeholderText:
                'What do you want to play?'), // Replacing with SearchBarView widget
        actions: [
          Container(
            margin: const EdgeInsets.only(
                right: 16.0, top: 8.0), // Adjust the margin as needed
            child: IconButton(
              icon: SvgPicture.asset(
                'image/camera_icon.svg',
                height: MediaQuery.of(context).size.height *
                    0.1, // Adjust the height as needed
                width: MediaQuery.of(context).size.width *
                    0.1, // Adjust the width as needed
              ),
              onPressed: () {
                print('Search Camera button press');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Browse all',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover',
              style: TextStyle(
                fontSize: 16,
                // color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 20.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  childAspectRatio: 1.8, // Aspect ratio of each item
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // Handle category tap
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: category['color'],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          children: [
                            Positioned(
                                bottom: -40,
                                right: -10,
                                child: Transform.rotate(
                                  angle: 0.45,
                                  child: SizedBox(
                                  width:  MediaQuery.of(context).size.width * 0.27,
                                  height: MediaQuery.of(context).size.height * 0.27,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: ImageRenderer(
                                      imageUrl:
                                          'https://toppng.com/uploads/preview/music-icons-musical-note-icon-11563116064s8jezbq5wm.png',
                                      // category['imagePath'], // Use this if you have image paths
                                    ),
                                  ),
                                )
                                  )
                                ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    // fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> categories = [
  {'name': 'Made For You', 'color': Colors.purple, 'imagePath': ''},
  {'name': 'New Releases', 'color': Colors.green, 'imagePath': ''},
  {'name': 'Spotify\'s Classic', 'color': Colors.teal, 'imagePath': ''},
  {'name': 'Charts', 'color': Colors.blue, 'imagePath': ''},
  {'name': 'Trending', 'color': Colors.orange, 'imagePath': ''},
  {'name': 'Discover', 'color': Colors.red, 'imagePath': ''},
  {'name': 'Spotify\'s Singles', 'color': Colors.brown, 'imagePath': ''},
  {'name': 'Decades', 'color': Colors.indigo, 'imagePath': ''},

  // Add more categories as needed
];
