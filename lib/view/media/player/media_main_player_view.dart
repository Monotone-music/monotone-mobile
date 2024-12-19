import 'package:flutter/material.dart';
import 'package:monotone_flutter/controller/media/services/audio_handler.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';

Widget buildMainPlayer(BuildContext context, MyAudioHandler mediaPlayerProvider,
    imageUrl, title, artistName) {
  final isAdvertisement = artistName == 'Advertisement';

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
            child: ImageRenderer(
              imageUrl: imageUrl,
            )),
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
              if (!isAdvertisement)
                IconButton(
                  icon: const Icon(Icons.favorite_border,
                      color: Color(0xFF898989)),
                  onPressed: () {
                    // Implement favorite functionality
                  },
                ),
              if (!isAdvertisement)
                IconButton(
                  icon:
                      const Icon(Icons.playlist_add, color: Color(0xFF898989)),
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
