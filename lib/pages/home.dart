import 'package:flutter/material.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> _data = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expansion Panel List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
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

  bool _customTileExpanded = false;

  Widget _buildPanel() {
    return Column(
      children: <Widget>[
        _buildExpansionTile()
        // const ExpansionTile(
        //   title: Text('ExpansionTile 1'),
        //   subtitle: Text('Trailing expansion arrow icon'),
        //   children: <Widget>[
        //     ListTile(title: Text('This is tile number 1')),
        //   ],
        // ),
        // ExpansionTile(
        //   title: const Text('Playlists'),
        //   // subtitle: const Text('Custom expansion arrow icon'),
        //   trailing: Icon(
        //     _customTileExpanded
        //         ? Icons.keyboard_arrow_down
        //         : Icons.keyboard_arrow_right,
        //   ),
        //   children: const <Widget>[
        //     ListTile(title: Text('This is tile number 2')),
        //   ],
        //   onExpansionChanged: (bool expanded) {
        //     setState(() {
        //       _customTileExpanded = expanded;
        //     });
        //   },
        // ),
        // const ExpansionTile(
        //   title: Text('ExpansionTile 3'),
        //   subtitle: Text('Leading expansion arrow icon'),
        //   controlAffinity: ListTileControlAffinity.leading,
        //   children: <Widget>[
        //     ListTile(title: Text('This is tile number 3')),
        //   ],
        // ),
      ],
    );
  }

//
  Widget _buildExpansionTile() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: const Text('Playlists'),
        trailing: Icon(
          _customTileExpanded
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_right,
        ),
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(10, (index) {
                return Container(
                  width: 150,
                  height: 220,
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(255, 18, 43, 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 47, 109, 49),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            alignment: Alignment.center, // <---- The magic
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/image/heart_icon.svg',
                              semanticsLabel: 'My SVG Image',
                              // fit: BoxFit.scaleDown,
                              color: Colors.green,
                              width: 50, //set your width and height
                              height: 50,
                            ),
                          )),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Playlist Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            _customTileExpanded = expanded;
          });
        },
      ),
    );
  }
}

class Item {
  Item({
    required this.headerValue,
    this.playlists = const [],
    this.isExpanded = false,
  });

  String headerValue;
  List<String> playlists;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Song $index',
      playlists: List<String>.generate(index, (int index) => 'Playlist $index'),
    );
  });
}
