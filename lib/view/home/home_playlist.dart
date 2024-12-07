import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:monotone_flutter/view/release_group/release_group.dart';
import 'package:monotone_flutter/common/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PlaylistMini extends StatefulWidget {
  final Map<String, String> trackItem;

  const PlaylistMini({super.key, required this.trackItem});

  @override
  State<PlaylistMini> createState() => _PlaylistMiniState();
}

class _PlaylistMiniState extends State<PlaylistMini> {
  late String _id;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    _id = widget.trackItem['id'] ?? '';
    imageUrl = widget.trackItem['imageUrl'] ?? 'assets/image/not_available.png';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageUrl = widget.trackItem['imageUrl'];
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);

    return GestureDetector(
      onTap: () async {
        // Handle tap
        // navigate push to the release group page with the id
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReleaseGroupPage(
              id: _id,
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: isDarkMode ? const Color(0xFF202020) : const Color(0xFFE4E4E4),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FutureBuilder<Response>(
                future: httpClient.get(
                  Uri.parse('https://api2.ibarakoi.online/image/$imageUrl'),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                    return SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.error),
                    );
                  } else if (snapshot.hasData) {
                    final imageData = snapshot.data?.bodyBytes;
                    if (imageData != null) {
                      return ImageRenderer(
                        imageUrl: imageData,
                        width: 60,
                        height: 60,
                      );
                    } else {
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/image/not_available.png'),
                      );
                    }
                  } else {
                    return SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/image/not_available.png'),
                    );
                  }
                },
              ),
            ),
            // , height: 50, width: 50),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.trackItem['title']!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.trackItem['artistName']!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.trackItem['releaseYear']!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
