import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:monotone_flutter/interceptor/jwt_interceptor.dart';

class LoginLoader {
  final Uri apiUrl = Uri.parse('https://api2.ibarakoi.online/auth/login');

  Future<String> login(String username, String password) async {
    final httpClient = InterceptedClient.build(interceptors: [
      JwtInterceptor(),
    ]);
    try {
      var body = jsonEncode({'username': username, 'password': password});
      final response = await httpClient.post(
        apiUrl,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Return the message
        return 'Login successful';
      } else {
        // Handle other status codes here if needed
        return 'Unexpected status code: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle specific status codes
        if (e.response!.statusCode == 400) {
          return 'Bad Request';
        } else if (e.response!.statusCode == 401) {
          return 'Unauthorized';
        } else if (e.response!.statusCode == 404) {
          return 'Unauthorized';
        } else {
          // Handle other status codes
          return 'Unexpected error: ${e.response!.statusCode}';
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
