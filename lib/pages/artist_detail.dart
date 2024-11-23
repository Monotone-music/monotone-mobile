import 'package:flutter/material.dart';

import 'package:monotone_flutter/components/logic_components/artist_detail_loader.dart';


class ArtistDetailPage extends StatefulWidget {
  ArtistDetailPage({Key? key, this.focusOnTextField}) : super(key: key);

  bool? focusOnTextField;
  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Artist Detail Page")),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          _buildPanel(),
        ],
      ),
    );
  }
///
   ///
  Widget _buildPanel() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width *1,
              height: MediaQuery.of(context).size.height * 1 ,
              child: ArtistDetailLoader(artistId: '6740a1246357c3ed99dedfac'),
            ),
            ///
          ],
        ),
        ///
      ],
    );
    ///
  }
  ///
}