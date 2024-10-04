import 'package:flutter/material.dart';

class MediaToolbar extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onClose; // Add a callback for the close button

  const MediaToolbar({
    Key? key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onClose, // Add the onClose parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: onPlayPause,
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: onClose, // Add the onClose callback
          ),
        ],
      ),
    );
  }
}
