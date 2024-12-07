import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';
import 'package:shimmer/shimmer.dart';

Widget buildMainPlayer(BuildContext context, MyAudioHandler mediaPlayerProvider,
    imageUrl, title, artistName) {
  print('main Player: ${imageUrl}');
  final httpClient = InterceptedClient.build(interceptors: [
    JwtInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());
  return Container(
    height: MediaQuery.of(context).size.height,
    padding: const EdgeInsets.all(1.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Album Cover
        SizedBox(
          width: 350,
          height: 350,
          child: FutureBuilder<Response>(
            future: httpClient.get(
              Uri.parse(
                'https://api2.ibarakoi.online/image/$imageUrl',
              ),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 350,
                    height: 350,
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.error);
              } else if (snapshot.hasData) {
                final imageData = snapshot.data?.bodyBytes;
                if (imageData is Uint8List) {
                  return ImageRenderer(
                    imageUrl: imageData,
                    width: 350,
                    height: 350,
                  );
                }else{
                   return Image.asset('assets/image/not_available.png',
                    width: 350, height: 350);
                }
              } else {
                return Image.asset('assets/image/not_available.png',
                    width: 350, height: 350);
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        // Song Title and Artist
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0), // Add padding to both sides
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title, // Replace with actual song title
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFDBDBDB),
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      artistName, // Replace with actual artist name
                      style: const TextStyle(
                          fontSize: 16, color: Color(0xFF898989)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.favorite_border, color: Color(0xFF898989)),
                onPressed: () {
                  // Implement favorite functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.playlist_add, color: Color(0xFF898989)),
                onPressed: () {
                  // Implement add to playlist functionality
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
