import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class RegisterLoader {
  final Uri apiUrl = Uri.parse('https://api2.ibarakoi.online/account/register');

  Future<String> register(String username, String password, String email,
      String displayName) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);
    try {
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
        print('Unexpected status code: ${response.statusCode}');
        return 'Unexpected status code';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle specific status codes
        if (e.response!.statusCode == 400) {
          print(e.response!);
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
    } catch (e) {
      print('Error during login request: $e');
      return 'Unexpected error';
    }
  }
}
