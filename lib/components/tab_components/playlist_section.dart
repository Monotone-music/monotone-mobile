import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:monotone_flutter/components/logic_components/playlist_section_generator.dart';

//// Create state for the Playlist Section
class PlaylistSection extends StatefulWidget {
  const PlaylistSection({super.key});

  @override
  State<PlaylistSection> createState() => _PlaylistSectionState();
}

bool _customTileExpanded = false;

/// Create playlist section
class _PlaylistSectionState extends State<PlaylistSection> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: const Text('Playlists'),
        trailing: Icon(
          _customTileExpanded
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_right,
        ),
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 300, // Set a specific height
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: PlaylistSectionGenerator(),
                        ),
                      ],
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
    );
  }
}
