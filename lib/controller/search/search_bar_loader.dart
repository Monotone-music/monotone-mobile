import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:monotone_flutter/models/search_bar_items.dart'; // Import the SearchItem model

class SearchBarLoader {
  final String baseUrl = 'https://api2.ibarakoi.online/search/?q=';

  Future<SearchResults> fetchSearchResults(String query) async {
    // Add a delay to simulate network latency
    await Future.delayed(Duration(seconds: 1));
    final response = await http.get(Uri.parse('$baseUrl$query'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(response.body.length);
      if (jsonResponse['status'] == 'ok') {
        return SearchResults.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load search results');
      }
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
