import 'package:flutter/material.dart';


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
        padding: const EdgeInsets.all(16.0),
        children: [
          // const Text('Hello World'),
          // const SizedBox(height: 16),
          _buildPanel(),
        ],
      ),
    );
  }
///
  Widget _buildPanel(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              
            )
            ///
          ],
        )
        ///
      ],
    );
    ///
  }
}