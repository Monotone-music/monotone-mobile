import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';

class SearchBarView extends StatefulWidget {
  final String placeholderText;
  const SearchBarView({required this.placeholderText});

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  bool isDark = false;
  List<SingleItem> items = [
    SingleItem(
      productImage: 'assets/image/rajang.jpg',
      trackName: 'Track 1',
      artist: 'Artist 1',
    ),
    SingleItem(
      productImage: 'assets/image/rajang.jpg',
      trackName: 'Track 2',
      artist: 'Artist 2',
    ),
    SingleItem(
      productImage: 'assets/image/rajang.jpg',
      trackName: 'Track 3',
      artist: 'Artist 3',
    ),
    SingleItem(
      productImage: 'assets/image/rajang.jpg',
      trackName: 'Track 4',
      artist: 'Artist 4',
    ),
    SingleItem(
      productImage: 'assets/image/rajang.jpg',
      trackName: 'Track 5',
      artist: 'Artist 5',
    ),
  ];

  List<SingleItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void filterResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = items;
      });
    } else {
      setState(() {
        filteredItems = items
            .where((item) =>
                item.trackName.toLowerCase().contains(query.toLowerCase()) ||
                item.artist.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                hintText: widget.placeholderText,
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (query) {
                  filterResults(query);
                  controller.openView();
                },
                trailing: <Widget>[
                  ImageRenderer(
                    imageUrl: 'assets/image/search_icon.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(filteredItems.length, (int index) {
                final singleItem = filteredItems[index];

                return ListTile(
                  leading: Hero(
                    tag: singleItem.productImage,
                    child: SizedBox(
                        child: ImageRenderer(
                          width: 50,
                          height: 50,
                          imageUrl: singleItem.productImage,
                        ),
                      ),
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: singleItem.trackName,
                          style: TextStyle(),
                        ),
                        TextSpan(
                          text: ' by ',
                          style: TextStyle(
                            color: changePrimary.withOpacity(0.6),
                          ),
                        ),
                        TextSpan(
                          text: singleItem.artist,
                          style: TextStyle(
                            color: changePrimary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      controller.closeView(singleItem.trackName);
                    });
                  },
                );
              });
            },
          ),
        ),
      ),
    );
  }
}

class SingleItem {
  final String productImage;
  final String trackName;
  final String artist;

  SingleItem({
    required this.productImage,
    required this.trackName,
    required this.artist,
  });
}