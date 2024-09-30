import 'package:flutter/material.dart';

class PlaylistListView extends StatelessWidget {
  final List<Widget> children;

 PlaylistListView({required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: children,
    );
  }
}