import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

import 'package:monotone_flutter/models/search_bar_items.dart'; // Import the SearchItem model

class SearchBarLoader {
  final String baseUrl = 'https://api2.ibarakoi.online/search/?q=';

  Future<SearchResults> fetchSearchResults(String query) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);
    // Add a delay to simulate network latency
    await Future.delayed(Duration(seconds: 1));
    final response = await httpClient.get(Uri.parse('$baseUrl$query'));
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'ok') {
        return SearchResults.fromJson(responseBody['data']);
      } else {
        throw Exception('Failed to load search results');
      }
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
