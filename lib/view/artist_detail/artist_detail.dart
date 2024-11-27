import 'package:flutter/material.dart';
import 'package:monotone_flutter/controller/artist_detail/artist_detail_loader.dart';

class ArtistDetailPage extends StatefulWidget {
  final String artistId;
  final bool? focusOnTextField;

  ArtistDetailPage({Key? key, required this.artistId, this.focusOnTextField})
      : super(key: key);

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          _buildPanel(),
        ],
      ),
    );
  }

  Widget _buildPanel() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ArtistDetailLoader(artistId: widget.artistId),
            ),
          ],
        ),
      ],
    );
  }
}
