import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';
import 'package:monotone_flutter/models/search_bar_items.dart'; // Import the SearchItem model

class SearchBarLoader {
  final String baseUrl = '$BASE_URL/search/?q=';

  Future<SearchResults> fetchSearchResults(String query) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());
    // Add a delay to simulate network latency
    await Future.delayed(Duration(seconds: 1));
    if (query.isEmpty) {
      return SearchResults(albums: [], recordings: [], artists: []);
    }
    final response = await httpClient.get(Uri.parse('$baseUrl$query'));
    // print('response data: ${response.body}');
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
