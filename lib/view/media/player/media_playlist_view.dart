import 'package:flutter/material.dart';
import 'package:monotone_flutter/widgets/media_widgets/media_components.dart';

Widget buildPlaylist(BuildContext context) {
  return const Column(
    children: [
      Expanded(
        child: Playlist(),
      ),
      // const CurrentSongTitle(),

      // const AddRemoveSongButtons(),
    ],
  );
}
