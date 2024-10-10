import 'package:flutter/material.dart';

import 'package:monotone_flutter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SearchBarView extends StatefulWidget {
  final Key? key;
  final placeholderText;

  const SearchBarView({this.key,required this.placeholderText}) : super(key: key);
  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 40,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF202020) : const Color(0xFFE4E4E4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: widget.placeholderText,
              hintStyle: TextStyle(
                color: isDarkMode
                              ? const Color(0xFF898989)
                              : const Color(0xFF6E6E6E),
                          fontWeight: FontWeight.w400,
                height: MediaQuery.of(context).size.height * 0.0025,
                fontSize:MediaQuery.of(context).size.longestSide * 0.022, // Adjust the multiplier as needed
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              suffixIcon: Opacity(
                opacity: 0.5,
                child:Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color
              ),
            )   
          ),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }
}
