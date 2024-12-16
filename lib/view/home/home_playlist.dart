import 'dart:developer';

import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
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
    // final httpClient = InterceptedClient.build(interceptors: [
    //   JwtInterceptor(),
    // ], retryPolicy: ExpiredTokenRetryPolicy());

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
              child: ImageRenderer(
                imageUrl: '$BASE_URL/image/$imageUrl',
                width: 60,
                height: 60,
              ),
            ),
            // , height: 50, width: 50),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final textSpan = TextSpan(
                        text: widget.trackItem['title']!,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );

                      final textPainter = TextPainter(
                        text: textSpan,
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      );

                      textPainter.layout(
                          minWidth: 0, maxWidth: constraints.maxWidth);

                      if (textPainter.didExceedMaxLines) {
                        return AutoScrollText(
                          widget.trackItem['title']!,
                          textAlign: TextAlign.left,
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(20, 0)),
                          intervalSpaces: 5,
                          mode: AutoScrollTextMode.endless,
                          delayBefore: const Duration(seconds: 2),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          widget.trackItem['title']!,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 2),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final textSpan = TextSpan(
                        text: widget.trackItem['artistName']!,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      );

                      final textPainter = TextPainter(
                        text: textSpan,
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      );

                      textPainter.layout(
                          minWidth: 0, maxWidth: constraints.maxWidth);

                      if (textPainter.didExceedMaxLines) {
                        return AutoScrollText(
                          widget.trackItem['artistName']!,
                          textAlign: TextAlign.left,
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(20, 0)),
                          intervalSpaces: 5,
                          mode: AutoScrollTextMode.endless,
                          delayBefore: const Duration(seconds: 2),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize:
                                Theme.of(context).textTheme.bodySmall?.fontSize,
                          ),
                        );
                      } else {
                        return Text(
                          widget.trackItem['artistName']!,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize:
                                Theme.of(context).textTheme.bodySmall?.fontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 2),
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
