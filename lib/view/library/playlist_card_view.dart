import 'package:flutter/material.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/models/playlist_items.dart';
import 'package:monotone_flutter/view/library/playlist_detail.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';

class PlaylistCard extends StatefulWidget {
  final PlaylistItem playlistItem;

  const PlaylistCard({required this.playlistItem, super.key});

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

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
              color: const Color.fromARGB(255, 43, 99, 46).withOpacity(0.8),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistPage(id: widget.playlistItem.id),
              ),
            );
          },
          child: Container(
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
                        offset: const Offset(0, -1),
                      ),
                    ],
                    color: const Color.fromARGB(255, 30, 70, 32),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    child: ImageRenderer(
                      imageUrl:
                          '$BASE_URL/image/${widget.playlistItem.imageUrl}',
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ClipRect(
                    child: Column(
                      children: [
                        const SizedBox(width: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                widget.playlistItem.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${widget.playlistItem.trackCount}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 89, 204, 93),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.playlistItem.createdAt.year.toString(),
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white54,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: Transform.rotate(
              angle: 0.75,
              child: const Icon(
                Icons.push_pin_outlined,
                color: Color.fromARGB(255, 89, 204, 93),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
