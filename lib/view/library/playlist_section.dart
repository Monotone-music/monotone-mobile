import 'package:flutter/material.dart';
import 'package:monotone_flutter/controller/library/playlist_section_loader.dart';
import 'package:monotone_flutter/models/playlist_items.dart';
import 'package:monotone_flutter/view/library/playlist_card_view.dart';

class PlaylistSection extends StatefulWidget {
  final String title;
  final Future<List<PlaylistItem>> Function() fetchItems;

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
            initiallyExpanded: true,
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 22),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: PlaylistCard(playlistItem: item),
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
        ),
        Divider(
          color: Colors.grey.withOpacity(0.3),
          thickness: 1.0,
          height: 25.0,
        ),
      ],
    );
  }
}
