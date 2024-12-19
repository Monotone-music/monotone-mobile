import 'package:flutter/material.dart';
import 'package:monotone_flutter/widgets/skeletons/skeleton_home.dart';
import 'package:provider/provider.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:monotone_flutter/view/home/home_playlist.dart';

class HomePlaylistSection extends StatelessWidget {
  final String title;
  final Future<List<Map<String, String>>> loader;

  const HomePlaylistSection(
      {super.key, required this.title, required this.loader});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FutureBuilder<List<Map<String, String>>>(
          future: loader,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonHome(
                  screenWidth: screenWidth, isDarkMode: isDarkMode);
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load $title'));
            } else if (snapshot.hasData) {
              final items = snapshot.data!;
              final int itemCount = items.length;
              final int gridCount =
                  (itemCount / 4).ceil(); // Number of grids needed

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(gridCount, (gridIndex) {
                    final int startIndex = gridIndex * 4;
                    final int endIndex = (startIndex + 4).clamp(0, itemCount);

                    return Container(
                      width: screenWidth,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 1.7,
                        ),
                        itemCount: endIndex - startIndex,
                        itemBuilder: (context, index) {
                          return PlaylistMini(
                              trackItem: items[startIndex + index]);
                        },
                      ),
                    );
                  }),
                ),
              );
            } else {
              return Center(child: Text('No $title found'));
            }
          },
        ),
      ],
    );
  }
}
