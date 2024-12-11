import 'package:flutter/material.dart';
import 'package:monotone_flutter/controller/playlist/playlist_controller.dart';
import 'package:monotone_flutter/models/playlist_items.dart';

class PlaylistModal extends StatefulWidget {
  final List<PlaylistItem> playlists;
  final String? recordingId;
  // final String?

  PlaylistModal({required this.playlists, this.recordingId});

  @override
  _PlaylistModalState createState() => _PlaylistModalState();
}

class _PlaylistModalState extends State<PlaylistModal> {
  final TextEditingController _playlistNameController = TextEditingController();
  final PlaylistController _playlistController = PlaylistController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.playlists.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.playlists[index].name),
                onTap: () async {
                  if (widget.recordingId != null) {
                    await _playlistController.addTrackToPlaylist(
                      widget.playlists[index].id,
                      widget.recordingId!,
                    );
                    Navigator.of(context).pop(); // Close the modal
                  }
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _playlistNameController,
              decoration: const InputDecoration(
                labelText: 'New Playlist Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final playlistName = _playlistNameController.text;
              if (playlistName.isNotEmpty) {
                print('recordingId: ${widget.recordingId}');
                await _playlistController.createPlaylist(
                  playlistName,
                  widget.recordingId,
                );
                Navigator.of(context).pop(); // Close the modal
              }
            },
            child: const Text('Create Playlist'),
          ),
        ],
      ),
    );
  }
}
