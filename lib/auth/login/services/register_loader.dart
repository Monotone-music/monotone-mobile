import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/common/api_url.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class RegisterLoader {
  final Uri apiUrl = Uri.parse('$BASE_URL/account/register?type=listener');

  Future<String> register(String username, String password, String email,
      String displayName) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);

    try {
    if (email == null || !_isValidEmail(email)) {
      return 'Invalid email';
    }

      var body = jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'displayName': displayName
      });
      final response = await httpClient.post(
        apiUrl,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 201) {
        // Parse the JSON response
        // print(response);

        // Print the message

        // Return the message
        return '201';
      } else {
        // Handle other status codes here if needed
        return '${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle specific status codes
        if (e.response!.statusCode == 400) {
          print('${e.response!}');
          return '400';
        } else if (e.response!.statusCode == 401) {
          return '401';
        } else {
          // Handle other status codes
          print('Unexpected error: ${e.response!.statusCode}');
          return 'Unexpected error';
        }
      } else {
        // Handle other errors
        print('Error during login request: $e');
        return 'Network error';
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
