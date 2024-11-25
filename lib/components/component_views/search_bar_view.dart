import 'package:flutter/material.dart';
import 'package:monotone_flutter/pages/release_group.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/components/logic_components/search_bar_loader.dart';
import 'package:monotone_flutter/components/models/search_bar_items.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:monotone_flutter/pages/artist_detail.dart';
import 'package:monotone_flutter/themes/theme_provider.dart';

class SearchBarView extends StatefulWidget {
  final String hintText;

  SearchBarView({required this.hintText});

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onTap: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
          decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: changePrimary.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0),
                borderSide: BorderSide(color: changePrimary.withOpacity(0.1)),
              ),
              suffixIcon: ImageRenderer(
                imageUrl: 'assets/image/search_icon.svg',
              )),
          style: TextStyle(color: changePrimary),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final SearchBarLoader searchBarLoader = SearchBarLoader();
  List<SearchItem> searchResults = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        FocusScope.of(context).unfocus(); // Unfocus the TextField
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
          child: Text('No results found', style: TextStyle(fontSize: 18)));
    }
    return FutureBuilder<SearchResults>(
      future: searchBarLoader.fetchSearchResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 18)));
        } else if (!snapshot.hasData ||
            snapshot.data!.albums.isEmpty &&
                snapshot.data!.recordings.isEmpty &&
                snapshot.data!.artists.isEmpty) {
          return Center(
              child: Text('No results found', style: TextStyle(fontSize: 18)));
        } else {
          searchResults = [
            ...snapshot.data!.albums,
            ...snapshot.data!.recordings,
            ...snapshot.data!.artists,
          ];
          return ListView(
            children: _buildSuggestions(context),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder<SearchResults>(
      future: searchBarLoader.fetchSearchResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 18)));
        } else if (!snapshot.hasData ||
            snapshot.data!.albums.isEmpty &&
                snapshot.data!.recordings.isEmpty &&
                snapshot.data!.artists.isEmpty) {
          return Center(
              child:
                  Text('No suggestions found', style: TextStyle(fontSize: 18)));
        } else {
          searchResults = [
            ...snapshot.data!.albums,
            ...snapshot.data!.recordings,
            ...snapshot.data!.artists,
          ];
          return ListView(
            children: _buildSuggestions(context),
          );
        }
      },
    );
  }

  List<Widget> _buildSuggestions(BuildContext context) {
    List<Widget> suggestions = [];

    var albums =
        searchResults.where((item) => item.source.type == 'album').toList();
    if (albums.isNotEmpty) {
      suggestions.addAll(_buildList(context, 'Albums', albums));
    }

    var songs =
        searchResults.where((item) => item.source.type == 'recording').toList();
    if (songs.isNotEmpty) {
      suggestions.addAll(_buildList(context, 'Songs', songs));
    }

    var artists =
        searchResults.where((item) => item.source.type == 'artist').toList();
    if (artists.isNotEmpty) {
      suggestions.addAll(_buildArtistList(context, 'Artists', artists));
    }

    return suggestions;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Iterable<Widget> _buildList(
      BuildContext context, String title, Iterable<SearchItem> items) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final changePrimary = themeProvider.getThemeColorPrimary();

    List<Widget> list = [];
    if (items.isNotEmpty) {
      list.add(_buildSectionTitle(title));
      list.addAll(items.map((item) {
        String imageUrl;
        if (item.source.type == 'album') {
          // print(
          //     'https://api2.ibarakoi.online/image/${item.source.albumInfo!.image.filename}');
          imageUrl = item.source.albumInfo?.image != null
              ? 'https://api2.ibarakoi.online/image/${item.source.albumInfo!.image.filename}'
              : 'assets/image/not_available.png';
        } else if (item.source.type == 'recording') {
          imageUrl = item.source.recordingInfo?.image != null
              ? 'https://api2.ibarakoi.online/image/${item.source.recordingInfo!.image.filename}'
              : 'assets/image/not_available.png';
        } else {
          imageUrl = 'assets/image/not_available.png';
        }

        ///
        return InkWell(
          onTap: () {
            if (item.source.type == 'album') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ReleaseGroupPage(id: item.source.albumInfo!.id),
                ),
              );
            } // Handle item tap
            if (item.source.type == 'recording') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistDetailPage(
                        artistId: item.source.recordingInfo!.artists[0].id),
                  ));
            }
          },

          ///
          child: ListTile(
            leading: ImageRenderer(
              imageUrl: imageUrl,
              width: 50,
              height: 50,
            ),
            title: Text(item.source.value ?? 'No title',
                style: TextStyle(fontSize: 24)),
            subtitle: Text(
              item.source.type != null
                  ? '${item.source.type![0].toUpperCase()}${item.source.type!.substring(1)}'
                  : 'No type',
              style: TextStyle(
                  fontSize: 16, color: changePrimary.withOpacity(0.5)),
            ),
          ),
        );

        ///
      }));
    }
    return list;
  }

  Iterable<Widget> _buildArtistList(
      BuildContext context, String title, Iterable<SearchItem> items) {
    List<Widget> list = [];
    if (items.isNotEmpty) {
      list.add(_buildSectionTitle(title));
      list.addAll(items.map((item) {
        return InkWell(
          onTap: () {
            if (item.source.artistInfo != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArtistDetailPage(artistId: item.source.artistInfo!.id),
                ),
              );
            }
            // Handle item tap
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/image/rajang.jpg'),
              radius: 25,
            ),
            title: Text(item.source.value ?? 'No title',
                style: TextStyle(fontSize: 18)),
            subtitle: Text(item.source.type ?? 'No type',
                style: TextStyle(fontSize: 16)),
          ),
        );
      }));
    }
    return list;
  }
}
