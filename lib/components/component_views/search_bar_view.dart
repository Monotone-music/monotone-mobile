import 'package:flutter/material.dart';

class SearchBarView extends StatefulWidget {
  final Key? key;

  const SearchBarView({this.key}) : super(key: key);
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
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search library',
          hintStyle: TextStyle(
            height: MediaQuery.of(context).size.height * 0.001, // Set a dynamic height
            color: Color.fromARGB(82, 255, 255, 255),
            fontSize: MediaQuery.of(context).size.width * 0.02,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(82, 255, 255, 255),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 27, 27, 27),
        ),
        onChanged: (query) {
          // Handle search query changes
          // print('Search query: $query');   //print out the changed inputs
        },
      ),
    );
  }
}
