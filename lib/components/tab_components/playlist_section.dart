import 'package:flutter/material.dart';

import 'package:monotone_flutter/components/logic_components/playlist_section_loader.dart';
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
    return Column(
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 22), // Adjust the font size as needed
            ),
            trailing: Icon(
              _customTileExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
            ),
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Add space between items
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.35, // Set a specific height
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          child: PlaylistSectionGenerator(
                              fetchItems: widget
                                  .fetchItems), // Use PlaylistSectionGenerator to display the items
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() {
                _customTileExpanded = expanded;
              });
            },
          ),
        ),
        Divider(
          color: Colors.grey.withOpacity(0.3), // Faded line color
          thickness: 1.0, // Line thickness
          height: 25.0, // Space around the divider
        ),
      ],
    );
  }
}
