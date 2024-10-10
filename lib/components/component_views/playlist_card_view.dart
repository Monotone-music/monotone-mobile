import 'package:flutter/material.dart';

import 'package:monotone_flutter/components/models/playlist_items.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';

///Importing playlist model
class PlaylistCard extends StatefulWidget {
  final PlaylistItem playlistItem;

  const PlaylistCard({required this.playlistItem, super.key});

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

////Styling the Playlist Card
class _PlaylistCardState extends State<PlaylistCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: 130,
            height: 230,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 0, 0, 0),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16.0),
              color: const Color.fromARGB(255, 43, 99, 46)
                  .withOpacity(0.8), // Semi-transparent blue box
            ),
          ),
        ),
        Container(
          width: 150,
          height: 230,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: const Color.fromARGB(255, 18, 43, 19),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(1),
                        spreadRadius: 0.1,
                        blurStyle: BlurStyle.solid,
                        blurRadius: 0,
                        offset:
                            const Offset(0, -1), // changes position of shadow
                      ),
                    ],
                    color: const Color.fromARGB(255, 30, 70, 32),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      child: ImageRenderer(imageUrl: widget.playlistItem.picture)
                      )),
              const SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: ClipRect(
                  child: Column(
                    children: [
                      SizedBox(width: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.playlistItem.title,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            widget.playlistItem.amount,
                            style: TextStyle(
                              color: Color.fromARGB(255, 89, 204, 93),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.playlistItem.artist,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white54,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Transform.rotate(
              angle: 0.75, // Rotate by 0.5 radians (approximately 28.6 degrees)
              child: const Icon(
                Icons.push_pin_outlined,
                color: Color.fromARGB(255, 89, 204, 93),
              ),
            ),
          ),
        ),
      ],
    );
}}