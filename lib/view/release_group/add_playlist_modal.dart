import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:monotone_flutter/controller/playlist/playlist_controller.dart';
import 'package:monotone_flutter/models/playlist_items.dart';

class PlaylistModal extends StatefulWidget {
  final List<PlaylistItem> playlists;
  final String? recordingId;

  PlaylistModal({required this.playlists, this.recordingId});

  @override
  _PlaylistModalState createState() => _PlaylistModalState();
}

class _PlaylistModalState extends State<PlaylistModal> {
  final TextEditingController _playlistNameController = TextEditingController();
  final PlaylistController _playlistController = PlaylistController();
  String? _errorMessage;

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
                try {
                  await _playlistController.createPlaylist(
                    playlistName,
                    widget.recordingId,
                  );
                  Navigator.of(context).pop(); // Close the modal
                } catch (e) {
                  setState(() {
                    _errorMessage = e.toString().replaceFirst('Exception: ', '');
                  });
                }
              }
            },
            child: const Text('Create Playlist'),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  text: 'There can only be 3 playlists in a free account, ',
                  style: const TextStyle(color: Colors.red),
                  children: [
                    TextSpan(
                      text: 'upgrade here',
                      style: const TextStyle(
                        color: Colors.blue,
                        // decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          GoRouter.of(context).go('/profile');
                        },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
