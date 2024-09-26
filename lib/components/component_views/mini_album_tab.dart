import 'package:flutter/material.dart';

class MiniAlbumTab extends StatelessWidget {
  final List<String> albumTitles;
  final List<String> albumCovers;

  MiniAlbumTab({required this.albumTitles, required this.albumCovers});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: albumTitles.length,
      child: Column(
        children: <Widget>[
          TabBar(
            isScrollable: true,
            tabs: albumTitles.map((title) => Tab(text: title)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: albumCovers.map((cover) {
                return Center(
                  child: Image.network(cover),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}