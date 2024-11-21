import 'package:flutter/material.dart';
import 'package:monotone_flutter/pages/artist_detail.dart';
import 'package:monotone_flutter/components/component_views/search_bar_view.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // const Text('Hello World'),
          // const SizedBox(height: 16),
          _searchPanel(),
          _buildPanel(),
        ],
      ),
    );
  }

  Widget _searchPanel() {
    return const SizedBox(
      child: const SearchBarView(placeholderText: 'Discover'),
      height: 200,
    );
  }

  Widget _buildPanel() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            child: Text("Go to second page"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtistDetailPage(
                    focusOnTextField: false,
                  ),
                ),
              );
            }));
  }
}
