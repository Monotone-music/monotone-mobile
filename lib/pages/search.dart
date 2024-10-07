import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monotone_flutter/components/playlist_list.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                height: 40,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF202020)
                      : const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'What do you want to play?',
                      // border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          color: isDarkMode
                              ? const Color(0xFF898989)
                              : const Color(0xFF6E6E6E),
                          fontWeight: FontWeight.w400),

                      suffixIcon: _searchController.text.isEmpty
                          ? const Icon(Icons.search, color: Colors.grey)
                          : IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                  color: isDarkMode
                      ? const Color(0xFF898989)
                      : const Color(0xFF6E6E6E),
                ),
                onPressed: () {
                  // Handle icon button press
                },
              ),
            )
          ],
        ),
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
                                child: Image.network(
                                  'https://toppng.com/uploads/preview/music-icons-musical-note-icon-11563116064s8jezbq5wm.png',
                                  // 'https://s3-alpha-sig.figma.com/img/a1cb/6053/4f5505f48399778ffca8b276e8241443?Expires=1728259200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=RoM3xhbjENyyZNqYXtwmw2hUWcN8PW7oON9sestMZ8K6e4GxHi6nSK1U7RMm15wTkCKAQdFt2njaNgAxAflookOgY0gaBE3LGV6S5p~ONqIF8OuN4p-FAcooy9RaB7vOL-IaxH3SUSCCLHJ9tFD-GOV8MhE4SeIA6GYHFke7aJFzp3yG6BdkbeY-Ub86oYiK-Ywu5EZXqvrJfxEaz4ZvEmSeLx5jD175XiA32rddxnoPS61gqssw-VyswK2SeKkEv-HVp3bBHzNx~-sH82~hgAmwgfSRLtDTThza0xaG3k3TCrR6QPs~ffxARA4KVl1g-wdjz8KtGp8Sij-10mNRWQ__',
                                  // category['imagePath'], // Use this if you have image paths
                                  fit: BoxFit.contain,
                                  height: 100,
                                ),
                              ),
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
