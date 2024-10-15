import 'package:flutter/material.dart';

import 'package:monotone_flutter/components/logic_components/playlist_section_generator.dart';
import 'package:monotone_flutter/components/models/playlist_items.dart';

class PlaylistSection extends StatefulWidget {
  final String title;
  final Future<List<PlaylistItem>> Function()
      fetchItems; // Function to fetch items

  const PlaylistSection(
      {super.key, required this.title, required this.fetchItems});

  @override
  State<PlaylistSection> createState() => _PlaylistSectionState();
}

class _PlaylistSectionState extends State<PlaylistSection> {
  bool _customTileExpanded = false;
  late Future<List<PlaylistItem>> playlistItemsFuture;

  @override
  void initState() {
    super.initState();
    playlistItemsFuture = widget.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style:
              const TextStyle(fontSize: 22), // Adjust the font size as needed
        ),
        trailing: Icon(
          _customTileExpanded
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_right,
        ),
        children: <Widget>[
          FutureBuilder<List<PlaylistItem>>(
            future: playlistItemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No items found'));
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: snapshot.data!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0), // Add space between items
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.3, // Set a dynamic height
                          width: MediaQuery.of(context).size.width,
                          child: PlaylistSectionGenerator(
                              fetchItems: widget
                                  .fetchItems), // Pass the item to PlaylistSectionGenerator                        ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            _customTileExpanded = expanded;
          });
        },
      ),
    );
  }
}
