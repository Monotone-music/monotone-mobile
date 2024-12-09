import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonHome extends StatelessWidget {
  final double screenWidth;
  final bool isDarkMode;

  const SkeletonHome({
    Key? key,
    required this.screenWidth,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          // Skeleton for Playlist items
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10, // Number of skeleton items
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 0.0, // Spacing between columns
              mainAxisSpacing: 0.0, // Spacing between rows
              childAspectRatio: 2.3, // Aspect ratio of each item
            ),
            itemBuilder: (context, index) {
              return Skeletonizer(
                child: Container(
                  width: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: isDarkMode
                        ? const Color(0xFF202020)
                        : const Color(0xFFE4E4E4),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.music_note, size: 50, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 12,
                              width: 90,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 12,
                              width: 90,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 12,
                              width: 90,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
