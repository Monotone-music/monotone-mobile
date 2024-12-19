import 'package:flutter/material.dart';
import 'package:monotone_flutter/view/library/playlist_section.dart';
import 'package:monotone_flutter/view/search/search_bar_view.dart';
import 'package:monotone_flutter/controller/library/playlist_data_services.dart';
import 'package:monotone_flutter/widgets/image_widgets/image_renderer.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     Container(
      //       width: MediaQuery.of(context).size.width * 0.8,
      //       child: SearchBarView(hintText: 'Search Library'),
      //     ),
      //     Container(
      //       margin: const EdgeInsets.only(right: 16.0, top: 8.0),
      //       child: IconButton(
      //         icon: ImageRenderer(
      //           imageUrl: 'assets/image/add_icon.svg',
      //           height: MediaQuery.of(context).size.height * 0.05,
      //           width: MediaQuery.of(context).size.width * 0.05,
      //         ),
      //         onPressed: () {
      //           print('Library button press');
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // _sortPanel(),
          _buildPanel(),
        ],
      ),
    ));
  }

  Widget _sortPanel() {
    return Column(children: [
      Row(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          IconButton(
            onPressed: () {
              print('group icon pressed');
            },
            icon: ImageRenderer(
              imageUrl: 'assets/image/group_icon.svg',
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.height * 0.05,
            ),
          ),
          const Text(
            "Group",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          IconButton(
            onPressed: () {
              print('group icon pressed');
            },
            icon: ImageRenderer(
              imageUrl: 'assets/image/recent_icon.svg',
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.height * 0.07,
            ),
          ),
          const Text(
            "Recent",
            style: TextStyle(fontSize: 25),
          ),
        ],
      )
    ]);
  }

  Widget _buildPanel() {
    return Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        const PlaylistSection(title: 'Playlists', fetchItems: fetchPlaylists),
      ],
    );
  }
}
