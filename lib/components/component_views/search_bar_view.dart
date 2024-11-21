import 'dart:math';

import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/widgets/image_renderer.dart';
import 'package:provider/provider.dart';

import 'package:monotone_flutter/themes/theme_provider.dart';

// class SearchBarView extends StatefulWidget {
//   final String placeholderText;

//   const SearchBarView({required this.placeholderText});

//   @override
//   _SearchBarViewState createState() => _SearchBarViewState();
// }

// class _SearchBarViewState extends State<SearchBarView> {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   OverlayEntry? _overlayEntry;
//   List<String> _searchResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         _showOverlay();
//       } else {
//         _removeOverlay();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _showOverlay() {
//     final overlay = Overlay.of(context);
//     _overlayEntry = _createOverlayEntry();
//     overlay?.insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);

//     return OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height,
//         width: size.width,
//         child: Material(
//           elevation: 4.0,
//           child: ListView(
//             padding: EdgeInsets.zero,
//             shrinkWrap: true,
//             children: _searchResults.map((result) {
//               return ListTile(
//                 title: Text(result),
//                 onTap: () {
//                   _searchController.text = result;
//                   _removeOverlay();
//                 },
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onSearchChanged(String query) {
//     // Simulate search results
//     setState(() {
//       _searchResults = List.generate(5, (index) => '$query result $index');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;

//     return Padding(
//       padding: EdgeInsets.all(6.0),
//       child: Container(
//         margin: const EdgeInsets.only(top: 10),
//         height: 40,
//         decoration: BoxDecoration(
//           color: isDarkMode ? const Color(0xFF202020) : const Color(0xFFE4E4E4),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: TextField(
//             controller: _searchController,
//             focusNode: _focusNode,
//             decoration: InputDecoration(
//               hintText: widget.placeholderText,
//               hintStyle: TextStyle(
//                 color: isDarkMode
//                               ? const Color(0xFF898989)
//                               : const Color(0xFF6E6E6E),
//                           fontWeight: FontWeight.w400,
//                 height: MediaQuery.of(context).size.height * 0.0025,
//                 fontSize:MediaQuery.of(context).size.longestSide * 0.022, // Adjust the multiplier as needed
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               suffixIcon: Opacity(
//                 opacity: 0.5,
//                 child:Icon(
//                 Icons.search,
//                 color: Theme.of(context).iconTheme.color
//               ),
//             )
//           ),
//             style: TextStyle(
//               color: Theme.of(context).textTheme.bodyLarge?.color,
//             ),
//             ///
//             onChanged: _onSearchChanged,
//             ///
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// SearchBarView StatefulWidget
// class SearchBarView extends StatefulWidget {
//   final String placeholderText;

//   const SearchBarView({required this.placeholderText});

//   @override
//   _SearchBarViewState createState() => _SearchBarViewState();
// }

// class _SearchBarViewState extends State<SearchBarView> {
//   TextEditingController searchController = TextEditingController();
//   List<searchItems> items = searchItemsList;
//   List<searchItems> _searchResults = [];

//   ///
//   void searchTerms(String query) {
//     final input = query.toLowerCase();

//     final suggestion = items.where((item) {
//       final trackInput = item.trackName.toLowerCase();
//       final artistInput = item.artist.toLowerCase();

//       // Check if the input matches either the track name or the artist
//       return trackInput.contains(input) || artistInput.contains(input);
//     }).toList();

//     setState(() {
//       _searchResults = suggestion;
//       query.isEmpty ? items = searchItemsList : items = suggestion;
//     });
//   }

//   ///
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final changePrimary = themeProvider.getThemeColorPrimary();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("KILL YOURSELF!!"),
//       ),

//       ///
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               TextField(
//                 controller: searchController,
//                 onTapOutside: (event) =>
//                     FocusManager.instance.primaryFocus!.unfocus(),
//                 decoration: InputDecoration(
//                     hintText: widget.placeholderText,
//                     suffixIcon: ImageRenderer(
//                         imageUrl: 'assets/image/search_icon.svg')),
//                 onChanged: searchTerms,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Expanded(
//                   child: ListView.builder(
//                 itemCount: 5,
//                 itemBuilder: (context, index) {
//                   final singleItem = items[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: ListTile(
//                       leading: Hero(
//                         tag: singleItem.profileAvatar,
//                         child: SizedBox(
//                           child: ClipOval(
//                             child: ImageRenderer(
//                               width: 50,
//                               height: 50,
//                               imageUrl: singleItem.profileAvatar,
//                             ),
//                           ),
//                         ),
//                       ),

//                       ///
//                       title: Text.rich(TextSpan(
//                         children: [
//                           TextSpan(
//                             text: singleItem.trackName,
//                             style: TextStyle(),
//                           ),

//                           ///
//                           TextSpan(
//                               text: ' by ',
//                               style: TextStyle(
//                                   color: changePrimary.withOpacity(0.6))),

//                           ///
//                           TextSpan(
//                               text: singleItem.artist,
//                               style: TextStyle(
//                                   color: changePrimary.withOpacity(0.6)))
//                         ],
//                       )),
//                     ),
//                   );

//                   ///
//                 },
//               )

//                   ///
//                   )
//             ],
//           ),
//         ),

//         ///
//       ),

//       ///
//     );
//   }

//   ///
// }

// class searchItems {
//   final String trackName;
//   final String artist;
//   final String profileAvatar;
//   searchItems(
//       {required this.profileAvatar,
//       required this.trackName,
//       required this.artist});
// }

// // Create a list of SearchItem objects with diverse data
// List<searchItems> searchItemsList = [
//   searchItems(
//       profileAvatar:
//           'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//       trackName: 'Bohemian Rhapsody',
//       artist: 'Queen'),
//   searchItems(
//       profileAvatar:
//           'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//       trackName: 'Imagine',
//       artist: 'John Lennon'),
//   searchItems(
//       profileAvatar:
//           'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//       trackName: 'Hotel California',
//       artist: 'Eagles'),
//   searchItems(
//       profileAvatar:
//           'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//       trackName: 'Stairway to Heaven',
//       artist: 'Led Zeppelin'),
//   searchItems(
//       profileAvatar:
//           'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//       trackName: 'Hey Jude',
//       artist: 'The Beatles'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Like a Rolling Stone',
//   //     artist: 'Bob Dylan'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Smells Like Teen Spirit',
//   //     artist: 'Nirvana'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'What\'s Going On',
//   //     artist: 'Marvin Gaye'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Billie Jean',
//   //     artist: 'Michael Jackson'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Purple Haze',
//   //     artist: 'Jimi Hendrix'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Respect',
//   //     artist: 'Aretha Franklin'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Good Vibrations',
//   //     artist: 'The Beach Boys'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Johnny B. Goode',
//   //     artist: 'Chuck Berry'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'Superstition',
//   //     artist: 'Stevie Wonder'),
//   // searchItems(
//   //     profileAvatar:
//   //         'https://t4.ftcdn.net/jpg/07/08/47/75/360_F_708477508_DNkzRIsNFgibgCJ6KoTgJjjRZNJD4mb4.jpg',
//   //     trackName: 'I Will Always Love You',
//   //     artist: 'Whitney Houston'),
// ];


class SearchBarView extends StatefulWidget {
  final String placeholderText;
  const SearchBarView({required this.placeholderText});

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
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
              onChanged: (_) {
                controller.openView();
              },
              trailing: <Widget>[
                ImageRenderer(
                  imageUrl: 'assets/image/search_icon.svg'
                  )
              ],
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
          }),
        ),
      ),
    );
  }
}